import 'package:flutter/material.dart';

class VideoModel with ChangeNotifier {
  final String title;
  final String thumbnailUrl;
  final String videoUrl;
  final String description;

  VideoModel({
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.description,
  });

  VideoModel.fromJson(Map<String, dynamic> json)
      : title = json['videoTitle'],
        thumbnailUrl = json['videoThumbnail'],
        videoUrl = json['videoUrl'],
        description = json['videoDescription'] ?? "No Description";

  Map<String, dynamic> toJson() => {
        'videoTitle': title,
        'videoDescription': description,
        'videoThumbnail': thumbnailUrl,
        'videoUrl': videoUrl
      };
}
