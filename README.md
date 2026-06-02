# run_ville

실무 기반 Flutter 스타터 프로젝트입니다.

## Stack

- 상태관리: Riverpod
- 라우팅: go_router
- 네트워크: Dio
- 환경변수: flutter_dotenv

## 폴더 구조

```text
lib
├── app
│   ├── app.dart
│   ├── router
│   └── theme
├── core
│   ├── config
│   └── network
└── features
	└── home
```

## 빠른 시작

```bash
flutter pub get
flutter analyze
flutter test
```

## Supabase 패키지 설치

`supabaseClient.js`를 사용하려면 Node 패키지 설치가 필요합니다.

```bash
npm init -y
npm install @supabase/supabase-js dotenv
```

`.env`를 로드해서 실행할 때 예시:

```bash
node --env-file=.env -e "import('./supabaseClient.js').then(() => console.log('Supabase connected'))"
```

## 실행

개발 환경:

```bash
flutter run --dart-define=FLAVOR=dev
```

운영 환경:

```bash
flutter run --dart-define=FLAVOR=prod
```

환경 파일:

- `assets/env/.env.dev`
- `assets/env/.env.prod`

지도(한국어 라벨):

- `Env`는 `VWORLD_API_KEY`가 설정되어 있으면 vWorld 타일(한국어 라벨)을 사용하고, 비어있으면 OpenStreetMap(영문 라벨)로 폴백합니다.
- 따라서 한국어 지도를 원하면 `assets/env/.env.dev` 또는 `assets/env/.env.prod`에 `VWORLD_API_KEY`를 채워주세요.

## 아이폰 실행

시뮬레이터 켜기:

```bash
open -a Simulator
```

기기 확인:

```bash
flutter devices
xcrun simctl list devices booted
```

프로젝트 실행:

```bash
flutter run -d <iPhone Device ID>
```

## 갤럭시 실행

에뮬레이터 켜기:

```bash
emulator -avd <Android AVD Name>
```

기기 확인:

```bash
flutter devices
```

프로젝트 실행:

```bash
flutter run -d <Android Device ID>
```
