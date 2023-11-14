import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../provider/video_provider.dart';
import 'list_view_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> fetchVideos() async {
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    videoProvider.fetchVideo();
  }

  @override
  void initState() {
    fetchVideos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: Image.asset("assets/splash_logo.png", height: 75, width: 75),
        duration: 3000,
        curve: Curves.easeInOut,
        splashIconSize: 350,
        splashTransition: SplashTransition.slideTransition,
        animationDuration: const Duration(milliseconds: 1500),
        backgroundColor: const Color(0xff34db93),
        // Colors.white,
        pageTransitionType: PageTransitionType.fade,
        nextScreen: const ListViewScreen(),
      ),
    );
  }
}
