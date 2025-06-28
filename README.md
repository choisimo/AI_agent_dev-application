# Gemini Dev Agent

AI 기반의 Flutter 개발 보조 에이전트

## 📚 개요

`Gemini Dev Agent`는 Google의 Gemini API를 활용하여 개발자의 생산성 향상을 돕는 AI 페어 프로그래밍 도구입니다. Flutter로 제작되어 크로스플랫폼을 지원하며, 채팅 인터페이스를 통해 코드 생성, 디버깅, 프로젝트 관리 등 다양한 개발 작업을 수행할 수 있습니다.

## ✨ 주요 기능

- **AI 채팅**: Dart의 `http` 패키지를 통해 Google Gemini REST API를 직접 호출하여 자연어 기반의 코드 생성, 질문 및 답변이 가능합니다.
- **사용자 인증**: Firebase Authentication을 통해 안전하게 사용자를 관리합니다.
- **프로젝트 관리**: 앱 내에서 Flutter 프로젝트를 관리하고 상태를 추적합니다.
- **Git 연동**: Git과 연동하여 버전 관리 및 코드 변경 사항을 추적합니다.
- **코드 하이라이팅**: 채팅에 표시되는 코드를 시각적으로 보기 좋게 꾸며줍니다.

## 🛠️ 기술 스택

- **플랫폼**: Flutter, Dart
- **AI**: Google Gemini API
- **상태 관리**: Riverpod
- **백엔드 및 데이터베이스**: Firebase (Authentication, Firestore, Cloud Functions)
- **UI**: Material Design, flutter_markdown, code_text_field
- **로컬 저장소**: Hive, SharedPreferences
- **네트워킹**: Dio, HTTP

## 📂 프로젝트 구조

```
lib
├── core/           # 앱의 핵심 로직 (API 클라이언트, 유틸리티, 상수 등)
├── features/       # 각 기능별 모듈 (인증, 채팅, 프로젝트 등)
│   ├── auth/
│   ├── chat/
│   ├── project/
│   └── ...
└── main.dart       # 앱 시작점
```

## 🚀 시작하기

### 1. 프로젝트 클론
```bash
git clone https://your-repository-url.git
cd gemini-dev-agent
```

### 2. 의존성 설치
```bash
flutter pub get
```

### 3. Firebase 설정

Firebase 프로젝트를 생성하고, `google-services.json` (Android) 및 `GoogleService-Info.plist` (iOS) 파일을 프로젝트에 추가해야 합니다.

### 4. 앱 실행
```bash
flutter run
```

---

## 💡 추가 구현 제안

1.  **코드 실행 및 테스트**: 생성된 코드를 앱 내의 안전한 샌드박스 환경에서 즉시 실행하고 테스트 결과를 확인할 수 있는 기능을 추가하면 개발 효율이 크게 향상될 것입니다.
2.  **파일 시스템 직접 제어**: 현재 `file_picker`를 넘어, AI 에이전트가 직접 프로젝트 내 파일을 읽고, 수정하고, 생성하는 등 로컬 파일 시스템에 대한 제어 권한을 확장하여 실제 개발 환경처럼 동작하도록 개선할 수 있습니다.
3.  **통합 터미널**: 앱 내에 터미널을 내장하여 `flutter` 명령어, `git` 명령어 등을 직접 실행할 수 있도록 지원하면 컨텍스트 전환 비용을 줄일 수 있습니다.
4.  **UI/UX 개선**: 
    -   **Command Palette**: VS Code처럼 단축키로 다양한 기능(파일 검색, 명령어 실행 등)을 호출할 수 있는 Command Palette를 추가합니다.
    -   **테마 커스터마이징**: 사용자가 직접 에디터와 앱의 테마를 변경할 수 있는 기능을 제공합니다.
5.  **웹 버전 지원**: Flutter의 장점을 살려, 데스크톱 앱뿐만 아니라 웹 브라우저에서도 동작하는 버전을 배포하여 접근성을 높일 수 있습니다.
6.  **플러그인 시스템**: 사용자가 직접 필요한 기능을 플러그인 형태로 확장할 수 있는 아키텍처를 도입하여 생태계를 구축합니다.
