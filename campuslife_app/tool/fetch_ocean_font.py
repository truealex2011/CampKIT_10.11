"""Download pinned OFL font assets using the OS proxy configuration."""
import base64
import hashlib
import json
from pathlib import Path
from urllib.request import Request, urlopen

out = Path('assets/fonts')
out.mkdir(parents=True, exist_ok=True)
for sha, name in [
    ('474033a95d364e910e5dc985a56802c474eeedb3', 'CascadiaMono.ttf'),
    ('40f856f6ecc6de260b4065368ad2f5c4f8cbdcbc', 'OFL.txt'),
]:
    filename = 'CascadiaMono%5Bwght%5D.ttf' if name.endswith('.ttf') else name
    req = Request(f'https://raw.githubusercontent.com/google/fonts/main/ofl/cascadiamono/{filename}',
                  headers={'User-Agent': 'CampusLife-font-setup'})
    with urlopen(req, timeout=20) as response:
        data = response.read()
    actual = hashlib.sha1(f'blob {len(data)}\0'.encode() + data).hexdigest()
    if actual != sha:
        raise ValueError('font integrity mismatch')
    (out / name).write_bytes(data)
    print(f'{name}: {len(data)} bytes; pinned git SHA verified')
