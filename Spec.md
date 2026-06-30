# SPEC Flutter-only: Add Minimal Guest Mode for Apple Guideline 5.1.1(v)

## 1. Context

Apple rejected the app because users are required to register/login before browsing and reading books.

Current Flutter behavior:

* App starts from `SplashScreen`.
* User is routed to `LoginScreen`.
* User can enter `MainApp` only after successful login.
* This blocks non-account-based features such as browsing/searching/reading books.

This task is Flutter client only.

Do not modify backend in this task.

## 2. Goal

Implement minimal guest access on Flutter client so users can access core reading features without login.

Guest users must be able to:

```text id="0fj65d"
- Enter the app without logging in
- Browse Home
- View book list/trending books
- Search books
- Open book preview/detail
- Read chapters
- View rankings
- View existing reviews/stats if the API works without login
```

Guest users must not use account-based actions:

```text id="1q3hua"
- Favorite
- Follow/subscription
- Notification
- Server reading history
- Notes
- Submit/edit/delete review
- Profile update
- Change password
- Delete account
- Personalized recommendation by userId
```

## 3. Non-goals

Do not refactor the whole routing system.

Do not rewrite app architecture.

Do not change backend.

Do not change API models.

Do not implement local guest history.

Do not remove login/register.

Do not redesign UI.

Do not fix every existing `bookId ?? 1` fallback unless required for a local guest guard.

## 4. Guest definition

A user is logged in only if `authToken` exists and is not empty.

A user is guest if there is no valid token.

Create helper:

```text id="0xs5y2"
lib/utils/core/helpers/auth_helper.dart
```

Implementation:

```dart id="zzp2y3"
import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';

class AuthHelper {
  static bool get isLoggedIn {
    final token = LocalStorageHelper.getValue("authToken");
    return token != null && token.toString().isNotEmpty;
  }

  static bool get isGuest {
    return !isLoggedIn || LocalStorageHelper.getValue("isGuest") == true;
  }

  static Future<void> continueAsGuest() async {
    await LocalStorageHelper.setValue("isGuest", true);
  }

  static Future<void> markLoggedIn() async {
    await LocalStorageHelper.setValue("isGuest", false);
  }
}
```

Important:

* Use `AuthHelper.isLoggedIn` before calling account-based APIs.
* Do not depend only on `isGuest`, because old installs may not have this key.
* `authToken` is the source of truth.

## 5. Add reusable login-required dialog

Create:

```text id="mqxqss"
lib/utils/core/common/login_required_dialog.dart
```

Implementation:

```dart id="i47jfc"
import 'package:flutter/material.dart';
import 'package:book_brain/screen/login/view/login_screen.dart';

Future<void> showLoginRequiredDialog(
  BuildContext context, {
  String message = "Bạn cần đăng nhập để sử dụng tính năng này.",
}) async {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Cần đăng nhập"),
        content: Text(
          "$message\n\nBạn vẫn có thể đọc và tìm kiếm sách mà không cần đăng nhập.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Để sau"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(LoginScreen.routeName);
            },
            child: const Text("Đăng nhập"),
          ),
        ],
      );
    },
  );
}
```

Use this for all guest-restricted actions.

## 6. LoginScreen changes

File:

```text id="ka6835"
lib/screen/login/view/login_screen.dart
```

Add a visible button on login screen:

```text id="tzmjqr"
Tiếp tục đọc không cần tài khoản
```

Button behavior:

```dart id="igbi26"
await AuthHelper.continueAsGuest();

Navigator.of(context).pushNamedAndRemoveUntil(
  MainApp.routeName,
  (_) => false,
);
```

Requirements:

* Button must be visible without scrolling too much.
* Do not remove existing login button.
* Do not remove sign up button.
* Do not require email/password for this button.
* This is the main Apple review fix.

## 7. Login success changes

When login succeeds, mark guest false.

Preferred location:

```text id="h36jpd"
lib/screen/login/services/login_service.dart
```

After token/user data is saved:

```dart id="y3g5jl"
await LocalStorageHelper.setValue("isGuest", false);
```

Do not change existing token/user save behavior.

## 8. SplashScreen changes

