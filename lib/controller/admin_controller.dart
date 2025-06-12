import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/consts/const_import.dart';
import '../model/short_video_model.dart';

class AdminController extends GetxController {
  TextEditingController videoUrlController = TextEditingController();
  RxBool isUploading = false.obs;
  RxBool isGlobalVideo = false.obs; // Default false
  RxString selectedStandard = ''.obs;
  List<String> standardsList = ['4th', '5th', '6th', '7th', '8th', '9th', '10th'];

  Future<void> uploadVideo() async {
    if (videoUrlController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a video URL");
      return;
    }

    isUploading(true);

    String videoId = DateTime.now().millisecondsSinceEpoch.toString();
    ShortVideoModel videoData = ShortVideoModel(
      videoId: videoId,
      videoUrl: videoUrlController.text,
      standard: isGlobalVideo.value ? '' : selectedStandard.value,
      isGlobalVideo: isGlobalVideo.value,
      isVideoWatched: [],
      isLiked: [],
    );

    try {
      await FirebaseFirestore.instance.collection('youtube_short_videos').doc(videoId).set(videoData.toJson());
      Get.snackbar("Success", "Video uploaded successfully!");
      videoUrlController.clear();
      selectedStandard.value = '';
      isGlobalVideo(false);
    } catch (e) {
      Get.snackbar("Error", "Failed to upload video: $e");
    } finally {
      isUploading(false);
    }
  }
}
