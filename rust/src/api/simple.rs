use image::{load_from_memory_with_format, ImageFormat, RgbaImage, Rgba};
use std::io::Cursor;

pub enum DitherMethod {
    FloydSteinberg,
    FalseFloydSteinberg,
    Stucki,
    Atkinson,
    Threshold,
    Halftone,
    Bayer,
}

const BAYER_8X8: [[f32; 8]; 8] = [
    [ 0.0, 32.0,  8.0, 40.0,  2.0, 34.0, 10.0, 42.0],
    [48.0, 16.0, 56.0, 24.0, 50.0, 18.0, 58.0, 26.0],
    [12.0, 44.0,  4.0, 36.0, 14.0, 46.0,  6.0, 38.0],
    [60.0, 28.0, 52.0, 20.0, 62.0, 30.0, 54.0, 22.0],
    [ 3.0, 35.0, 11.0, 43.0,  1.0, 33.0,  9.0, 41.0],
    [51.0, 19.0, 59.0, 27.0, 49.0, 17.0, 57.0, 25.0],
    [15.0, 47.0,  7.0, 39.0, 13.0, 45.0,  5.0, 37.0],
    [63.0, 31.0, 55.0, 23.0, 61.0, 29.0, 53.0, 21.0],
];

#[derive(Clone, Copy)]
struct Colorf32 {
    r: f32,
    g: f32,
    b: f32,
}

const PALETTE_BW: [Colorf32; 2] = [
    Colorf32 { r: 0.0, g: 0.0, b: 0.0 },
    Colorf32 { r: 255.0, g: 255.0, b: 255.0 },
];

const PALETTE_BWR: [Colorf32; 3] = [
    Colorf32 { r: 0.0, g: 0.0, b: 0.0 },
    Colorf32 { r: 255.0, g: 255.0, b: 255.0 },
    Colorf32 { r: 255.0, g: 0.0, b: 0.0 },
];

fn closest_color(pixel: Colorf32, palette: &[Colorf32]) -> Colorf32 {
    let mut min_dist = f32::MAX;
    let mut best_color = palette[0];

    for c in palette {
        let dr = pixel.r - c.r;
        let dg = pixel.g - c.g;
        let db = pixel.b - c.b;
        let dist = dr * dr + dg * dg + db * db;

        if dist < min_dist {
            min_dist = dist;
            best_color = *c;
        }
    }
    best_color
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}

