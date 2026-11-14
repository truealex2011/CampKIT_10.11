from pathlib import Path
import math
import random
import subprocess

import imageio_ffmpeg
from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "assets" / "media"
OUT.mkdir(parents=True, exist_ok=True)

CATEGORIES = {
    1: "sport", 2: "science", 3: "art", 4: "lecture", 5: "music", 6: "volunteer",
    7: "contest", 8: "outing", 9: "sport", 10: "art", 11: "science", 12: "contest",
    13: "music", 14: "lecture", 15: "volunteer", 16: "outing", 17: "sport",
    18: "art", 19: "art", 20: "contest", 21: "contest",
}

PALETTES = {
    "sport": ((8, 44, 62), (14, 107, 118), (95, 212, 222)),
    "science": ((18, 25, 55), (60, 67, 133), (169, 127, 49)),
    "art": ((48, 20, 44), (176, 74, 85), (241, 178, 126)),
    "lecture": ((20, 35, 45), (57, 66, 79), (200, 213, 218)),
    "music": ((38, 15, 52), (122, 50, 111), (95, 212, 222)),
    "volunteer": ((11, 46, 40), (11, 122, 94), (160, 203, 129)),
    "contest": ((38, 30, 20), (169, 127, 49), (232, 204, 145)),
    "outing": ((10, 20, 48), (43, 68, 111), (150, 178, 215)),
}


def mix(a, b, t):
    return tuple(int(a[i] * (1 - t) + b[i] * t) for i in range(3))


