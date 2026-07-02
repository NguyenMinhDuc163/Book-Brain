# SPEC: Temporarily disable public UGC / community features on iOS only

## Goal

Temporarily disable public user-generated content and messaging/chat related features on iOS only for App Store review.

Android must keep the current behavior.

The implementation must use a single global feature flag so the feature can be re-enabled later by changing one value.

This change is intended for the current iOS App Store build. It must prevent Apple reviewers from accessing public comments/reviews/chat/messaging features from any visible UI path or direct route.

## Background

Apple rejected the app because it includes user-generated content and messaging/chat functionality but does not currently provide all required moderation features.

For this release, we will temporarily disable public community features on iOS instead of implementing full UGC moderation.

The app should still allow the core reading experience:

* Browse books
* Search books
* View book details
* Read chapters
* Add favorites
* Follow books
* Reading history
* Private personal notes, if notes are not public to other users

Disable only public/community content:

* Public book reviews
* Public comments
* Public review list
* Create/edit/delete public review
* Messaging/chat if any exists
* Any screen or API call that exposes user-generated public content

## Required behavior

### Android

Android behavior must remain unchanged.

Users on Android can still:

* View book reviews
* Open review screen
* Submit review/comment
* Edit/delete own review
* Use any existing chat/messaging features if present

### iOS

iOS behavior must change:

Users on iOS must NOT be able to:

* Open the public review list
* See other users’ review comments
* Create a public review/comment
* Edit/delete public reviews
* Open chat/messaging screens
* Send messages/chat
* Reach disabled public community screens through routes/deep links

If a UI area would become empty after hiding reviews/chat, replace it with a friendly placeholder, not blank space.

Recommended placeholder text:

```text
Community features are temporarily unavailable in this iOS version.
You can still read books, save favorites, follow books, view reading history, and use private notes.
```

Vietnamese version:

```text
Tính năng cộng đồng hiện tạm thời chưa khả dụng trong phiên bản iOS này.
Bạn vẫn có thể đọc sách, lưu yêu thích, theo dõi sách, xem lịch sử đọc và sử dụng ghi chú cá nhân.
```

## Global feature flag

Create a new file:

```text
lib/config/app_feature_flags.dart
```

Add this class:

```dart
import 'package:flutter/foundation.dart';

class AppFeatureFlags {
  AppFeatureFlags._();

  /// Set this to true later when iOS has full UGC moderation:
  /// - EULA / Terms before login/register
  /// - objectionable content filter
  /// - report content
  /// - block user
  /// - developer notification / moderation flow
  static const bool enablePublicCommunityFeaturesOnIOS = false;

  static bool get isIOS {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// Public UGC includes public reviews, comments, public feedback,
  /// messaging/chat, or any content created by users and visible to others.
  static bool get publicCommunityFeaturesEnabled {
    if (isIOS) {
      return enablePublicCommunityFeaturesOnIOS;
    }
    return true;
  }

  static bool get publicReviewsEnabled => publicCommunityFeaturesEnabled;

  static bool get messagingAndChatEnabled => publicCommunityFeaturesEnabled;
}
```

Later, when iOS moderation is implemented, re-enable with:

```dart
static const bool enablePublicCommunityFeaturesOnIOS = true;
```

Do not scatter platform checks directly across the codebase. Always use `AppFeatureFlags`.

## Files to inspect and modify

At minimum, inspect and update these files:

```text
lib/config/app_feature_flags.dart
lib/screen/preview/view/preview_screen.dart
lib/screen/reivew_book/view/review_book_screen.dart
lib/screen/reivew_book/provider/review_book_notifier.dart
lib/screen/reivew_book/service/review_book_service.dart
lib/utils/routers.dart
```

Also search the whole project for:

```text
ReviewBookScreen
review
reivew
comment
chat
message
messaging
conversation
sendMessage
createReview
getAllReview
sendCreateReview
sendDeleteReview
API_ALL_REVIEW
API_CREATE_REVIEW
API_DELETE_REVIEW
```

If any other public UGC/chat/messaging screen exists, disable it with the same global flag.

## Preview screen changes

File:

```text
lib/screen/preview/view/preview_screen.dart
```

Current behavior:

* The book detail screen shows rating/total reviews.
* The “Xem thêm” button opens `ReviewBookScreen`.
* This creates a path to public reviews/comments.

Required iOS behavior:

When `AppFeatureFlags.publicReviewsEnabled == false`:

