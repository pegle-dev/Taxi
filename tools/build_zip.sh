#!/usr/bin/env bash
# 오프라인 실행용 zip 만들기: bash tools/build_zip.sh  →  dist/makcha-<버전>.zip
set -euo pipefail
cd "$(dirname "$0")/.."
VER="${1:-dev}"
OUT="$(mktemp -d)/makcha"; mkdir -p "$OUT" dist
python3 - "$OUT" <<'PY'
import sys
out=sys.argv[1]
s=open('game/index.html',encoding='utf8').read()
cdn='https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js'
assert cdn in s, 'three.js CDN 주소를 찾지 못했습니다'
s=s.replace(cdn,'three.min.js')
fcdn='https://cdn.jsdelivr.net/npm/galmuri@2.40.3/dist/'
assert fcdn in s, '갈무리 글꼴 CDN 주소를 찾지 못했습니다'
# file://로 열면 크롬이 글꼴 파일 로드를 막으므로(CORS) zip에서는 글꼴을 HTML 안에 data URI로 넣는다
import base64,re
s=re.sub(re.escape(fcdn)+r'([\w-]+\.woff2)',lambda m:'data:font/woff2;base64,'+base64.b64encode(open('vendor/galmuri/'+m.group(1),'rb').read()).decode(),s)
assert fcdn not in s
html=('<!doctype html>\n<html lang="ko" style="height:100%">\n<head>\n<meta charset="utf-8">\n'
 '<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">\n'
 '<style>body{margin:0;font-size:14px}[hidden]{display:none!important}</style>\n</head>\n<body>\n'+s+'\n</body>\n</html>\n')
open(out+'/막차.html','w',encoding='utf8').write(html)
open(out+'/읽어주세요.txt','w',encoding='utf8').write(
 '막차 (LAST RIDE)\n\n실행: "막차.html"을 더블클릭하면 브라우저(Safari, Chrome)에서 열립니다.\n'
 '설치는 필요 없고, 인터넷 없이도 됩니다. 두 파일(막차.html, three.min.js)은 같은 폴더에 두세요.\n\n'
 '조작: 클릭으로 진행 / 위아래 방향키와 Enter로 선택 / 1~4로 룸미러, 사이드미러, 네비, 뒷좌석 보기\n'
 '소리를 켜고 하는 것을 권합니다.\n')
PY
cp vendor/three.min.js "$OUT/"
cp vendor/galmuri/LICENSE.txt "$OUT/글꼴-라이선스(Galmuri-OFL).txt"
rm -f "dist/makcha-$VER.zip"
(cd "$(dirname "$OUT")" && zip -qr "$OLDPWD/dist/makcha-$VER.zip" makcha)
echo "dist/makcha-$VER.zip"
