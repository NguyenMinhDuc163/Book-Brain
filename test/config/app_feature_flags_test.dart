import 'package:book_brain/config/app_feature_flags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  test('public community features are disabled on iOS', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    expect(AppFeatureFlags.publicReviewsEnabled, isFalse);
    expect(AppFeatureFlags.messagingAndChatEnabled, isFalse);
  });

  test('public community features stay enabled on Android', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    expect(AppFeatureFlags.publicReviewsEnabled, isTrue);
    expect(AppFeatureFlags.messagingAndChatEnabled, isTrue);
  });
}