Minimal safe option:

* Keep current Splash -> Login behavior.
* Since Login now has guest button, Apple reviewer can continue without login.

Optional small improvement:

If token exists, go directly to `MainApp`.

Pseudo:

```dart id="rfcdr6"
final token = LocalStorageHelper.getValue("authToken");

if (token != null && token.toString().isNotEmpty) {
  Navigator.of(context).pushNamedAndRemoveUntil(
    MainApp.routeName,
    (_) => false,
  );
} else {
  Navigator.of(context).pushNamed(LoginScreen.routeName);
}
```

Do not force guest directly from Splash in this task unless it is already easy and tested.

## 9. HomeNotifier guest changes

File:

```text id="c6tbhe"
lib/screen/home/provider/home_notifier.dart
```

Current problem:

`getData()` calls both public and private/user-based APIs:

```dart id="gti5r6"
getInfoBook();
getTrendingBook(limit: 10);
getUnreadNotificationCount();
getRecommentBook();
loadUserInfo();
```

Guest must not call:

```text id="6rt3l1"
getUnreadNotificationCount()
getRecommentBook()
```

because these rely on notification/auth/userId.

Update `getData()`:

```dart id="5j32me"
Future<void> getData() async {
  await execute(() async {
    await Future.wait([
      getInfoBook(),
      getTrendingBook(limit: 10),
      loadUserInfo(),
    ]);

    if (AuthHelper.isLoggedIn) {
      await Future.wait([
        getUnreadNotificationCount(),
        getRecommentBook(),
      ]);
    } else {
      unreadNotificationCount = 0;
      recommenlist = trendingBook;
      notifyListeners();
    }
  });
}
```

Add import:

```dart id="fg19s7"
import 'package:book_brain/utils/core/helpers/auth_helper.dart';
```

Expected result:

* Guest Home loads public content.
* “Dành cho bạn” uses trending fallback.
* No userId read for guest.
* No notification API for guest.

## 10. Home recommendation load-more guest guard

File:

```text id="0m5bc6"
lib/screen/home/provider/home_notifier.dart
```

Update `loadMoreRecommendBooks()`.

At start:

```dart id="dq481q"
if (!AuthHelper.isLoggedIn) {
  hasMoreRecommend = false;
  notifyListeners();
  return;
}
```

This avoids reading `userId` for guest.

## 11. Home notification icon guard

File likely:

```text id="7mfisf"
lib/screen/home/view/home_screen.dart
```

When tapping notification icon:

```dart id="buky26"
if (!AuthHelper.isLoggedIn) {
  showLoginRequiredDialog(
    context,
    message: "Bạn cần đăng nhập để xem thông báo.",
  );
  return;
}
```

Only navigate to `NotificationScreen` when logged in.

Imports:

```dart id="ihsw0g"
import 'package:book_brain/utils/core/helpers/auth_helper.dart';
import 'package:book_brain/utils/core/common/login_required_dialog.dart';
```

## 12. PreviewScreen favorite/follow guards

File:

```text id="2y6j46"
lib/screen/preview/view/preview_screen.dart
```

Preview itself must remain accessible for guest.

Guard only the account-based actions.

### Favorite action

Before calling `presenter.setFavorites(...)`:

```dart id="b4hbau"
if (!AuthHelper.isLoggedIn) {
  showLoginRequiredDialog(
    context,
    message: "Bạn cần đăng nhập để thêm sách vào Yêu thích.",
  );
  return;
}
```

### Follow action

Before calling `presenter.setFollowing(...)`:

```dart id="d1cn03"
if (!AuthHelper.isLoggedIn) {
  showLoginRequiredDialog(
    context,
    message: "Bạn cần đăng nhập để theo dõi sách.",
  );
  return;
}
```

Do not block opening Preview.

Do not block reading button.

## 13. DetailBookScreen / Reader guest guards

File:

```text id="6b4ehj"
lib/screen/detail_book/view/detail_book_screen.dart
```

Reader must remain accessible for guest.

Guest can call detail book API.

Guest must not call:

```text id="uo8ojw"
getNoteBook()
saveNoteBook()
deleteNoteBook()
setHistoryBook()
createReview/rating submit
```

