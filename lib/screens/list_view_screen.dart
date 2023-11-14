import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:video_playing_app/screens/video_play_screen.dart';
import 'package:video_playing_app/shared_preference/shared_preference.dart';

import '../models/video_model.dart';
import '../provider/video_provider.dart';
import 'package:hexcolor/hexcolor.dart';

class ListViewScreen extends StatefulWidget {
  const ListViewScreen({super.key});

  @override
  State<ListViewScreen> createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    result = await _connectivity.checkConnectivity();

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // fetchVideos();
    _loadInterstitialAd();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    videoDescription = UserPreferences.getDescription()!;
    videoTitle = UserPreferences.getTitle()!;

    super.initState();
  }

  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  void _loadInterstitialAd() {
    String appId = Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/1033173712'
        : "ca-app-pub-3940256099942544/4411468910";
    InterstitialAd.load(
      adUnitId: appId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _interstitialAd = ad;
            _isInterstitialAdReady = true;
          });
        },
        onAdFailedToLoad: (error) {},
      ),
    );
  }

  List videoDescription = [];
  List videoTitle = [];

  void _showInterstitialAd() {
    if (_isInterstitialAdReady) {
      _interstitialAd.show();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);
    return Scaffold(
      backgroundColor: videoProvider.videosList.isEmpty
          ? HexColor(videoProvider.background.toString())
          : const Color(0xff34db93),
      bottomSheet: Visibility(
          visible: _connectionStatus.toString() == "ConnectivityResult.none",
          child: Container(
            width: double.infinity,
            height: 40,
            decoration: const BoxDecoration(color: Colors.black),
            child: const Center(
              child: Text("You are offline \ncheck your internet",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white)),
            ),
          )),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Video List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  double userRating = 3; // Set initial rating if needed
                  return AlertDialog(
                    title: const Text('Rate the App'),
                    content: RatingBar.builder(
                      initialRating: userRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        userRating = rating;
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  );
                },
              );
            },
          ),

          // IconButton(
          //   icon: const Icon(Icons.star),
          //   onPressed: () {
          //     // Implement "Rate App" action

          //     RatingBar.builder(
          //       initialRating: 3,
          //       minRating: 1,
          //       direction: Axis.horizontal,
          //       allowHalfRating: true,
          //       itemCount: 5,
          //       itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          //       itemBuilder: (context, _) => const Icon(
          //         Icons.star,
          //         color: Colors.amber,
          //       ),
          //       onRatingUpdate: (rating) {
          //         print(rating);
          //       },
          //     );
          //   },
          // ),

          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {},
          ),
        ],
      ),
      body: videoProvider.videosList.isEmpty
          ? videoTitle.isEmpty
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [CircularProgressIndicator()],
                )
              : ListView.builder(
                  itemCount: videoTitle.length,
                  itemBuilder: (context, index) {
                    final String title = videoTitle[index];
                    final String description = videoDescription[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(title,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700)),
                          subtitle: Text(description),
                          leading: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                color: Colors.grey,
                                width: 80,
                                height: 150,
                              ),
                            ),
                          ),
                          onTap: () {
                            const ScaffoldMessenger(
                                child: Text("You Chack your internet!!"));
                          },
                        ),
                      ),
                    );
                  },
                )
          : ListView.builder(
              itemCount: videoProvider.videosList.length,
              itemBuilder: (context, index) {
                final VideoModel video = videoProvider.videosList[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(video.title,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700)),
                      subtitle: Text(video.description),
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            video.thumbnailUrl,
                            width: 80,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      onTap: () {
                        _showInterstitialAd();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VideoPlayScreen(video: video),
                            ));
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
