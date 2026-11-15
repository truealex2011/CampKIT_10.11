from PIL import Image
import numpy as np
import os

SRC_PATH = r"C:\Users\truea\Desktop\CampusKIT\Лайки_Изображения....webp"
OUT_DIR = r"C:\Users\truea\Desktop\CampusKIT\campuslife_app\assets\icons"


def detect_band_boxes(arr: np.ndarray, y0: int, y1: int, gap: int = 12):
    alpha = arr[:, :, 3] > 8
    sub = alpha[y0:y1, :]
    cols = np.where(sub.any(axis=0))[0]
    splits = np.where(np.diff(cols) > gap)[0]
    starts = [int(cols[0])] + [int(cols[s + 1]) for s in splits]
    ends = [int(cols[s]) + 1 for s in splits] + [int(cols[-1]) + 1]
    boxes = []
    for x0, x1 in zip(starts, ends):
        rows = np.where(alpha[y0:y1, x0:x1].any(axis=1))[0]
        ry0 = y0 + int(rows[0])
        ry1 = y0 + int(rows[-1]) + 1
        hi = arr[ry0:ry1, x0:x1, 3] > 80
        hy, hx = np.where(hi)
        cx = x0 + float(hx.mean()) if len(hx) else (x0 + x1) / 2.0
        cy = ry0 + float(hy.mean()) if len(hy) else (ry0 + ry1) / 2.0
        boxes.append((x0, ry0, x1, ry1, cx, cy))
    return boxes


def crop_centered_square(
    img: Image.Image,
    box: tuple[int, int, int, int, float, float],
    capture_side: int,
    target_side: int,
) -> Image.Image:
    x0, y0, x1, y1, cx, cy = box
    # Include slight margin around detected bbox without bleeding into neighbors
    pad = 2
    sx0 = max(0, x0 - pad)
    sy0 = max(0, y0 - pad)
    sx1 = min(img.width, x1 + pad)
    sy1 = min(img.height, y1 + pad)
    patch = img.crop((sx0, sy0, sx1, sy1))

    canvas = Image.new("RGBA", (capture_side, capture_side), (0, 0, 0, 0))
    dest_x = int(round(capture_side / 2.0 - (cx - sx0)))
    dest_y = int(round(capture_side / 2.0 - (cy - sy0)))
    canvas.alpha_composite(patch, (max(0, dest_x), max(0, dest_y)))
    if capture_side != target_side:
        canvas = canvas.resize((target_side, target_side), Image.Resampling.LANCZOS)
    return canvas


def crop_padded_rect(
    img: Image.Image,
    box: tuple[int, int, int, int, float, float],
    pad: int = 4,
) -> Image.Image:
    x0, y0, x1, y1, _, _ = box
    sx0 = max(0, x0 - pad)
    sy0 = max(0, y0 - pad)
    sx1 = min(img.width, x1 + pad)
    sy1 = min(img.height, y1 + pad)
    return img.crop((sx0, sy0, sx1, sy1))


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    img = Image.open(SRC_PATH).convert("RGBA")
    arr = np.array(img)
    print(f"Loaded sprite sheet: {img.size}")

    b0 = detect_band_boxes(arr, 15, 215)   # 8 main circular buttons
    b1 = detect_band_boxes(arr, 220, 425)  # 8 secondary/active circular buttons
    b2 = detect_band_boxes(arr, 435, 570)  # 4 swipe capsules
    b3 = detect_band_boxes(arr, 585, 740)  # 10 small circular buttons
    b4 = detect_band_boxes(arr, 755, 880)  # 12 standalone glyphs & play buttons

    assert len(b0) == 8, f"Expected 8 sprites in band 0, got {len(b0)}"
    assert len(b1) == 8, f"Expected 8 sprites in band 1, got {len(b1)}"
    assert len(b2) == 4, f"Expected 4 sprites in band 2, got {len(b2)}"
    assert len(b3) == 10, f"Expected 10 sprites in band 3, got {len(b3)}"
    assert len(b4) == 12, f"Expected 12 sprites in band 4, got {len(b4)}"

    # Note on naming: *_light = bright glyph on dark glass (for dark backgrounds/feed),
    # *_dark = dark teal glyph on pearl glass (for light backgrounds).
    large_circles = [
        ("reminder", b0[0], b0[4]),
        ("like", b0[1], b0[5]),
        ("description", b0[2], b0[6]),
        ("share", b0[3], b0[7]),
        ("like_active", b1[0], b1[4]),
        ("bookmark", b1[1], b1[5]),
        ("comments", b1[2], b1[6]),
        ("repost", b1[3], b1[7]),
    ]
    for name, light_box, dark_box in large_circles:
        crop_centered_square(img, light_box, 208, 208).save(
            os.path.join(OUT_DIR, f"{name}_light.png")
        )
        crop_centered_square(img, dark_box, 208, 208).save(
            os.path.join(OUT_DIR, f"{name}_dark.png")
        )

    small_circles = [
        ("report", b3[0], b3[5]),
        ("categories", b3[1], b3[6]),
        ("close", b3[2], b3[7]),
        ("check", b3[3], b3[8]),
        ("warning", b3[4], b3[9]),
    ]
    for name, light_box, dark_box in small_circles:
        crop_centered_square(img, light_box, 160, 208).save(
            os.path.join(OUT_DIR, f"{name}_light.png")
        )
        crop_centered_square(img, dark_box, 160, 208).save(
            os.path.join(OUT_DIR, f"{name}_dark.png")
        )

    # Play buttons
    crop_centered_square(img, b4[0], 124, 124).save(
        os.path.join(OUT_DIR, "play_light.png")
    )
    crop_centered_square(img, b4[6], 124, 124).save(
        os.path.join(OUT_DIR, "play_dark.png")
    )

    # Swipe capsules
    capsules = [
        ("swipe_left", b2[0], b2[2]),
        ("swipe_right", b2[1], b2[3]),
    ]
    for name, light_box, dark_box in capsules:
        crop_padded_rect(img, light_box, pad=4).save(
            os.path.join(OUT_DIR, f"{name}_light.png")
        )
        crop_padded_rect(img, dark_box, pad=4).save(
            os.path.join(OUT_DIR, f"{name}_dark.png")
        )

    # Standalone ocean/heart glyphs
    glyphs = [
        ("splash_fish", b4[1], b4[7]),
        ("heart_glyph", b4[2], b4[8]),
        ("sparkle", b4[3], b4[9]),
        ("fish_heart_glyph", b4[4], b4[10]),
        ("fish_mini", b4[5], b4[11]),
    ]
    for name, light_box, dark_box in glyphs:
        crop_padded_rect(img, light_box, pad=4).save(
            os.path.join(OUT_DIR, f"{name}_light.png")
        )
        crop_padded_rect(img, dark_box, pad=4).save(
            os.path.join(OUT_DIR, f"{name}_dark.png")
        )

    saved = sorted(f for f in os.listdir(OUT_DIR) if f.endswith(".png"))
    print(f"Extracted {len(saved)} PNG sprites into {OUT_DIR}:")
    for f in saved:
        print(f"  - {f}")


if __name__ == "__main__":
    main()
