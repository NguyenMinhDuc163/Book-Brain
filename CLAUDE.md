# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Book Brain is a Flutter mobile app for AI-assisted book search and recommendations. It supports searching by keyword/author/title, recommendations, book previews, reviews/notes, reading history, rankings, and author/book suggestions. The public README lists Flutter 3.29.x, Java 17+, PostgreSQL backend, and Azure deployment as project context.

The Flutter SDK is pinned with FVM in `.fvm/fvm_config.json` to `3.29.2`; `pubspec.yaml` uses Dart SDK `^3.7.0` and app version `1.0.0+36`.

## Common Commands

Prefer `fvm flutter ...` if FVM is installed for this repo; otherwise use `flutter ...`.

```sh
# Install dependencies
fvm flutter pub get

# Run the app on an attached device/emulator
fvm flutter run

# Run the preview/dev entrypoint used for web preview builds
fvm flutter run -t lib/main_preview.dart

# Static analysis / linting
fvm flutter analyze

# Run all tests
fvm flutter test

# Run a single test file
fvm flutter test test/widget_test.dart

# Run tests matching a name/pattern
fvm flutter test --name "pattern"

# Build Android split APKs (matches CI)
fvm flutter build apk --split-per-abi

# Build iOS without codesigning (matches CI)
fvm flutter build ios --release --no-codesign

# Build web preview (matches CI)
fvm flutter build web --release --base-href="/" -t lib/main_preview.dart

# Regenerate launcher icons after changing flutter_icons config
fvm dart run flutter_launcher_icons
```

CI in `.github/workflows/main.yml` installs dependencies, creates `.env` from secrets, builds Android split APKs, builds iOS without codesigning, builds web using `lib/main_preview.dart`, uploads artifacts, deploys web to GitHub Pages, and posts Telegram notifications.

## App Entrypoints and Startup

- `lib/main.dart` is the production/default entrypoint. It initializes Flutter bindings, Easy Localization, Hive local storage, `.env`, Firebase, Remote Config, Firebase App Check, wraps the app in `DevicePreview` when not release, then starts `MyApp` with `MultiProvider`.
- `lib/main_preview.dart` is the preview/build entrypoint used by CI for web. It additionally initializes Google Mobile Ads and `AdMobService`, and does not wrap `MaterialApp` in `DevicePreview`.
- Both entrypoints create a `MaterialApp` with `SplashScreen` as `home`, centralized `routes`, `generateRoutes`, `NavigationService.navigatorKey`, and Easy Localization delegates/locales.
- `ScreenUtilInit` uses a design size of `360x690` for responsive UI scaling.

## Architecture

### State management

The app uses `provider` with `ChangeNotifier` classes. Provider registration is centralized in `lib/providers/provider_setup.dart`; add new app-level notifiers there when a feature needs global provider access.

Most feature notifiers extend or follow the shared loading/error pattern in `lib/utils/core/base/base_notifier.dart`, which provides `isLoading`, `errorMessage`, `setLoading`, `setError`, and an `execute()` wrapper.

### Routing

Routing is centralized in `lib/utils/routers.dart` using Flutter named routes plus `onGenerateRoute`. The active route-name constants file `lib/utils/router_names.dart` is currently commented out, so existing code relies on the route names declared in `routers.dart`.

`NavigationService.navigatorKey` is used for global navigation/dialog access from non-widget code.

### Feature organization

Feature code lives under `lib/screen/<feature>/`. The common pattern is:

- `view/` for screens/widgets that represent pages
- `provider/` for `ChangeNotifier` state
- `service/` for feature-specific service wrappers
- `model/` and `widget/` where needed

Major feature directories include login/register, home, detail book/reader, search, favorites, following/subscriptions, reading history, ranking, review book (directory spelling is `reivew_book`), preview, notifications, settings/profile, splash/intro.

The bottom-tab shell is `lib/screen/main_app.dart` and uses `SalomonBottomBar` with Home, Favorites, Ranking, and Setting tabs.

### API and networking

- `lib/service/api_service/api_service.dart` is the main API surface. It wraps auth, book info/trending/recommendations/search, details/chapters, reviews, favorites, subscriptions, notifications, history, ranking, profile/password, and notes.
- `lib/service/api_service/BaseApiService.dart` implements generic Dio request handling and parses responses into `BaseResponse<T>`.
- Endpoint constants are in `lib/service/common/url_static.dart`.
- Default API base URL and timeout are in `lib/service/common/status_api.dart`; the default base URL is `https://book.ndtech.io.vn/api/v1/` and timeout is 20000 ms.
- `lib/service/base_connect.dart` creates Dio with JSON headers and `Authorization: Bearer <authToken>` read from local storage.
- `lib/service/service_config/network_service.dart` owns the Dio singleton, loading notifier, logging interceptor, loading interceptor, and supports updating the base URL.

Remote Config can update the API base URL at runtime; account for that when debugging network behavior.

### Firebase, Remote Config, and ads

- `lib/firebase_options.dart` contains generated Firebase options for Android and iOS; other platforms may throw unsupported/unconfigured errors.
- `lib/service/service_config/firebase_service.dart` initializes Remote Config through `RemoteConfigService`.
- `lib/service/service_config/remote_config_service.dart` fetches `baseUrlServer`, falls back to `StatusApi.BASE_API_URL`, updates `NetworkService`, listens for config updates, and exposes `base_url_web` and `OpenAI_Secret_Key` values.
- Firebase App Check is activated with `AndroidProvider.playIntegrity` in both entrypoints.
- AdMob setup is in `lib/service/service_config/admob_service.dart`; reusable ad widgets are in `lib/widgets/*ad*_widget.dart`.

### Local storage and localization

- Local persistence uses Hive CE via `lib/utils/core/helpers/local_storage_helper.dart`. It opens a Hive box named `fire_guard` and exposes static `getValue`, `setValue`, and `deleteValue` helpers. Existing keys include `authToken` and `languageCode`.
- Localization uses `easy_localization` with assets in `assets/translations/en-US.json` and `assets/translations/vi-VN.json`. Supported locales are `en_US` and `vi_VN`.
- Declared asset folders in `pubspec.yaml`: `assets/translations/`, `assets/images/`, and `assets/icons/`.

## Platform and build notes

- Android configuration is under `android/` and includes Firebase `google-services.json`, signing-related files, and Gradle Kotlin DSL files.
- iOS configuration is under `ios/` and includes `GoogleService-Info.plist`, CocoaPods files, and Runner project files.
- The repository currently has a modified `android/local.properties` in git status; avoid overwriting local environment paths unless explicitly asked.
- `.env` is loaded by `lib/main.dart`; CI creates it from `ENV_FILE_CONTENTS` before building.
