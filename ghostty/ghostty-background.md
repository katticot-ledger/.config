# Ghostty Background Options

## `background`
- Sets the window's base color.
- Accepts hex (`#RRGGBB` or `RRGGBB`) or a named X11 color.

## `background-image`
- Path to a PNG or JPEG used behind terminal content.
- Image is applied per terminal split until future updates change this.
- Large images increase VRAM usage because each terminal stores its own copy.
- Available since Ghostty 1.2.0.

## `background-image-opacity`
- Scales the opacity of the background image relative to `background-opacity`.
- `1.0` (default) applies the image over the background color, then applies `background-opacity` to the result.
- `< 1.0` mixes the image with the background color before applying `background-opacity`.
- `> 1.0` makes the image more opaque than the base color (`final = background-opacity * background-image-opacity`).
- Available since Ghostty 1.2.0.

