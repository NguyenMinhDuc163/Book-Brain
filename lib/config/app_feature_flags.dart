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
