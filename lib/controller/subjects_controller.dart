import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../data/consts/const_import.dart';

class SubjectsController extends GetxController {
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
