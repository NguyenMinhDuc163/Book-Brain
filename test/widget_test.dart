import 'dart:io';

import 'package:book_brain/utils/core/helpers/auth_helper.dart';
import 'package:book_brain/utils/core/helpers/local_storage_helper.dart';
import 'package:book_brain/screen/ranking/widget/ranking_empty_state.dart';
import 'package:book_brain/service/api_service/request/RegisterRequest.dart';
import 'package:book_brain/service/api_service/request/update_profile_request.dart';
import 'package:book_brain/utils/core/constants/privacy_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDirectory;

  setUpAll(() async {
    tempDirectory = await Directory.systemTemp.createTemp('book_brain_test_');
    Hive.init(tempDirectory.path);
    await LocalStorageHelper.initLocalStorageHelper();
  });

  setUp(() async {
    await LocalStorageHelper.deleteValue('authToken');
    await LocalStorageHelper.deleteValue('isGuest');
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDirectory.delete(recursive: true);
  });

  test('authToken is the source of truth for logged-in state', () async {
    expect(AuthHelper.isLoggedIn, isFalse);
    expect(AuthHelper.isGuest, isTrue);

    await LocalStorageHelper.setValue('authToken', 'valid-token');

    expect(AuthHelper.isLoggedIn, isTrue);
    expect(AuthHelper.isGuest, isFalse);
  });

  test('guest and login markers are persisted', () async {
    await AuthHelper.continueAsGuest();
    expect(AuthHelper.isGuest, isTrue);

    await LocalStorageHelper.setValue('authToken', 'valid-token');
    await AuthHelper.markLoggedIn();

    expect(AuthHelper.isLoggedIn, isTrue);
    expect(AuthHelper.isGuest, isFalse);
  });

  test('account requests use the non-personal placeholder phone number', () {
    final registerRequest = RegisterRequest(
      username: 'reader',
      email: 'reader@example.com',
      password: 'password',
      phoneNumber: PrivacyConstants.placeholderPhoneNumber,
    );
    final profileRequest = UpdateProfileRequest(
      id: 1,
      phoneNumber: PrivacyConstants.placeholderPhoneNumber,
    );

    expect(registerRequest.toJson()['phone_number'], '0987654321');
    expect(profileRequest.toJson()['phone_number'], '0987654321');
  });

  testWidgets('ranking empty state fits a mobile screen', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16),
            child: RankingEmptyState(
              icon: Icons.emoji_events_outlined,
              title: 'Chưa có dữ liệu',
              message: 'Dữ liệu bảng xếp hạng sẽ sớm được cập nhật.',
            ),
          ),
        ),
      ),
    );

    expect(find.text('Chưa có dữ liệu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
