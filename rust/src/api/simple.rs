use image::{load_from_memory_with_format, ImageFormat, RgbaImage, Rgba};
use std::io::Cursor;
use std::sync::OnceLock;

pub enum DitherMethod {
    FloydSteinberg,
    FalseFloydSteinberg,
    Stucki,
    Atkinson,
    Threshold,
    Halftone,
    Bayer,
    Sierra2,
    Burkes,
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

const BLACK: Colorf32 = Colorf32 { r: 0.0, g: 0.0, b: 0.0 };
const WHITE: Colorf32 = Colorf32 { r: 255.0, g: 255.0, b: 255.0 };
const RED: Colorf32 = Colorf32 { r: 255.0, g: 0.0, b: 0.0 };

const DITHER_GAMMA: f32 = 1.5;

#[inline(always)]
fn apply_dither_gamma(c: f32) -> f32 {
    (c / 255.0).powf(DITHER_GAMMA) * 255.0
}

fn dither_gamma_lut() -> &'static [f32; 256] {
    static LUT: OnceLock<[f32; 256]> = OnceLock::new();
    LUT.get_or_init(|| {
        let mut lut = [0.0f32; 256];
        for (i, v) in lut.iter_mut().enumerate() {
            *v = apply_dither_gamma(i as f32);
        }
        lut
    })
}

/// Specialized closest color for black/white palette (2 colors).
#[inline(always)]
fn closest_color_bw(pixel: Colorf32) -> Colorf32 {
    // Squared Euclidean distance to black vs white.
    // Black: r² + g² + b²
    // White: (r-255)² + (g-255)² + (b-255)² = r²+g²+b² - 510*(r+g+b) + 3*255²
    // Prefer black when dist_black <= dist_white
    // => 0 <= -510*(r+g+b) + 3*65025
    // => r+g+b <= (3*65025)/510 ≈ 382.5
    let sum = pixel.r + pixel.g + pixel.b;
    if sum <= 382.5 {
        BLACK
    } else {
        WHITE
    }
}

