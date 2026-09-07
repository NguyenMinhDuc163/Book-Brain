# SPEC: MIGRATE BOOK-BRAIN TO FASTLANE MATCH + PRE-RELEASE VALIDATION

Repository:
NguyenMinhDuc163/Book-Brain

Bundle ID:
com.nguyenduc.bookBrain

Team ID:
Q236Z72BGN

Signing repo:
https://github.com/NguyenMinhDuc163/apple-signing.git

==================================================
1. GOAL
==================================================

Replace old manual iOS signing:

IOS_DISTRIBUTION_CERTIFICATE_P12_BASE64
IOS_DISTRIBUTION_CERTIFICATE_PASSWORD
IOS_APPSTORE_PROVISIONING_PROFILE_BASE64

with Fastlane Match readonly.

Also add pre-release validation before version bump.

Do not redesign existing mobile release flow.

==================================================
2. EXISTING SIGNING ASSET
==================================================

Use existing:

profiles/appstore/
AppStore_com.nguyenduc.bookBrain.mobileprovision

and existing Distribution certificate in apple-signing.

Do NOT:
- create certificate
- regenerate profile
- revoke assets
- modify apple-signing
- match nuke
- readonly:false

==================================================
3. FILES
==================================================

Add:

ios/fastlane/Matchfile
.github/workflows/reusable-validate-project.yml

Modify:

ios/fastlane/Fastfile
ios/fastlane/Appfile
ios/Runner.xcodeproj/project.pbxproj
.github/workflows/reusable-ios-testflight.yml
.github/workflows/mobile-store-release.yml

Update stale iOS signing docs if present.

Do not modify Android logic.

==================================================
4. MATCHFILE
==================================================

git_url(ENV.fetch("MATCH_GIT_URL"))
storage_mode("git")
git_branch("main")

app_identifier([
  "com.nguyenduc.bookBrain"
])

type("appstore")

team_id(ENV["IOS_TEAM_ID"]) unless ENV["IOS_TEAM_ID"].to_s.strip.empty?

==================================================
5. FASTFILE
==================================================

Keep existing build logic.

lane :beta order:

setup_ci

api_key = app_store_connect_api_key(...)

match(
  type: "appstore",
  platform: "ios",
  app_identifier: APP_IDENTIFIER,
  readonly: true,
  api_key: api_key
)

Get:

SharedValues::MATCH_PROVISIONING_PROFILE_MAPPING

Require:

com.nguyenduc.bookBrain

Set:

ENV["IOS_PROVISIONING_PROFILE_NAME"] = matched_profile_name

Then:

build
archive validation
upload_to_testflight

==================================================
6. REMOVE MANUAL SIGNING
==================================================

Remove old workflow secrets:

IOS_DISTRIBUTION_CERTIFICATE_P12_BASE64
IOS_DISTRIBUTION_CERTIFICATE_PASSWORD
IOS_APPSTORE_PROVISIONING_PROFILE_BASE64

Remove manual:

- P12 decode
- mobileprovision decode
- security create-keychain
- security import
- manual profile install

Use setup_ci + Match only.

==================================================
7. NEW REQUIRED APPLE SECRETS
==================================================

Keep:

APP_STORE_CONNECT_KEY_ID
APP_STORE_CONNECT_ISSUER_ID
APP_STORE_CONNECT_API_KEY_P8

Add:

IOS_TEAM_ID
MATCH_GIT_URL
MATCH_PASSWORD
MATCH_GIT_BASIC_AUTHORIZATION

Expected:

IOS_TEAM_ID=Q236Z72BGN

MATCH_GIT_URL=
https://github.com/NguyenMinhDuc163/apple-signing.git

Reuse the same proven Match credentials used by the other projects.

==================================================
8. APPFILE
==================================================

Remove:

apple_id("ngminhduc1603@icloud.com")

Keep:

app_identifier("com.nguyenduc.bookBrain")
team_id("Q236Z72BGN")

==================================================
9. FIX VERSION PROPAGATION
==================================================

