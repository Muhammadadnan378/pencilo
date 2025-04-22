import 'package:geocoding/geocoding.dart'; // Import geocoding package
import 'package:get/get.dart';

import '../data/current_user_data/current_user_Data.dart'; // For GetX state management

class HomeViewController extends GetxController {
  RxString currentLocation = ''.obs; // Observable to store the full address

  @override
  void onInit() {
    super.onInit();
    // Call the method to get the full address when the controller is initialized
    getFullAddress();
  }

  // Method to extract latitude and longitude from the currentLocation string and get the full address
  Future<void> getFullAddress() async {
    try {
      // Extract latitude and longitude from currentLocation string
      String location = CurrentUserData.currentLocation; // Assuming this is the string you get from Firestore
      List<String> coordinates = location.split(','); // Split by comma
      double latitude = double.parse(coordinates[0].trim()); // Parse latitude
      double longitude = double.parse(coordinates[1].trim()); // Parse longitude

      // Get the list of placemarks (full address) from latitude and longitude
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        // Get the first placemark and format the address
        Placemark placemark = placemarks.first;
        String address = '${placemark.street}, ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}';

        // Set the full address to the observable
        currentLocation.value = address;
      }
    } catch (e) {
      print('Error getting address: $e');
      currentLocation.value = 'Unable to fetch address'; // Set an error message
    }
  }
}
