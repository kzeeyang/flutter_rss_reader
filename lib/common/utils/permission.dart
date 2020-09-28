import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermission(Permission permission) async {
  var status = await permission.status;
  if (status.isUndetermined) {
    Map<Permission, PermissionStatus> status = await [
      permission,
    ].request();
  }
  return status.isGranted;
}