pub fn process_image_rust(
    image_bytes: Vec<u8>,
    target_width: u32,
    target_height: u32,
    method: DitherMethod,
    is_bwr: bool,
) -> Vec<u8> {
    let dynamic_img = load_from_memory_with_format(&image_bytes, ImageFormat::Png)
        .expect("Failed to decode image")
        .resize_exact(target_width, target_height, image::imageops::FilterType::Nearest);

    let img = dynamic_img.to_rgba8();
    let (width, height) = img.dimensions();

    let mut buffer: Vec<Colorf32> = img.pixels()
        .map(|p| Colorf32 { r: p[0] as f32, g: p[1] as f32, b: p[2] as f32 }).collect();

    let palette = if is_bwr { &PALETTE_BWR[..] } else { &PALETTE_BW[..] };

    let w = width as i32;
    let h = height as i32;

    for y in 0..h {
        for x in 0..w {
            let idx = (y * w + x) as usize;
            let old_pixel = buffer[idx];

            let quant_input = match method {
                DitherMethod::Bayer => {
                    let t = (BAYER_8X8[(y & 7) as usize][(x & 7) as usize] + 0.5) / 64.0 - 0.5;
                    let off = t * 255.0;
                    Colorf32 { r: old_pixel.r + off, g: old_pixel.g + off, b: old_pixel.b + off }
                }
                _ => old_pixel,
            };

            let new_pixel = closest_color(quant_input, palette);

            buffer[idx] = new_pixel;

            let err_r = old_pixel.r - new_pixel.r;
            let err_g = old_pixel.g - new_pixel.g;
            let err_b = old_pixel.b - new_pixel.b;

            match method {
                DitherMethod::Threshold | DitherMethod::Bayer => {}
               
                DitherMethod::FloydSteinberg | DitherMethod::Halftone => {
                    distribute_error(&mut buffer, x, y, w, h, 1, 0, err_r, err_g, err_b, 7.0 / 16.0);
                    distribute_error(&mut buffer, x, y, w, h, -1, 1, err_r, err_g, err_b, 3.0 / 16.0);
                    distribute_error(&mut buffer, x, y, w, h, 0, 1, err_r, err_g, err_b, 5.0 / 16.0);
                    distribute_error(&mut buffer, x, y, w, h, 1, 1, err_r, err_g, err_b, 1.0 / 16.0);
                }
                DitherMethod::FalseFloydSteinberg => {
                    distribute_error(&mut buffer, x, y, w, h, 1, 0, err_r, err_g, err_b, 3.0 / 8.0);
                    distribute_error(&mut buffer, x, y, w, h, 0, 1, err_r, err_g, err_b, 3.0 / 8.0);
                    distribute_error(&mut buffer, x, y, w, h, 1, 1, err_r, err_g, err_b, 2.0 / 8.0);
                }
                DitherMethod::Atkinson => {
                    let w8 = 1.0 / 8.0;
                    distribute_error(&mut buffer, x, y, w, h, 1, 0, err_r, err_g, err_b, w8);
                    distribute_error(&mut buffer, x, y, w, h, 2, 0, err_r, err_g, err_b, w8);
                    distribute_error(&mut buffer, x, y, w, h, -1, 1, err_r, err_g, err_b, w8);
                    distribute_error(&mut buffer, x, y, w, h, 0, 1, err_r, err_g, err_b, w8);
                    distribute_error(&mut buffer, x, y, w, h, 1, 1, err_r, err_g, err_b, w8);
                    distribute_error(&mut buffer, x, y, w, h, 0, 2, err_r, err_g, err_b, w8);
                }
                DitherMethod::Stucki => {
                    let w42 = 1.0 / 42.0;
                    distribute_error(&mut buffer, x, y, w, h, 1, 0, err_r, err_g, err_b, 8.0 * w42);
                    distribute_error(&mut buffer, x, y, w, h, 2, 0, err_r, err_g, err_b, 4.0 * w42);
                    distribute_error(&mut buffer, x, y, w, h, -2, 1, err_r, err_g, err_b, 2.0 * w42);
                    distribute_error(&mut buffer, x, y, w, h, -1, 1, err_r, err_g, err_b, 4.0 * w42);
                    distribute_error(&mut buffer, x, y, w, h, 0, 1, err_r, err_g, err_b, 8.0 * w42);
                    distribute_error(&mut buffer, x, y, w, h, 1, 1, err_r, err_g, err_b, 4.0 * w42);
                    distribute_error(&mut buffer, x, y, w, h, 2, 1, err_r, err_g, err_b, 2.0 * w42);
                    distribute_error(&mut buffer, x, y, w, h, -2, 2, err_r, err_g, err_b, 1.0 * w42);
                    distribute_error(&mut buffer, x, y, w, h, -1, 2, err_r, err_g, err_b, 2.0 * w42);
                    distribute_error(&mut buffer, x, y, w, h, 0, 2, err_r, err_g, err_b, 4.0 * w42);
                    distribute_error(&mut buffer, x, y, w, h, 1, 2, err_r, err_g, err_b, 2.0 * w42);
                    distribute_error(&mut buffer, x, y, w, h, 2, 2, err_r, err_g, err_b, 1.0 * w42);
                }
            }
        }
    }

    let mut out_img = RgbaImage::new(width, height);
    for y in 0..height {
        for x in 0..width {
            let idx = (y * width + x) as usize;
            let c = buffer[idx];
            out_img.put_pixel(
                x, y,
                Rgba([c.r.clamp(0.0, 255.0) as u8, c.g.clamp(0.0, 255.0) as u8, c.b.clamp(0.0, 255.0) as u8, 255]),
            );
        }
    }

    let mut png_bytes: Vec<u8> = Vec::new();
    out_img.write_to(&mut Cursor::new(&mut png_bytes), ImageFormat::Png).expect("Failed to encode PNG");
    png_bytes
}

#[inline(always)]
fn distribute_error(buffer: &mut Vec<Colorf32>, x: i32, y: i32, w: i32, h: i32, dx: i32, dy: i32, err_r: f32, err_g: f32, err_b: f32, weight: f32) {
    let nx = x + dx;
    let ny = y + dy;
    if nx >= 0 && nx < w && ny >= 0 && ny < h {
        let idx = (ny * w + nx) as usize;
        buffer[idx].r += err_r * weight;
        buffer[idx].g += err_g * weight;
        buffer[idx].b += err_b * weight;
    }
}