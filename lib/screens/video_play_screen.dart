// screens/video_play_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/video_model.dart';

class VideoPlayScreen extends StatefulWidget {
  final VideoModel video;

  const VideoPlayScreen({Key? key, required this.video}) : super(key: key);

  @override
  _VideoPlayScreenState createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController!.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  bool isPaly = false;

  Future<void> initializePlayer() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl));

    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      aspectRatio: 16 / 9,
      allowFullScreen: true,

      allowPlaybackSpeedChanging: true,
      fullScreenByDefault: true,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.landscapeRight],

      deviceOrientationsOnEnterFullScreen: [DeviceOrientation.landscapeRight],
      showControls: true, // Show video player controls
    );
    if (_chewieController != null &&
        _chewieController!.videoPlayerController.value.isInitialized) {
      setState(() {
        isPaly = !isPaly;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.video.title),
      // ),
      body: Column(
        children: [
          Expanded(
              child: Center(
            child: isPaly
                //  _chewieController != null &&
                //         _chewieController!.videoPlayerController.value.isInitialized
                ?
                // Chewie(
                //     controller: _chewieController!,
                //   )
                Theme(
                    data: ThemeData.light().copyWith(
                      platform: TargetPlatform.iOS,
                    ),
                    child: Chewie(
                      controller: _chewieController!,
                    ),
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text("Loading")
                      ]),
          ))
        ],
      ),
    );
  }
}
