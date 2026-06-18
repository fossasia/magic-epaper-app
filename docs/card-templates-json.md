# Card templates as editable JSON

## Goal

Store each card template (Employee ID, Price Tag, …) in a readable, declarative
JSON format instead of hardcoding it in Dart, so that:

1. **Every element of a template is editable in the ePaper editor** — not just
   text. Today, when a template is sent to the editor, text lines are tap-to-edit
   (they become `TextLayer`s) but the **profile photo** and the **barcode/QR**
   are baked-in `WidgetLayer`s that can only be moved/scaled, not re-edited. The
   JSON describes the *type* of each element so the editor knows how to edit it.
2. Templates become **data, not code** — new templates (and eventually
   user-authored ones) can be added/edited without touching ~700-line Dart form
   files.

This document is the design proposal for the issue "store card templates as
JSON / a readable format to let users edit ePaper views".

## Current architecture (before this change)

Each template is three hardcoded Dart files in `lib/card_templates/`:

| File | Responsibility |
| --- | --- |
| `<name>_model.dart` | Immutable data holder |
| `<name>_form.dart` | ~700-line form: inputs, validation, live preview |
| `<name>_card_widget.dart` | The in-form preview card |

On submit, the form builds a `List<LayerSpec>` and pushes
`MovableBackgroundImageExample(initialLayers: …)` (the editor). Per-display-size
geometry comes from `lib/card_templates/util/responsive_layout_util.dart`.

In the editor, `LayerSpec.text` → `TextLayer` (editable) and `LayerSpec.widget`
→ `WidgetLayer` (photo / barcode — **not** editable).

## What this branch implements

### Part A — tap any template element to edit it back in the form

Goal (per mentor): tapping **any** template element in the editor — text, photo
or barcode/QR — returns to the form where the user entered the details and the
live preview is shown. The user changes the data there and presses "Generate"
again; the badge is rebuilt from the updated data. This centralises all content
editing in the form. This works for **all** existing templates, independent of
JSON:

- `LayerSpec` (`lib/util/template_util.dart`) carries a `kind`
  (`text` / `image` / `barcode` / `generic`) and an `elementId`, and exposes
  `toLayerMeta()`. The editor tags every template layer's `Layer.meta` with it
  so it can tell template elements apart from content the user adds inside the
  editor.
- **Photo & barcode/QR** (`WidgetLayer`s) are wrapped in a tap handler
  (`_wrapEditable`) whose tap returns to the form (`_returnToForm`). On mobile
  the pro_image_editor layer *selection* is disabled, so taps would otherwise
  route to the built-in edit branch (text/paint only) and widget layers would
  be inert. `StickerEditorCallbacks.onTapEditSticker` does the same for the
  desktop selection path. Dragging still moves the layer (a tap yields to a
  drag).
- **Text** is tagged in `meta` and intercepted via
  `MainEditorCallbacks.onEditTextLayer`: a tap on template text returns to the
  form too. Text the user *adds inside the editor* (via the "Text" tool) has no
  template meta, so it keeps the built-in in-place text editor.
- `_returnToForm()` does an imperative `Navigator.pop()`, which bypasses the
  editor's close-confirmation `PopScope` exactly like the "Done" flow does. The
  form sits underneath on the navigation stack with its controllers and picked
  image intact, so it reappears pre-filled.

> **Known trade-off (accepted for now):** returning to the form and
> regenerating rebuilds the badge from scratch, so layer repositioning, canvas
> colour, paint strokes and any extra images added *inside* the editor are not
> preserved across the round-trip. Preserving editor-side arrangement is a
> larger follow-up.

### Part B — the JSON template format (this document's subject)

- `lib/card_templates/json/template_definition.dart` — `TemplateDefinition` and
  `TemplateElementDefinition` models with `fromJson` / `toJson` + validation.
- `lib/card_templates/json/template_repository.dart` — loads templates from
  bundled assets (and, later, the app documents directory for user templates).
- `assets/card_templates/{employee_id,price_tag,event_badge,entry_pass_tag}.json`
  — all four built-in templates expressed in the new format.

## JSON schema

```jsonc
{
  "version": 1,                      // schema version, for future migrations
  "id": "employee_id",               // stable id; matches the asset file name
  "title": "Employee ID Card",
  "description": "…",
  "icon": "badge_outlined",          // Material icon name (selection grid)
  "color": "blue",                   // accent colour name (selection grid)
  "elements": [
    {
      "id": "profileImage",          // stable id == layout key == editor id
      "type": "image",               // text | image | barcode
      "label": "Profile Photo",
      "props": { "width": 200, "height": 200, "shape": "oval" }
    },
    {
      "id": "companyName",
      "type": "text",
      "label": "Company Name",
      "props": { "bold": true, "align": "center", "color": "black" }
    },
    {
      "id": "qr",
      "type": "barcode",
      "label": "QR Code Data",
      "props": { "barcodeName": "QR-Code" }   // matches Barcode.name
    }
  ]
}
```

### Why layout (offset/scale) is **not** in the JSON

The app supports many ePaper display sizes (416×240, 296×128, 800×480, …).
Pixel offsets/scales differ per size and already live in
`ResponsiveLayoutUtil`, keyed by element id. Keeping geometry out of the JSON
lets one template render correctly on every display. Element `id`s are the join
key between the JSON and the layout table.

### `props` by type

- **text** — `prefixKey` (l10n key for a label prefix, e.g. `namePrefix`),
  `bold`, `align` (`left|center|right`), `color`.
- **image** — `width`, `height` of the image box; `shape` (`oval` | `rounded`)
  and `radius` (when rounded). Used to rebuild the widget when re-editing.
- **barcode** — `barcodeName` (must equal `Barcode.name`, e.g. `QR-Code`,
  `CODE 128`); resolved back to a `Barcode` via `BarcodeEditor.barcodeFromName`.

## Storage location

- **Built-in templates**: read-only JSON under `assets/card_templates/`
  (registered in `pubspec.yaml`).
- **User templates** (follow-up): JSON files in the app documents directory,
  seeded from the bundled ones on first launch, so edits/imports persist. The
  repository is structured to add this without changing the models.

## Planned migration (follow-up PRs)

1. A generic `TemplateLayerBuilder` that turns a `TemplateDefinition` + user
   values into the tagged `List<LayerSpec>` (replacing the per-form `_submitForm`
   layer-building blocks).
2. A data-driven selection grid built from `TemplateRepository.loadBundled()`
   instead of the hardcoded list in `card_template_selection_view.dart`.
3. Optionally, a generic form that renders inputs from a template's elements,
   shrinking the per-template Dart to near zero.

These are deliberately **not** in this branch: the format should get mentor
sign-off first, since later work builds on it.

## Open questions for mentors

- Is bundled-assets + documents-dir the right storage split, or should built-in
  templates also be user-overridable?
- Should `props` carry localisation keys (current approach) or fully localised
  strings baked per locale?
- Do we want an in-app visual template editor, or is "edit elements in the
  ePaper editor + import/export JSON" enough for the stated goal?
