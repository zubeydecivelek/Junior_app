import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:juniorapp/Models/VideoItemModel.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../ColorPalette.dart';

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
    /*const url = video.videoLink;
    controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(url)!,
        flags: YoutubePlayerFlags(
          mute: false,
          loop: false,
          autoPlay: true,
        ));*/
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
  Widget build(BuildContext context) {
    controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(video.videoLink)!,
        flags: YoutubePlayerFlags(
          mute: false,
          loop: false,
          autoPlay: true,
        ));
    return YoutubePlayerBuilder(

        player: YoutubePlayer(
          controller: controller,
          key: ObjectKey(controller),
          actionsPadding: const EdgeInsets.only(left: 16.0),
          bottomActions: [
            CurrentPosition(),
            const SizedBox(width: 10.0),
            ProgressBar(isExpanded: true),
            const SizedBox(width: 10.0),
            RemainingDuration(),
            FullScreenButton(),
          ],

        ),
        builder: (context, player) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            actions: [
              IconButton(onPressed: ()async{

                await FlutterShare.share(
                    title: 'Videoyu paylaş',
                    //text: "Haydi sen de Juniorapp'i indir ayrıcalıkların farkına var!",
                    linkUrl: video.videoLink,
                    chooserTitle: 'Paylaşacağın uygulamayı seç...'

                );

              }, icon: const Icon(Icons.share_outlined))
            ],
            leading: InkWell(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.black,

          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              player,
            ],
          ),
        ));
  }
}
