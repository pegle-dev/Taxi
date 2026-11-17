# 《막차》 LAST RIDE

심야 택시 운전사가 되어 정신력을 지키며 수상한 손님 셋을 목적지까지 태워 주는 짧은 공포 게임.

**온라인 플레이**: https://pegle-dev.github.io/Taxi/ (`main`에 푸시하면 GitHub Actions가 자동 배포)

## 폴더

| 경로 | 내용 |
| --- | --- |
| `docs/ART_DIRECTION_v0.1.md` | 아트 바이블. 규칙은 고정, 구현 방식만 제안 |
| `references/` | 참고 이미지 (참고용, 문서가 우선) |
| `game/index.html` | 게임 본체 한 파일 (Three.js r128 + 바닐라 JS) |
| `vendor/three.min.js` | 오프라인 빌드용 Three.js r128 |
| `tools/build_zip.sh` | 오프라인 실행 zip 빌드 |
| `tools/build_site.sh` | GitHub Pages용 `_site/` 빌드 |
| `.github/workflows/pages.yml` | Pages 자동 배포 |
| `docs/preview-v0.png` | 실행 화면 캡처 |

## 다른 컴퓨터에서 작업하기

필요한 것: 브라우저, Python 3, `zip` (맥 기본 포함). 설치할 것 없음.

**바로 실행해 보기** — `game/index.html`은 Three.js와 글꼴을 CDN에서 받으므로 인터넷이 필요하다. 로컬 서버로 연다:

```bash
cd game
python3 -m http.server 8000
```

그리고 브라우저에서 http://localhost:8000 을 연다.

**오프라인 zip 만들기**:

```bash
bash tools/build_zip.sh v1
```

→ `dist/makcha-v1.zip`

## 코드 구조 (game/index.html)

- **3D**: 480×270 렌더 → 12색 팔레트 + ordered dither 후처리 셰이더 → nearest 확대. 정신력이 낮을수록 팔레트 색 수가 12→8로 줄고 노이즈가 늘어난다.
- **카메라**: `VIEWS`의 main(운전석)/navi/mirror/side/back. 손님은 룸미러(`mirCam` 렌더 타깃)로만 보인다.
- **손님 데이터**: `P` 객체. 손님마다 `intro`, `beats`(장면 4개: 지문 `text`, 대사 `say`, `choices`, `silence`), `obs`(룸미러/사이드미러/네비/뒷좌석 관찰 결과), `good`/`bad` 결말.
  - 선택지 효과: `san`(정신력), `doom`(누적이 `limit` 이상이면 나쁜 결말), `scare`(점프 스케어), `navi`(네비 뒤틀림), `flash`(번개), `charm`(부적).
- **진행**: `run()` → 손님 3명(`lineup()`, 귀신 2 + 사람 1) → `ending()`.
- **디버그**: 브라우저 콘솔에서 `__makcha.setView('mirror')`, `__makcha.scare('wet')`, `__makcha.setPassenger('black')` 등.