### On init/load

Current flow likely loads detail and note.

Keep:

```dart id="kuybwf"
presenter.getData(bookId: ..., chapterId: ...);
```

Guard note loading:

```dart id="88f7xp"
if (AuthHelper.isLoggedIn) {
  presenter.getNoteBook(bookId: bookId, chapterId: chapterId);
}
```

If guest, skip `getNoteBook`.

### On back/home save history

Before calling server history:

```dart id="1mozrk"
if (AuthHelper.isLoggedIn) {
  presenter.setHistoryBook(...);
}
```

If guest, just navigate back/home without saving server history.

### On add note

Before opening note save flow or before calling `saveNoteBook`:

```dart id="kc3jtu"
if (!AuthHelper.isLoggedIn) {
  showLoginRequiredDialog(
    context,
    message: "Bạn cần đăng nhập để tạo ghi chú.",
  );
  return;
}
```

### On delete note

Guest should not see notes because note loading is skipped. Still guard delete action if needed.

### On rating submit from reader

Before submitting review/rating:

```dart id="oo63r1"
if (!AuthHelper.isLoggedIn) {
  showLoginRequiredDialog(
    context,
    message: "Bạn cần đăng nhập để gửi đánh giá.",
  );
  return;
}
```

## 14. ReviewBookScreen guest behavior

File:

```text id="ierjbv"
lib/screen/reivew_book/view/review_book_screen.dart
```

Guest should be able to view review list and stats if API allows.

Keep public load:

```text id="f871nc"
getAllReview()
getStatsReview()
```

Guard only write actions.

### Add review FAB/button

Before opening submit review bottom sheet or before submitting:

```dart id="0wa4ie"
if (!AuthHelper.isLoggedIn) {
  showLoginRequiredDialog(
    context,
    message: "Bạn cần đăng nhập để gửi đánh giá.",
  );
  return;
}
```

### Edit/delete review

Only show edit/delete when logged in.

If simpler, keep UI but guard action:

```dart id="ejpxyn"
if (!AuthHelper.isLoggedIn) {
  showLoginRequiredDialog(context);
  return;
}
```

## 15. FavoritesScreen guest behavior

File:

```text id="y6a5dl"
lib/screen/favorites/view/favorites_screen.dart
```

Guest must not call favorites API.

At init:

```dart id="uafyzi"
if (AuthHelper.isLoggedIn) {
  presenter.getData();
}
```

In build, if not logged in, show login required view:

```dart id="rm1g9y"
Scaffold(
  appBar: BaseAppbar(title: "Yêu thích"),
  body: Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Bạn cần đăng nhập để lưu và xem sách yêu thích.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(LoginScreen.routeName);
            },
            child: const Text("Đăng nhập"),
          ),
        ],
      ),
    ),
  ),
);
```

Keep existing UI unchanged for logged-in users.

## 16. FollowingBookScreen guest behavior

File:

```text id="x3peu8"
lib/screen/following_book/view/following_book_screen.dart
```

Guest must not call subscription API.

At init:

```dart id="468vgr"
if (AuthHelper.isLoggedIn) {
  presenter.getData();
}
```

If guest, show login-required view:

```text id="3y6bc0"
Bạn cần đăng nhập để theo dõi sách.
```

## 17. HistoryReadingScreen guest behavior

File:

```text id="1j6mrd"
lib/screen/history_reading/view/history_reading_screen.dart
```

Guest must not call reading history API.

At init:

```dart id="2mp7i6"
if (AuthHelper.isLoggedIn) {
  presenter.getData();
}
```

If guest, show login-required view:

```text id="tx466v"
Bạn cần đăng nhập để đồng bộ lịch sử đọc.
```

No local history implementation in this task.

## 18. NotificationScreen guest behavior

File:

```text id="6cz6ey"
lib/screen/notification/view/notification_screen.dart
```

Ideally guest should be blocked before reaching this screen.

Still add safety guard:

* If guest, do not call notification API.
* Show login-required view.

Message:

```text id="sgv5ye"
Bạn cần đăng nhập để xem thông báo.
```

