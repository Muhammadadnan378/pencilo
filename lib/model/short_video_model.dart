class ShortVideoModel {
  final String videoId;
  final String videoUrl;
  final String standard;
  final bool isGlobalVideo;
  final List<String> isLiked;
  final List<String> isVideoWatched;

  ShortVideoModel({
    required this.videoId,
    required this.videoUrl,
    required this.standard,
    required this.isGlobalVideo,
    required this.isLiked,
    required this.isVideoWatched,
  });

  factory ShortVideoModel.fromJson(Map<String, dynamic> json) {
    return ShortVideoModel(
      videoId: json['videoId'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      standard: json['standard'] ?? '',
      isGlobalVideo: json['isGlobalVideo'] ?? false,
      isLiked: List<String>.from(json['isLiked'] ?? []),
      isVideoWatched: List<String>.from(json['isVideoWatched'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'videoUrl': videoUrl,
      'standard': isGlobalVideo ? '' : standard, // Ensure standard is empty if global
      'isGlobalVideo': isGlobalVideo,
      'isLiked': isLiked,
      'isVideoWatched': isVideoWatched,
    };
  }
}
