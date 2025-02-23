
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:book_brain/service/common/status_api.dart';

import 'network_service.dart';

part 'remote_config_service.dart';

class FirebaseService with RemoteConfigService {
  FirebaseService() {
    // Khởi tạo Firebase Remote Config và áp dụng cập nhật URL
    remoteConfigServiceInitialize();
  }
}
