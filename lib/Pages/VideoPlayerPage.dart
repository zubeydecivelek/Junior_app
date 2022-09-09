import 'package:flutter/material.dart';
import 'package:juniorapp/Models/VideoItemModel.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerPage extends StatefulWidget {

  final VideoItemModel video;
  VideoPlayerPage({required this.video});
  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState(video);
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {

  VideoItemModel video;
  _VideoPlayerPageState(this.video);

  late YoutubePlayerController controller;

  void initState() {
    super.initState();
    const url = "https://www.youtube.com/watch?v=c0ruHxX7r3M";
    controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(url)!,
      flags: YoutubePlayerFlags(
        mute: false,
        loop: false,
        autoPlay: true,
      )
    );
  }

  void deactive() {
    controller.pause();
    super.deactivate();
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)=> YoutubePlayerBuilder(player: YoutubePlayer(
    controller: controller,
  ),builder: (context,player)
      => Scaffold(
        appBar: AppBar(
          leading: BackButton(),
        ),
        body: ListView(
        children: [
          player,

        ],
      ),));
}
