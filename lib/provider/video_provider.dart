import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:video_playing_app/shared_preference/shared_preference.dart';

import '../models/video_model.dart';

class VideoProvider with ChangeNotifier {
  bool _loading = false;
  String background = "";

  List<VideoModel> videosList = [];

  bool get loading => _loading;

  Future fetchVideo() async {
    _loading = true;

    List<String> titleList = [];
    List<String> description = [];

    var dio = Dio();

    Response response = await dio.get('https://app.et/devtest/list.json');
    if (response.statusCode == 200) {
      VideoModel video;
      background = response.data['appBackgroundHexColor'];
      response.data["videos"].forEach((el) async => {
            video = VideoModel.fromJson(el),
            videosList.add(video),
            titleList.add(video.title),
            description.add(video.description)
          });

      UserPreferences.setTitle(titleList);
      UserPreferences.setDescription(description);
    } else {
      throw Exception('Failed to fetch comments from the server.');
    }

    _loading = false;
    notifyListeners();
  }
}