## 19. SettingScreen guest behavior

File:

```text id="acsk64"
lib/screen/setting/view/setting_screen.dart
```

If guest:

Show:

```text id="axmff0"
- Đăng nhập
- Đăng ký
- Về Book Brain
- Hỗ trợ
- Điều khoản sử dụng
```

Hide or disable:

```text id="3w6u9h"
- Chỉnh sửa thông tin
- Đổi mật khẩu
- Xóa tài khoản
- Đăng xuất tài khoản
```

Minimal alternative:

Keep screen mostly unchanged but for profile actions show login-required dialog.

Preferred safer UX:

* Do not display fake username/email for guest.
* Show “Khách” or “Bạn đang dùng chế độ không đăng nhập”.

## 20. MainApp bottom navigation

File:

```text id="3e5iam"
lib/screen/main_app.dart
```

Do not heavily refactor.

Acceptable minimal behavior:

* Keep all tabs visible.
* Guest can open Favorites tab but sees login-required view.
* Guest can open Ranking tab normally.
* Guest can open Setting tab and sees login/register options.

Do not hide tabs unless very easy and tested.

## 21. API calls that guest must avoid on Flutter client

Guest must not trigger these service methods:

```text id="fr4v4w"
notificationService.getListNotification()
homeService.getRecommendation()
favoritesService.getListFavorites()
favoritesService.createFavorites()
favoritesService.deleteFavorites()
subscriptionService.getListSubscription()
subscriptionService.createSubscription()
subscriptionService.deleteSubscription()
historyService.getHistory()
historyService.updateHistory()
detailBookService.getNoteBook()
detailBookService.saveNoteBook()
detailBookService.deleteNoteBook()
reviewBookService.createReview()
reviewBookService.deleteReview()
profileService.updateProfile()
profileService.changePassword()
profileService.deleteAccount()
```

Guest can trigger:

```text id="q9kagi"
homeService.getInfoBook()
homeService.getBookTrending()
searchService.searchBook()
previewService.getDetailBook()
previewService.getChapters()
rankingService.getBookRanking()
rankingService.getAuthRanking()
reviewBookService.getAllReview()
reviewBookService.getStatsReview()
```

If backend returns auth error for any public call, do not handle in this task except by showing existing error/empty state.

## 22. ID behavior on Flutter client

Guest has no `userId`.

Therefore:

```text id="35gqwl"
Do not read userId for guest.
Do not call APIs that require userId for guest.
```

Guest can still use `bookId` and `chapterId`.

Why:

* `bookId` comes from public book list/search/ranking.
* `chapterId` comes from selected book/chapter.
* These are content IDs, not user IDs.

For this task:

* Do not pass fake `userId`.
* Do not fallback to `userId = 1`.
* Do not call recommendation API for guest.

Optional safe improvement:

Before private mutation actions, avoid `bookDetail?.bookId ?? 1`.

Use:

```dart id="smc2fb"
final bookId = bookDetail?.bookId;
if (bookId == null) {
  showToastTop(message: "Không tìm thấy sách");
  return;
}
```

Apply this only to private actions if easy.

## 23. Acceptance criteria

## 23.1 Guest clean install

With no token:

```text id="v93tcb"
[ ] App opens Login screen.
[ ] Login screen has "Tiếp tục đọc không cần tài khoản".
[ ] Tapping it opens MainApp/Home.
[ ] Home loads books/trending.
[ ] Home does not call notification API.
[ ] Home does not call recommendation API with userId.
[ ] Search works.
[ ] Preview opens from Home/Search/Ranking.
[ ] Reader opens and displays book chapter.
[ ] Reader does not call notes API.
[ ] Reader does not call history update API.
[ ] Ranking opens.
[ ] Review screen opens and shows existing reviews/stats if API allows.
[ ] Favorite action shows login-required dialog.
[ ] Follow action shows login-required dialog.
[ ] Notification action shows login-required dialog.
[ ] Favorites tab shows login-required view.
[ ] Following screen shows login-required view.
[ ] History screen shows login-required view.
[ ] Add note shows login-required dialog.
[ ] Submit review shows login-required dialog.
[ ] No crash.
```

