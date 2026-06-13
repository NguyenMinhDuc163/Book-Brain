# iOS Fastlane/TestFlight

Dự án này dùng Fastlane để build Flutter iOS IPA và upload lên TestFlight.

## Lệnh Chạy Local

Chạy từ thư mục `ios/`:

```sh
bundle install
bundle exec fastlane ios build
bundle exec fastlane ios beta
```

- `ios build`: chỉ build IPA đã ký.
- `ios beta`: build IPA và upload lên TestFlight.

Version app lấy từ `pubspec.yaml`:

```yaml
version: 1.0.0+42
```

Với iOS:

- `1.0.0` là `CFBundleShortVersionString`.
- `42` là `CFBundleVersion`.

## File `.env` Local

Copy `ios/fastlane/.env.example` thành `ios/fastlane/.env`.

Cần các biến sau để chạy local:

```env
APP_STORE_CONNECT_KEY_ID=
APP_STORE_CONNECT_ISSUER_ID=
APP_STORE_CONNECT_API_KEY_KEY_FILEPATH=
```

### `APP_STORE_CONNECT_KEY_ID`

Key ID của App Store Connect API key.

Lấy tại:

`App Store Connect` -> `Users and Access` -> `Integrations` -> `App Store Connect API` -> chọn hoặc tạo key.

Ví dụ:

```env
APP_STORE_CONNECT_KEY_ID=3C8FHYD3YX
```

### `APP_STORE_CONNECT_ISSUER_ID`

Issuer ID dạng UUID của App Store Connect.

Lấy cùng trang với API key.

Ví dụ:

```env
APP_STORE_CONNECT_ISSUER_ID=c4e1088b-f115-4544-a85f-ac2d083fd9b7
```

### `APP_STORE_CONNECT_API_KEY_KEY_FILEPATH`

Đường dẫn tuyệt đối hoặc tương đối tới file `AuthKey_XXXXXXXXXX.p8`.

Không dùng `APP_STORE_CONNECT_API_KEY_PATH` cho file `.p8` raw. Fastlane/Pilot có thể hiểu biến đó là path tới file JSON API key info và lỗi:

```text
invalid number: '-----BEGIN'
```

Ví dụ:

```env
APP_STORE_CONNECT_API_KEY_KEY_FILEPATH=/absolute/path/AuthKey_XXXXXXXXXX.p8
```

## GitHub Actions Secrets

Workflow đang dùng:

```text
.github/workflows/ios-testflight.yml
```

Thêm secrets tại:

`GitHub repo` -> `Settings` -> `Secrets and variables` -> `Actions` -> `New repository secret`.

### App Store Connect

Cần 3 secrets:

```text
APP_STORE_CONNECT_KEY_ID
APP_STORE_CONNECT_ISSUER_ID
APP_STORE_CONNECT_API_KEY_P8
```

`APP_STORE_CONNECT_KEY_ID` và `APP_STORE_CONNECT_ISSUER_ID` giống giá trị dùng local.

`APP_STORE_CONNECT_API_KEY_P8` là toàn bộ nội dung file `.p8`, không phải đường dẫn:

```text
-----BEGIN PRIVATE KEY-----
...
-----END PRIVATE KEY-----
```

Copy nội dung `.p8` vào clipboard:

```sh
pbcopy < /path/to/AuthKey_XXXXXXXXXX.p8
```

### iOS Signing/Export

Cần 3 secrets:

```text
IOS_DISTRIBUTION_CERTIFICATE_P12_BASE64
IOS_DISTRIBUTION_CERTIFICATE_PASSWORD
IOS_APPSTORE_PROVISIONING_PROFILE_BASE64
```

Các secrets này cần vì GitHub macOS runner là máy sạch, không có sẵn certificate, keychain, hoặc provisioning profile như máy local.

#### `IOS_DISTRIBUTION_CERTIFICATE_P12_BASE64`