IMPORTANT:

Current pubspec build is much higher than the hardcoded Xcode build.

Main Runner target must use:

MARKETING_VERSION = "$(FLUTTER_BUILD_NAME)";
CURRENT_PROJECT_VERSION = "$(FLUTTER_BUILD_NUMBER)";

Apply to Runner Debug/Profile/Release.

Do NOT blindly modify RunnerTests.

pubspec.yaml remains the source of truth.

==================================================
10. ARCHIVE PATH + VERSION VALIDATION
==================================================

Avoid the previous Edu-Tech path bug.

Define ONE absolute archive path:

<repo>/build/ios/archive/Runner.xcarchive

Prefer derive from:

GITHUB_WORKSPACE

or repo root.

Never hardcode:

/Users/runner/work/Book-Brain/Book-Brain

Use same archive path for:

build_app
+
validation

After build and before upload, verify actual:

CFBundleShortVersionString == pubspec version
CFBundleVersion == pubspec build number

Fail before TestFlight if mismatch.

Do not trust IPA filename alone.

==================================================
11. PRE-RELEASE VALIDATION
==================================================

Create:

.github/workflows/reusable-validate-project.yml

Run on Ubuntu before bump_version.

Validate:

APP_STORE_CONNECT_KEY_ID
APP_STORE_CONNECT_ISSUER_ID
APP_STORE_CONNECT_API_KEY_P8
IOS_TEAM_ID
MATCH_GIT_URL
MATCH_PASSWORD
MATCH_GIT_BASIC_AUTHORIZATION

Checks:

- all secrets present
- IOS_TEAM_ID == Q236Z72BGN
- MATCH_GIT_URL correct
- P8 PEM format valid
- apple-signing readable
- MATCH_PASSWORD decrypt succeeds
- App Store profile exists for com.nguyenduc.bookBrain
- profile Team ID == Q236Z72BGN
- App Store Connect auth succeeds

Read-only only.

Do not upload or modify anything.

Do NOT add ENV_FILE_CONTENTS unless repository inspection proves this
project actually requires it.

==================================================
12. RELEASE ORDER
==================================================

mobile-store-release.yml:

validate_project
      ↓
bump_version
      ↓
build_testflight / build_google_play

If validation fails:

- no version bump
- no macOS runner
- no store build

==================================================
13. LESSONS FROM PREVIOUS PROJECTS
==================================================

Do NOT:

- manually create Match keychain
- hardcode fastlane_tmp_keychain path
- hardcode GitHub runner repository path
- trust IPA filename for build number
- generate new MATCH_PASSWORD
- use raw PAT instead of Base64 Basic auth
- assume GITHUB_TOKEN can read private apple-signing
- update Fastlane/Gemfile.lock unnecessarily

==================================================
14. OLD SECRETS
==================================================

Agent must NOT delete secrets.

After one successful real TestFlight build, user may delete:

IOS_DISTRIBUTION_CERTIFICATE_P12_BASE64
IOS_DISTRIBUTION_CERTIFICATE_PASSWORD
IOS_APPSTORE_PROVISIONING_PROFILE_BASE64

==================================================
15. ACCEPTANCE
==================================================

[ ] Matchfile added
[ ] setup_ci before Match
[ ] Match appstore readonly
[ ] correct Book-Brain profile mapping
[ ] manual signing removed
[ ] personal Apple ID removed
[ ] Runner uses FLUTTER_BUILD_NAME
[ ] Runner uses FLUTTER_BUILD_NUMBER
[ ] archive path shared and rename-safe
[ ] archive version validated before upload
[ ] validation runs before bump_version
[ ] Match repo/decrypt/profile validated
[ ] ASC auth validated
[ ] Android unchanged
[ ] apple-signing unchanged
[ ] no secrets printed
[ ] no TestFlight triggered unless explicitly requested

Final report:
- changed files
- validation result
- Match configuration
- versioning fix
- old secrets no longer referenced
- confirm apple-signing not modified