1. Do not show the “Xem thêm” button for reviews.
2. Do not navigate to `ReviewBookScreen`.
3. Do not show a UI that suggests users can open public reviews.
4. Replace the review action area with a small friendly message.

Suggested UI behavior:

* Keep book rating only if it is a static book-level rating and does not expose user comments.
* Hide `totalReviews` if it is based on public reviews.
* Hide the “Xem thêm” button.
* Show a small grey text:

```text
Tính năng đánh giá cộng đồng tạm thời chưa khả dụng trên iOS.
```

Example direction:

```dart
final publicReviewsEnabled = AppFeatureFlags.publicReviewsEnabled;
```

In the rating/review row:

```dart
if (publicReviewsEnabled) {
  // Existing total reviews + "Xem thêm" button
} else {
  // No navigation to ReviewBookScreen
  // Show a small placeholder text instead
}
```

Do not leave an empty `Spacer()` or blank UI.

## Review screen changes

File:

```text
lib/screen/reivew_book/view/review_book_screen.dart
```

Current behavior:

* Calls `ReviewBookNotifier.getData()` in `initState`.
* Shows review statistics.
* Shows public review list.
* Allows users to create review/comment through floating action button.
* Allows owner to edit/delete review.

Required iOS behavior:

When `AppFeatureFlags.publicReviewsEnabled == false`:

1. Do not call `getData()`.
2. Do not fetch reviews from API.
3. Do not show review list.
4. Do not show create/edit/delete review UI.
5. Do not show floating action button.
6. Return a safe placeholder screen.

Implementation direction:

In `initState`:

```dart
@override
void initState() {
  super.initState();

  if (!AppFeatureFlags.publicReviewsEnabled) {
    return;
  }

  Future.microtask(
    () => Provider.of<ReviewBookNotifier>(
      context,
      listen: false,
    ).getData(widget.bookId ?? 1),
  );
}
```

At the start of `build`:

```dart
if (!AppFeatureFlags.publicReviewsEnabled) {
  return const CommunityFeatureDisabledScreen();
}
```

If creating a new screen is too much, create a private widget inside this file. But a shared widget is better.

Suggested new shared widget:

```text
lib/widgets/community_feature_disabled_widget.dart
```

Suggested UI:

* Use `Scaffold`
* Use existing app bar style if easy
* Show an icon such as `Icons.forum_outlined`
* Title: `Tính năng cộng đồng tạm thời chưa khả dụng`
* Body: `Bạn vẫn có thể đọc sách, lưu yêu thích, theo dõi sách, xem lịch sử đọc và sử dụng ghi chú cá nhân.`
* Button: `Quay lại`

## Review notifier changes

File:

```text
lib/screen/reivew_book/provider/review_book_notifier.dart
```

Add guard clauses so no review API is called on iOS when disabled.

Required behavior:

```dart
Future<void> getData(int bookId) async {
  if (!AppFeatureFlags.publicReviewsEnabled) {
    reviews = [];
    statsReview = null;
    notifyListeners();
    return;
  }

  await getAllReview(bookId);
  await getStatsReview(bookId);
}
```

For `getAllReview`:

```dart
if (!AppFeatureFlags.publicReviewsEnabled) {
  reviews = [];
  notifyListeners();
  return true;
}
```

For `getStatsReview`:

```dart
if (!AppFeatureFlags.publicReviewsEnabled) {
  statsReview = null;
  notifyListeners();
  return true;
}
```

For `createReview`:

```dart
if (!AppFeatureFlags.publicReviewsEnabled) return false;
```

For `deleteReview`:

```dart
if (!AppFeatureFlags.publicReviewsEnabled) return false;
```

This is important because UI hiding alone is not enough. The app must also stop calling public UGC APIs on iOS.

## Review service changes

File:

```text
lib/screen/reivew_book/service/review_book_service.dart
```

Add defensive guards if useful.

The provider guard is required. Service guard is optional but recommended.

If `AppFeatureFlags.publicReviewsEnabled == false`, service methods should not call:

* `apiServices.getAllReview`
* `apiServices.getStatsReview`
* `apiServices.sendCreateReview`
* `apiServices.sendDeleteReview`

Return safe values:

```dart
getAllReview -> []
getStatsReview -> null
createReview -> false
deleteReview -> false
```

## Router protection

File:

```text
lib/utils/routers.dart
```

Current routes include `ReviewBookScreen.routeName`.

