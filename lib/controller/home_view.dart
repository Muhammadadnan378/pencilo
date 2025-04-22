import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

import '../data/consts/const_import.dart';
import '../data/current_user_data/current_user_Data.dart';

class HomeViewController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    filteredSubjectsParts.addAll(subjectParts); // Initialize with all subjects
    searchController.addListener(filterSubjects); // Listen for search text changes
    getFullAddress();

  }

  ///Home view methods
  RxString currentLocation = ''.obs; // Observable to store the full address
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

  ///Subject parts view methods
  // Text controller and query for search
  TextEditingController searchController = TextEditingController();
  var searchQuery = ''.obs;
  var isSubjectPartSearching = false.obs;
  FocusNode searchFocusNode = FocusNode();

// List of subject parts
  List<String> subjectParts = [
    "Part 1",
    "Part 2",
    "Part 3",
    "Part 4",
    "Part 5",
    "Part 6",
    "Part 7",
    "Part 8",
  ];

// List of subject names
  List<String> subjectPartName = [
    "Mathematics",  // Subject 1
    "English",      // Subject 2
    "Science",      // Subject 3
    "History",      // Subject 4
    "Geography",    // Subject 5
    "Physics",      // Subject 6
    "Chemistry",    // Subject 7
    "Computer Science", // Subject 8
  ];

// Filtered list based on search query
  RxList<String> filteredSubjectsParts = RxList<String>();

// Method to filter the subjects list
  void filterSubjects() {
    if (searchController.text.isEmpty) {
      filteredSubjectsParts.assignAll(subjectParts); // Show all subject parts if query is empty
    } else {
      // Filter subject parts based on search query, searching both subjectParts and subjectPartName
      filteredSubjectsParts.assignAll(
        List<String>.from(
          List.generate(subjectParts.length, (index) {
            // Check if either the subject part or subject name matches the search query
            if (subjectParts[index].toLowerCase().contains(searchController.text.toLowerCase()) ||
                subjectPartName[index].toLowerCase().contains(searchController.text.toLowerCase())) {
              return subjectParts[index]; // Return the matching subject part
            }
            return ''; // Empty string for non-matching entries (will be filtered out later)
          }).where((element) => element.isNotEmpty), // Filter out empty strings
        ),
      );
    }
  }



  /// Answer view methods
  String videoUrlUid = '123456';
  TextEditingController urlController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Store the YouTube URL in Firestore
  Future<void> saveVideoUrl(String subjectId) async {
    try {
      await _firestore.collection('youtube_urls').doc(videoUrlUid).update({
        'videoUrl': urlController.text, // Storing the URL
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to save video URL: $e');
    }
  }

  // Fetch the video URL from Firestore
  Future<String?> getVideoUrl(String subjectId) async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore.collection('answers').doc(subjectId).get();
      return documentSnapshot['videoUrl'] as String?;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch video URL: $e');
      return null;
    }
  }
}
