import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:book_brain/service/common/status_api.dart';

import 'network_service.dart';

part 'remote_config_service.dart';

class FirebaseService with RemoteConfigService {
  Future<void> initialize() async {
    try {
      await remoteConfigServiceInitialize();
    } catch (error) {
      // Remote Config must never prevent the app from starting. Dio keeps
      // using the known-good fallback URL when Firebase is unavailable.
      NetworkService.instance.updateBaseUrl(fallbackUrl);
      print('Remote Config initialization failed, using fallback: $error');
    }
  }
}