## 23.2 Logged-in user

With valid token:

```text id="hkqhp1"
[ ] Login works as before.
[ ] isGuest is set to false after login.
[ ] Home loads notification count.
[ ] Home loads recommendations.
[ ] Favorite works.
[ ] Follow works.
[ ] Notifications work.
[ ] Reading history works.
[ ] Notes work.
[ ] Submit/delete review works.
[ ] Profile/change password/delete account work.
```

## 24. App Review note after Flutter change

Use this note when resubmitting:

Hello App Review Team,

Thank you for your feedback.

We have updated the app so users can continue without logging in and access the core reading experience as a guest. Guest users can browse books, search books, view book details, read chapters, view rankings, and view existing reviews.

Sign-in is now only required for account-based features, such as saving favorites, following books, syncing reading history, creating notes, submitting reviews, receiving notifications, and managing profile settings.

Thank you for reviewing the updated build.

## 25. Implementation order

Follow this order to reduce risk:

```text id="lgq1c9"
1. Add AuthHelper.
2. Add login-required dialog.
3. Add "Continue without login" button on LoginScreen.
4. Set isGuest=false on successful login.
5. Update HomeNotifier to skip notification/recommendation for guest.
6. Guard notification icon.
7. Guard favorite/follow in Preview.
8. Guard notes/history/review submit in Reader.
9. Guard Favorites/Following/History/Notification screens.
10. Adjust SettingScreen for guest.
11. Test guest clean install.
12. Test logged-in user.
```

## 26. Do not do

```text id="ee65iz"
- Do not modify backend.
- Do not change route names.
- Do not remove Login/Register.
- Do not change response models.
- Do not implement new APIs.
- Do not pass fake userId for guest.
- Do not call recommendations for guest.
- Do not call private APIs for guest.
- Do not rewrite the entire app navigation.
```

## 27. Implementation handoff (updated 2026-06-30)

This section records the final Flutter behavior after implementation and the
important lessons discovered while working in the existing codebase. Treat it
as the current source of truth when it differs from the earlier proposed flow.

### 27.1 Final startup and authentication UX

The app no longer presents Login as the first screen.

Current startup flow:

```text
SplashScreen
  -> authToken exists and is not empty: MainApp as logged-in user
  -> no authToken: set isGuest=true, then open MainApp as guest
```

`SplashScreen` currently bypasses both `IntroScreen` and `LoginScreen`. Login
and registration remain available later from guest entry points.

Reasons for this change:

* A visible "Continue without an account" button can technically provide guest
  access, but showing Login before public content can still look like a login
  wall to App Review.
* Opening Home directly makes it unambiguous that browsing and reading do not
  require an account.
* Account authentication is requested only at the moment an account-based
  feature is selected.

The Login screen still keeps the "Continue reading without an account" button
as a safe fallback. Successful login calls `AuthHelper.markLoggedIn()`.

After logout or account deletion, clear the token and account data, clear the
in-memory `NetworkService` authorization header, mark the session as guest, and
return to `MainApp` instead of showing Login again.

### 27.2 Authentication source of truth

Implemented files:

```text
lib/utils/core/helpers/auth_helper.dart
lib/utils/core/common/login_required_dialog.dart
```

Rules that must not regress:

* `authToken != null && authToken.toString().isNotEmpty` is the only source of
  truth for whether private APIs may be called.
* `isGuest` is a UX/session marker. Never use it as the only API authorization
  check because old installations may not have the key.
* Never read `userId` before checking `AuthHelper.isLoggedIn`.
* Never substitute a fake `userId` for guests.
* Keep guards in both the view and notifier/provider where possible. The view
  shows the login dialog; the notifier is the defensive boundary that prevents
  an accidental private request from a future caller.

Important architecture detail: providers are registered above `MainApp` and
can retain data across navigation. When a guest opens the reader,
`DetailBookNotifier.getData()` clears its cached note list so notes from a
previous authenticated session cannot be displayed.

`MainApp` uses an `IndexedStack`, so account tabs can be instantiated even when
they are not selected. Private screens must keep their `initState`
authentication guards; guarding only button navigation is not sufficient.

