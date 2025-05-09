import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../view/home.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 2.obs; // Default is HomeView at center
  @override
  void onInit() {
    super.onInit();
  }
  Future<void> requestNotificationPermission() async {
    // Check the notification permission status
    PermissionStatus status = await Permission.notification.status;

    if (!status.isGranted) {
      // Request permission if not granted
      PermissionStatus newStatus = await Permission.notification.request();

      if (newStatus.isGranted) {
        print('Notification permission granted');
      } else if (newStatus.isDenied) {
        print('Notification permission denied');
      } else if (newStatus.isPermanentlyDenied) {
        print('Notification permission permanently denied');
        openAppSettings(); // Optionally, you can prompt the user to open settings to manually enable permission.
      }
    } else {
      print('Notification permission already granted');
    }
  }

}
