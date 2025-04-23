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

  }

  ///Home view methods
  List<String> curvedImages = [
    'assets/images/maths_card_curved.png',
    'assets/images/hindi_card_curved.png',
    'assets/images/english_card_curved.png',
    'assets/images/history_card_curved.png',
    'assets/images/marathi_card_curved.png',
    'assets/images/geographi_card_curved.png',
    'assets/images/maths_card_curved.png',
  ];

  List<Color> curvedCardColors = [
    Color(0xff091F07),
    Color(0xff45757C),
    Color(0xff1F1F1F),
    Color(0xff770505),
    Color(0xff774B05),
    Color(0xff6F7705),
  ];


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

// List of chapter names for each subject
  List<String> chapterNames = [
    "Algebra",            // Chapter 1 for Mathematics
    "Literature",         // Chapter 1 for English
    "Physics Fundamentals", // Chapter 1 for Science
    "Ancient History",    // Chapter 1 for History
    "World Geography",    // Chapter 1 for Geography
    "Thermodynamics",     // Chapter 1 for Physics
    "Organic Chemistry",  // Chapter 1 for Chemistry
    "Computer Programming", // Chapter 1 for Computer Science
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
                chapterNames[index].toLowerCase().contains(searchController.text.toLowerCase())) {
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
