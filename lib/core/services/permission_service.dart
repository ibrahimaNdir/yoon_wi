import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestLocation() async {
    final status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  Future<bool> requestNotifications() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<bool> isLocationGranted() => Permission.locationWhenInUse.isGranted;

  Future<void> openSettings() => openAppSettings();
}