Đây là nội dung base64 của certificate Apple Distribution dạng `.p12`.

Cách export `.p12` trên máy Mac đang build local được:

1. Mở `Keychain Access`.
2. Vào `My Certificates`.
3. Tìm certificate dạng `Apple Distribution: ...`.
4. Chuột phải -> `Export`.
5. Lưu dạng `.p12`.
6. Đặt password.

Copy base64 vào clipboard:

```sh
base64 -i /path/to/Certificates.p12 | pbcopy
```

Lệnh trên không in gì ra terminal vì output đã được đưa vào clipboard. Kiểm tra:

```sh
pbpaste | head -c 80
pbpaste | wc -c
```

#### `IOS_DISTRIBUTION_CERTIFICATE_PASSWORD`

Password đã đặt khi export file `.p12`.

#### `IOS_APPSTORE_PROVISIONING_PROFILE_BASE64`

Đây là nội dung base64 của App Store provisioning profile cho bundle id:

```text
com.nguyenduc.bookBrain
```

Cách tạo/download:

`Apple Developer` -> `Certificates, Identifiers & Profiles` -> `Profiles`.

Chọn:

- Type: `App Store`
- App ID: `com.nguyenduc.bookBrain`
- Certificate: đúng Apple Distribution certificate đã export ra `.p12`

Copy base64 vào clipboard:

```sh
base64 -i /path/to/BookBrain_AppStore.mobileprovision | pbcopy
```

## Luồng GitHub Actions

Khi push vào `main`, workflow sẽ:

1. Tăng build number trong `pubspec.yaml`.
2. Commit lại version bump với `[skip ci]` để tránh vòng lặp CI vô hạn.
3. Checkout lại `main` sau khi đã bump version.
4. Ghi secret `.p8` ra file tạm trên runner.
5. Cài Apple Distribution certificate và App Store provisioning profile vào runner.
6. Chạy `bundle exec fastlane ios beta`.

Nếu repo bật branch protection cho `main`, cần cho phép GitHub Actions push commit bump version, nếu không job đầu tiên sẽ fail.

## Lỗi Thường Gặp

### `invalid number: '-----BEGIN'`

File `.p8` đang được truyền qua sai biến.

Dùng:

```env
APP_STORE_CONNECT_API_KEY_KEY_FILEPATH=/path/to/AuthKey_XXXXXXXXXX.p8
```

Không dùng:

```env
APP_STORE_CONNECT_API_KEY_PATH=/path/to/AuthKey_XXXXXXXXXX.p8
```

### `CFBundleIdentifier Collision`

Không truyền `PRODUCT_BUNDLE_IDENTIFIER=...` qua global `xcargs` trong `build_app`.

Nếu truyền sai, giá trị bundle id của app có thể bị áp vào các embedded frameworks/bundles, làm nhiều bundle có cùng bundle id.

### `Looks like no provisioning profile mapping was provided`

Archive đã thành công nhưng export IPA fail.

Trên GitHub Actions, lỗi này thường nghĩa là runner chưa có đúng App Store provisioning profile/certificate.

Kiểm tra:

- `IOS_DISTRIBUTION_CERTIFICATE_P12_BASE64`
- `IOS_DISTRIBUTION_CERTIFICATE_PASSWORD`
- `IOS_APPSTORE_PROVISIONING_PROFILE_BASE64`
- artifact `fastlane-gym-logs`

### `xcodebuild -exportArchive` exit status `64`

Thường là tham số export không hợp lệ.

Với Fastlane `2.236.x`, giữ export method là `app-store`. Fastlane bản này chưa nhận tên mới `app-store-connect` của Xcode 26.

## Kiểm Tra Không Upload

Các lệnh này chỉ kiểm tra cấu hình, không upload:

```sh
ruby -c ios/fastlane/Fastfile
ruby -c ios/fastlane/Appfile
plutil -lint ios/Runner/Info.plist
cd ios && bundle exec fastlane lanes
```