Do not remove the route if that causes navigation errors. Instead, keep the route but make it safe:

Option A, preferred:

* Keep the route unchanged.
* `ReviewBookScreen` itself returns disabled placeholder on iOS.

Option B:

* Route directly to `CommunityFeatureDisabledScreen` when disabled.

Example:

```dart
ReviewBookScreen.routeName: (context) =>
  AppFeatureFlags.publicReviewsEnabled
    ? ReviewBookScreen()
    : const CommunityFeatureDisabledScreen(),
```

If Option B is used, add the import for `AppFeatureFlags` and `CommunityFeatureDisabledScreen`.

Still keep the in-screen guard inside `ReviewBookScreen` to protect direct `MaterialPageRoute` usage.

## Messaging/chat audit

Search the whole repo for chat/messaging features.

Search terms:

```text
chat
message
messaging
conversation
inbox
room
sendMessage
receiveMessage
```

If any chat/messaging feature exists:

1. Hide its tab/menu/card/button on iOS.
2. Prevent route access on iOS.
3. Prevent API calls on iOS.
4. Show the same placeholder instead of blank screen.

Use:

```dart
AppFeatureFlags.messagingAndChatEnabled
```

Do not create a separate iOS flag unless there is a strong reason. The goal is one global switch for all public community features.

## Keep private notes enabled

Do not disable private personal notes unless they are visible to other users.

Private notes are account-based personal data, not public UGC.

If notes are private:

* Keep note creation
* Keep note editing
* Keep note deletion
* Keep note list

If notes are visible to other users, treat them as public UGC and disable them on iOS.

## UI replacement rules

When hiding a feature on iOS, never leave:

* empty white screen
* empty card
* broken spacing
* button that does nothing
* navigation to blank screen
* disabled icon without explanation

Use a clear placeholder.

Recommended short labels:

```text
Tính năng cộng đồng tạm thời chưa khả dụng trên iOS.
```

or:

```text
Community features are temporarily unavailable in this iOS version.
```

For book detail screen, use a compact message rather than a full empty section.

For a full disabled screen, use the shared `CommunityFeatureDisabledScreen`.

## Do not break guest access

Apple previously rejected the app for requiring login before reading. Do not reintroduce that issue.

Guest users must still be able to:

* Open app
* Browse books
* Search books
* View book detail
* Read book chapters

Do not route guests to login for reading.

Only account-based features should require login:

* Favorites
* Following
* History sync
* Private notes
* Profile

## App Store metadata after this change

After this code change is applied for iOS:

In App Store Connect Age Rating, set:

```text
User-Generated Content: No
Messaging and Chat: No
```

Only do this if all public reviews/comments/chat/messaging are truly disabled on iOS.

If any public UGC/chat is still accessible, these answers must be `Yes` and the app must implement moderation/report/block/EULA.

## Testing checklist

### iOS physical device / simulator

Run the iOS build and verify:

1. App opens without login.
2. User can browse books.
3. User can search books.
4. User can open book detail.
5. User can read a chapter.
6. Book detail does not show an accessible public reviews page.
7. There is no “Xem thêm” button that opens public reviews.
8. Direct route to `ReviewBookScreen` shows placeholder, not review list.
9. There is no floating action button for creating review on iOS.
10. No public review/comment list is visible on iOS.
11. No create/edit/delete review API is called on iOS.
12. No chat/messaging screen is accessible on iOS.
13. If UI area would be empty, a friendly placeholder is shown.
14. Private notes still work if they are private.
15. Favorites/following/history still work.

### Android

Run Android and verify existing behavior remains unchanged:

1. Review list still opens.
2. User can submit a review.
3. User can edit/delete own review.
4. Any existing chat/messaging feature still works.
5. Book detail UI is unchanged.

## Acceptance criteria

The task is complete only when:

1. A global flag exists in `lib/config/app_feature_flags.dart`.
2. Changing `enablePublicCommunityFeaturesOnIOS` from `false` to `true` re-enables iOS community features without large refactoring.
3. Android behavior is unchanged.
4. iOS no longer exposes public reviews/comments/chat/messaging.
5. iOS does not call public UGC APIs.
6. No blank UI appears where reviews/chat were removed.
7. Direct route access is protected.
8. Guest reading still works.
9. App Store Connect can safely set:

   * `User-Generated Content = No`
   * `Messaging and Chat = No`
10. The code builds successfully for both iOS and Android.
