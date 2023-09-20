import 'package:flutter/material.dart';
import 'package:movie/network/api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../model/videos.dart';

class MyVideoPlayer extends StatefulWidget {
  const MyVideoPlayer({super.key, required this.id});
  final int id;

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  List<Videos> videos = [];
  Videos? trailer;
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    callVideoApiAndShowTrailer();
  }

  callVideoApiAndShowTrailer() async {
    videos = await getVideos(widget.id);

    for (int i = 0; i < videos.length; i++) {
      Videos video = videos[i];

      if (video.official &&
          video.type == "Trailer" &&
          video.site == 'YouTube') {
        trailer = video;

        debugPrint('----------');
        debugPrint('${trailer!.key}');
        _initController(trailer!);
        break;
      }
    }
    setState(() {});
  }

  _initController(Videos trailer) {
    _controller = YoutubePlayerController(
      initialVideoId: trailer.key!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return trailer == null
        ? Container()
        : Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(top: 20),
              //   child: Text(
              //     trailer!.name == null ? "Official Trailer" : trailer!.name!,
              //     textAlign: TextAlign.center,
              //     style: Theme.of(context).textTheme.titleMedium,
              //   ),
              // ),
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.red,
                progressColors: const ProgressBarColors(
                  playedColor: Colors.redAccent,
                  handleColor: Colors.red,
                ),
                onReady: () {
                  _controller.pause();
                },
              ),
            ],
          );
  }
}
