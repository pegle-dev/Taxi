#!/usr/bin/env bash
# GitHub Pages용 사이트 만들기: bash tools/build_site.sh  →  _site/
set -euo pipefail
cd "$(dirname "$0")/.."
rm -rf _site && mkdir -p _site
python3 - <<'PY'
s=open('game/index.html',encoding='utf8').read()
cdn='https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js'
assert cdn in s
s=s.replace(cdn,'three.min.js')
open('_site/index.html','w',encoding='utf8').write(
 '<!doctype html>\n<html lang="ko" style="height:100%">\n<head>\n<meta charset="utf-8">\n'
 '<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">\n'
 '<style>body{margin:0;font-size:14px}[hidden]{display:none!important}</style>\n</head>\n<body>\n'+s+'\n</body>\n</html>\n')
PY
cp vendor/three.min.js _site/
echo _site
