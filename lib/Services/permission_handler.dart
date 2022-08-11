import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static Future<PermissionStatus> checkPermissionForCamera() async {
    PermissionStatus status = await Permission.storage.status;
    if (status == PermissionStatus.denied) {
      status = await Permission.storage.request();
    }
    return status;
  }
}
