import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../data/consts/const_import.dart';

class SubjectsController extends GetxController {
  TextEditingController searchController = TextEditingController();
  var searchQuery = ''.obs;

  var isSubjectPartSearching = false.obs;
  FocusNode searchFocusNode = FocusNode();

  // List of subjects
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

  // Filtered list based on search query
  RxList<String> filteredSubjectsParts = RxList<String>();

  @override
  void onInit() {
    super.onInit();
    filteredSubjectsParts.addAll(subjectParts); // Initialize with all subjects
    searchController.addListener(_filterSubjects); // Listen for search text changes
  }

  // Method to filter the subjects list
  void _filterSubjects() {
    if (searchController.text.isEmpty) {
      filteredSubjectsParts.assignAll(subjectParts); // Show all if query is empty
    } else {
      filteredSubjectsParts.assignAll(subjectParts.where((subject) {
        return subject.toLowerCase().contains(searchController.text.toLowerCase()); // Case-insensitive match
      }).toList());
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