def base(event_id, variant, size, phase=0):
    w, h = size
    category = CATEGORIES[event_id]
    dark, mid, light = PALETTES[category]
    rng = random.Random(event_id * 1009 + variant * 97)
    image = Image.new("RGB", size)
    pixels = image.load()
    drift = math.sin(phase) * 0.08
    for y in range(h):
        for x in range(w):
            t = min(1, max(0, y / h * 0.8 + x / w * 0.18 + drift))
            grain = rng.randint(-4, 4)
            color = mix(dark, mid, t)
            pixels[x, y] = tuple(max(0, min(255, c + grain)) for c in color)
    glow = Image.new("RGBA", size)
    gd = ImageDraw.Draw(glow)
    gx = w * (0.25 + 0.5 * (0.5 + 0.5 * math.sin(phase + event_id)))
    gy = h * (0.22 + 0.13 * variant)
    radius = int(w * 0.55)
    gd.ellipse((gx - radius, gy - radius, gx + radius, gy + radius), fill=(*light, 78))
    glow = glow.filter(ImageFilter.GaussianBlur(w // 5))
    image = Image.alpha_composite(image.convert("RGBA"), glow)
    draw = ImageDraw.Draw(image, "RGBA")
    for i in range(16):
        x = (rng.random() * w + math.sin(phase + i) * w * 0.025) % w
        y = (rng.random() * h + math.cos(phase + i) * h * 0.018) % h
        r = rng.choice((2, 3, 5, 8)) * w / 720
        draw.ellipse((x - r, y - r, x + r, y + r), fill=(*light, rng.randint(35, 105)))
    return image, draw, light


def fish(draw, x, y, s, color, direction=1):
    draw.ellipse((x - s, y - s * 0.45, x + s, y + s * 0.45), fill=color)
    tail = [(x - direction * s * 0.8, y), (x - direction * s * 1.65, y - s * 0.7), (x - direction * s * 1.65, y + s * 0.7)]
    draw.polygon(tail, fill=color)
    draw.ellipse((x + direction * s * 0.45 - s * 0.08, y - s * 0.12, x + direction * s * 0.45 + s * 0.08, y + s * 0.04), fill=(240, 248, 245, 190))


def scene(event_id, variant, size=(720, 960), phase=0):
    w, h = size
    category = CATEGORIES[event_id]
    image, draw, light = base(event_id, variant, size, phase)
    white = (239, 245, 241, 190)
    accent = (*light, 220)
    cx = w * (0.5 + math.sin(phase) * 0.035)
    cy = h * (0.48 + math.cos(phase) * 0.025)
    if category == "sport":
        draw.rounded_rectangle((w * 0.12, h * 0.25, w * 0.88, h * 0.77), radius=w * 0.04, outline=(*light, 120), width=max(2, w // 180))
        draw.line((cx, h * 0.25, cx, h * 0.77), fill=(*light, 100), width=max(2, w // 220))
        r = w * (0.16 + variant * 0.012)
        bx = cx + math.sin(phase) * w * 0.08
        by = cy + math.cos(phase) * h * 0.025
        draw.ellipse((bx - r, by - r, bx + r, by + r), fill=(213, 128, 64, 235), outline=white, width=max(2, w // 180))
        draw.arc((bx - r, by - r, bx + r, by + r), 70, 250, fill=(50, 35, 30, 190), width=max(2, w // 160))
        draw.line((bx - r, by, bx + r, by), fill=(50, 35, 30, 190), width=max(2, w // 160))
    elif category == "science":
        for i in range(5):
            y = h * (0.28 + i * 0.09)
            draw.line((w * 0.18, y, w * 0.82, y), fill=(*light, 65), width=max(1, w // 240))
        draw.rounded_rectangle((w * 0.26, h * 0.31, w * 0.74, h * 0.65), radius=w * 0.07, fill=(13, 24, 42, 190), outline=accent, width=max(3, w // 140))
        for ex in (0.39, 0.61):
            draw.ellipse((w * ex - w * 0.045, h * 0.40 - w * 0.045, w * ex + w * 0.045, h * 0.40 + w * 0.045), fill=accent)
        draw.arc((w * 0.39, h * 0.45, w * 0.61, h * 0.56), 10, 170, fill=white, width=max(2, w // 180))
        draw.line((cx, h * 0.31, cx, h * 0.23), fill=accent, width=max(2, w // 160))
        draw.ellipse((cx - w * 0.025, h * 0.21, cx + w * 0.025, h * 0.25), fill=white)
    elif category == "art":
        for i in range(3):
            pad = w * (0.11 + i * 0.055)
            draw.rounded_rectangle((pad, h * 0.25 + pad * 0.35, w - pad, h * 0.72 - pad * 0.35), radius=w * 0.025, outline=(*light, 85 + i * 45), width=max(2, w // 180))
        draw.ellipse((w * 0.35, h * 0.36, w * 0.65, h * 0.36 + w * 0.30), outline=white, width=max(3, w // 120))
        draw.ellipse((w * 0.43, h * 0.36 + w * 0.08, w * 0.57, h * 0.36 + w * 0.22), fill=accent)
        draw.polygon([(w * 0.2, h * 0.7), (w * 0.42, h * 0.52), (w * 0.58, h * 0.65), (w * 0.78, h * 0.45), (w * 0.84, h * 0.72)], fill=(*light, 65))
    elif category == "lecture":
        for i in range(4):
            y = h * (0.32 + i * 0.09)
            draw.rounded_rectangle((w * 0.22, y, w * (0.75 - i * 0.035), y + h * 0.025), radius=w * 0.01, fill=(*light, 80 + i * 25))
        draw.polygon([(w * 0.32, h * 0.76), (w * 0.4, h * 0.57), (w * 0.6, h * 0.57), (w * 0.68, h * 0.76)], fill=(8, 18, 26, 190), outline=accent)
        draw.ellipse((cx - w * 0.055, h * 0.48, cx + w * 0.055, h * 0.48 + w * 0.11), fill=white)
    elif category == "music":
        points = []
        for x in range(int(w * 0.12), int(w * 0.88), max(3, w // 120)):
            y = cy + math.sin(x / w * math.pi * 8 + phase * 2) * h * 0.09 * math.sin(x / w * math.pi)
            points.append((x, y))
        draw.line(points, fill=accent, width=max(3, w // 100))
        for i in range(5):
            x = w * (0.22 + i * 0.14)
            bh = h * (0.07 + 0.035 * (1 + math.sin(phase + i)))
            draw.rounded_rectangle((x, h * 0.71 - bh, x + w * 0.055, h * 0.71), radius=w * 0.015, fill=(*light, 95 + i * 20))
        fish(draw, cx, h * 0.29, w * 0.09, white)
    elif category == "volunteer":
        draw.line((cx, h * 0.72, cx, h * 0.42), fill=(210, 180, 125, 220), width=max(4, w // 90))
        for i in range(7):
            angle = i / 7 * math.pi * 2 + phase * 0.15
            x = cx + math.cos(angle) * w * 0.18
            y = h * 0.4 + math.sin(angle) * h * 0.1
            r = w * 0.095
            draw.ellipse((x - r, y - r * 0.55, x + r, y + r * 0.55), fill=(*light, 120 + i * 12))
        draw.arc((w * 0.19, h * 0.52, w * 0.81, h * 0.88), 15, 165, fill=white, width=max(3, w // 110))
    elif category == "contest":
        cell = w * 0.09
        for row in range(6):
            for col in range(6):
                color = (*light, 150) if (row + col + variant) % 2 == 0 else (15, 20, 25, 150)
                x = w * 0.23 + col * cell
                y = h * 0.31 + row * cell
                draw.rectangle((x, y, x + cell, y + cell), fill=color)
        draw.polygon([(cx, h * 0.2), (cx + w * 0.035, h * 0.27), (cx + w * 0.11, h * 0.28), (cx + w * 0.05, h * 0.34), (cx + w * 0.065, h * 0.42), (cx, h * 0.375), (cx - w * 0.065, h * 0.42), (cx - w * 0.05, h * 0.34), (cx - w * 0.11, h * 0.28), (cx - w * 0.035, h * 0.27)], fill=white)
    else:
        for i in range(45):
            rng = random.Random(event_id * 300 + variant * 50 + i)
            x = rng.random() * w
            y = rng.random() * h * 0.5
            r = rng.choice((1, 2, 3)) * w / 720
            draw.ellipse((x - r, y - r, x + r, y + r), fill=white)
        draw.ellipse((w * 0.61, h * 0.17, w * 0.79, h * 0.17 + w * 0.18), fill=accent)
        draw.polygon([(0, h * 0.75), (w * 0.32, h * 0.4), (w * 0.53, h * 0.68), (w * 0.71, h * 0.49), (w, h * 0.77), (w, h), (0, h)], fill=(7, 18, 33, 220))
        draw.polygon([(w * 0.23, h * 0.53), (w * 0.32, h * 0.4), (w * 0.4, h * 0.52)], fill=(*light, 160))
    fish(draw, w * (0.2 + 0.6 * (0.5 + 0.5 * math.sin(phase))), h * 0.84, w * 0.038, (*light, 130))
    return image.convert("RGB")


def make_video(event_id):
    width, height, fps, seconds = 360, 640, 24, 4
    output = OUT / f"ev_{event_id}_v.mp4"
    command = [
        imageio_ffmpeg.get_ffmpeg_exe(), "-y", "-f", "rawvideo", "-vcodec", "rawvideo",
        "-pix_fmt", "rgb24", "-s", f"{width}x{height}", "-r", str(fps), "-i", "-",
        "-an", "-c:v", "libx264", "-preset", "veryfast", "-crf", "28", "-pix_fmt", "yuv420p",
        "-movflags", "+faststart", str(output),
    ]
    process = subprocess.Popen(command, stdin=subprocess.PIPE, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    for frame in range(fps * seconds):
        phase = frame / (fps * seconds) * math.tau
        process.stdin.write(scene(event_id, 0, (width, height), phase).tobytes())
    process.stdin.close()
    if process.wait() != 0:
        raise RuntimeError(f"video {event_id}")


for event_id in range(1, 22):
    for photo in range(1, 4):
        scene(event_id, photo).save(OUT / f"ev_{event_id}_p{photo}.jpg", quality=82, optimize=True, progressive=True)

for event_id in (1, 2, 3, 5, 6):
    make_video(event_id)

print(f"files={len(list(OUT.iterdir()))}")
print(f"bytes={sum(path.stat().st_size for path in OUT.iterdir())}")