/// Specialized closest color for black/white/red palette (3 colors).
#[inline(always)]
fn closest_color_bwr(pixel: Colorf32) -> Colorf32 {
    let dr_b = pixel.r;
    let dg_b = pixel.g;
    let db_b = pixel.b;
    let dist_black = dr_b * dr_b + dg_b * dg_b + db_b * db_b;

    let dr_w = pixel.r - 255.0;
    let dg_w = pixel.g - 255.0;
    let db_w = pixel.b - 255.0;
    let dist_white = dr_w * dr_w + dg_w * dg_w + db_w * db_w;

    let dr_r = pixel.r - 255.0;
    let dg_r = pixel.g;
    let db_r = pixel.b;
    let dist_red = dr_r * dr_r + dg_r * dg_r + db_r * db_r;

    if dist_black <= dist_white && dist_black <= dist_red {
        BLACK
    } else if dist_white <= dist_red {
        WHITE
    } else {
        RED
    }
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
    let pixel_count = (width * height) as usize;

    // Convert to floating-point buffer
    let mut buffer: Vec<Colorf32> = Vec::with_capacity(pixel_count);
    buffer.extend(img.pixels().map(|p| Colorf32 {
        r: p[0] as f32,
        g: p[1] as f32,
        b: p[2] as f32,
    }));

    // Apply gamma (except for pure Threshold)
    if !matches!(method, DitherMethod::Threshold) {
        let gamma_lut = dither_gamma_lut();
        for px in buffer.iter_mut() {
            // Safe because input is 0-255 from u8
            px.r = gamma_lut[px.r as usize];
            px.g = gamma_lut[px.g as usize];
            px.b = gamma_lut[px.b as usize];
        }
    }

    let w = width as i32;
    let h = height as i32;

    // Main dithering loop – specialized closest-color path
    for y in 0..h {
        for x in 0..w {
            let idx = (y * w + x) as usize;
            let old_pixel = buffer[idx];

            let quant_input = match method {
                DitherMethod::Bayer => {
                    let t = (BAYER_8X8[(y & 7) as usize][(x & 7) as usize] + 0.5) / 64.0 - 0.5;
                    let off = t * 255.0;
                    Colorf32 {
                        r: old_pixel.r + off,
                        g: old_pixel.g + off,
                        b: old_pixel.b + off,
                    }
                }
                _ => old_pixel,
            };

            let new_pixel = if is_bwr {
                closest_color_bwr(quant_input)
            } else {
                closest_color_bw(quant_input)
            };

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
                DitherMethod::Sierra2 => {
                    let w16 = 1.0 / 16.0;
                    distribute_error(&mut buffer, x, y, w, h, 1, 0, err_r, err_g, err_b, 4.0 * w16);
                    distribute_error(&mut buffer, x, y, w, h, 2, 0, err_r, err_g, err_b, 3.0 * w16);
                    distribute_error(&mut buffer, x, y, w, h, -2, 1, err_r, err_g, err_b, 1.0 * w16);
                    distribute_error(&mut buffer, x, y, w, h, -1, 1, err_r, err_g, err_b, 2.0 * w16);
                    distribute_error(&mut buffer, x, y, w, h, 0, 1, err_r, err_g, err_b, 3.0 * w16);
                    distribute_error(&mut buffer, x, y, w, h, 1, 1, err_r, err_g, err_b, 2.0 * w16);
                    distribute_error(&mut buffer, x, y, w, h, 2, 1, err_r, err_g, err_b, 1.0 * w16);
                }
                DitherMethod::Burkes => {
                    let w32 = 1.0 / 32.0;
                    distribute_error(&mut buffer, x, y, w, h, 1, 0, err_r, err_g, err_b, 8.0 * w32);
                    distribute_error(&mut buffer, x, y, w, h, 2, 0, err_r, err_g, err_b, 4.0 * w32);
                    distribute_error(&mut buffer, x, y, w, h, -2, 1, err_r, err_g, err_b, 2.0 * w32);
                    distribute_error(&mut buffer, x, y, w, h, -1, 1, err_r, err_g, err_b, 4.0 * w32);
                    distribute_error(&mut buffer, x, y, w, h, 0, 1, err_r, err_g, err_b, 8.0 * w32);
                    distribute_error(&mut buffer, x, y, w, h, 1, 1, err_r, err_g, err_b, 4.0 * w32);
                    distribute_error(&mut buffer, x, y, w, h, 2, 1, err_r, err_g, err_b, 2.0 * w32);
                }
            }
        }
    }

    // Fast output construction – build raw RGBA buffer then wrap
    let mut raw = Vec::with_capacity(pixel_count * 4);
    for c in &buffer {
        raw.push(c.r.clamp(0.0, 255.0) as u8);
        raw.push(c.g.clamp(0.0, 255.0) as u8);
        raw.push(c.b.clamp(0.0, 255.0) as u8);
        raw.push(255);
    }

    let out_img = RgbaImage::from_raw(width, height, raw)
        .expect("Failed to create image from raw buffer");

    let mut png_bytes: Vec<u8> = Vec::new();
    out_img
        .write_to(&mut Cursor::new(&mut png_bytes), ImageFormat::Png)
        .expect("Failed to encode PNG");
    png_bytes
}

#[inline(always)]
fn distribute_error(
    buffer: &mut [Colorf32],
    x: i32,
    y: i32,
    w: i32,
    h: i32,
    dx: i32,
    dy: i32,
    err_r: f32,
    err_g: f32,
    err_b: f32,
    weight: f32,
) {
    let nx = x + dx;
    let ny = y + dy;
    if nx >= 0 && nx < w && ny >= 0 && ny < h {
        let idx = (ny * w + nx) as usize;
        // Safety: bounds already checked
        let px = unsafe { buffer.get_unchecked_mut(idx) };
        px.r += err_r * weight;
        px.g += err_g * weight;
        px.b += err_b * weight;
    }
}