### 27.3 Implemented guest boundaries

Guest-accessible functionality:

* Home, public books, trending books, and trending fallback for recommendations
* Search
* Book preview/detail and chapter reading
* Rankings
* Existing review list and statistics when the public API permits it

Account-only functionality guarded in the UI and/or notifier:

* Notification count, notification list, mark/delete notification
* Personalized recommendations and recommendation pagination
* Favorite list and favorite mutations
* Subscription/follow list and mutations
* Server reading history
* Note load/save/delete
* Review create/edit/delete
* Profile update, password change, and account deletion

Guest-only screen behavior:

* Favorites, Following, History, and Notification screens do not call their
  APIs and show a reusable login-required view.
* Home notification tap shows the reusable login-required dialog.
* Favorite/follow/note/review actions show the same dialog with a
  feature-specific localized message.
* Home displays `Guest` instead of a fake username.

### 27.4 Home avatar and Settings entry points

On Home, the avatar is interactive for guests:

* It displays a small login indicator.
* Tapping it shows the localized login-required dialog.
* Choosing Login navigates to `LoginScreen`.

In Settings, guests see:

* A guest profile state with a generic icon, not a fake user avatar or email.
* A dedicated card explaining the benefit of an account.
* Visible Login and Sign Up actions.
* About, Support, and Terms/Privacy items.

Guests do not see profile editing, password change, account deletion, or
logout controls. Logged-in Settings behavior remains unchanged.

### 27.5 Privacy decision: do not collect phone numbers

Apple-facing registration and profile forms no longer display, validate, read,
or store a phone-number field.

The existing backend currently expects `phone_number`. Until that backend
contract is changed, both registration and profile update services send this
non-personal compatibility value:

```text
0987654321
```

The shared value is defined in:

```text
lib/utils/core/constants/privacy_constants.dart
```

It is injected only in `RegisterService` and `ProfileService`. Do not add a
phone controller or phone parameter back to the view/notifier layers. Request
models are intentionally unchanged because changing backend models was outside
this migration. If the backend makes `phone_number` optional, remove the
placeholder instead of collecting a real number.

### 27.6 UI refinements made during the migration

These changes are not authentication requirements, but are part of the current
implemented UI and should be preserved:

* Ranking empty states use a reusable light card instead of showing text or a
  spinner on the solid purple background:
  `lib/screen/ranking/widget/ranking_empty_state.dart`.
* `EmptyDataWidget` uses a compact default illustration (`64 x 80` design
  units). Search uses an even smaller `56 x 56` illustration. Avoid restoring
  the former `200-300` sizes.
* All new guest and ranking text exists in both translation files:
  `assets/translations/vi-VN.json` and `assets/translations/en-US.json`.

### 27.7 Current external Settings links

Support:

```text
https://nguyenduc163.notion.site/Nguyen-Duc-Apps-Support-38303bc2971180bfa793f871713beba5
```

Terms/Privacy Policy:

```text
https://nguyenduc163.notion.site/Privacy-Policy-for-Book-Brain-38303bc29711809daae3e77cb0f1cae6
```

Both links open with `LaunchMode.externalApplication`.

### 27.8 Updated acceptance criteria

For a clean install with no token:

```text
[ ] Splash opens MainApp/Home directly; Login is not shown first.
[ ] isGuest is persisted as true.
[ ] Public Home/trending/search/preview/reader/ranking/reviews work.
[ ] No private API reads userId or sends a request.
[ ] Home avatar and Settings provide obvious Login entry points.
[ ] Restricted actions show a login-required dialog.
[ ] Login and Sign Up remain reachable and functional.
```

For an authenticated installation, keep all criteria in section 23.2.

### 27.9 Verification and known repository condition

Verification used after this migration:

```text
fvm flutter test
fvm flutter build ios --debug --no-codesign
```

The automated suite currently contains authentication, placeholder-phone, and
ranking empty-state coverage. The iOS device build completed successfully.

The repository has many pre-existing analyzer warnings and informational lints.
Do not treat those as regressions from this migration; still require no new
error-level analyzer findings in touched files.
