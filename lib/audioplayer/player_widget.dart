import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:medito/audioplayer/audio_singleton.dart';
import 'package:medito/colors.dart';
import 'package:medito/viewmodel/list_item.dart';

class PlayerWidget extends StatefulWidget {
  PlayerWidget(
      {Key key, this.fileModel, this.showReadMoreButton, this.readMorePressed})
      : super(key: key);
  final ListItem fileModel;
  final showReadMoreButton;
  final VoidCallback readMorePressed;

  @override
  _PlayerWidgetState createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  bool _playing = false;
  static Duration position;
  static Duration maxDuration;
  static double widthOfScreen = 1;
  var _lightColor = Color(0xffebe7e4);

  @override
  void initState() {
    super.initState();
    MeditoAudioPlayer()
        .audioPlayer
        .onAudioPositionChanged
        .listen((Duration p) => {setState(() => position = p)});

    MeditoAudioPlayer().audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      setState(() => maxDuration = d);
    });

    MeditoAudioPlayer()
        .audioPlayer
        .onPlayerStateChanged
        .listen((AudioPlayerState s) {
      if (s == AudioPlayerState.PAUSED) {
        setState(() {
          _playing = false;
        });
      }

      if (s == AudioPlayerState.COMPLETED || s == AudioPlayerState.STOPPED) {
        setState(() {
          _playing = false;
          maxDuration = Duration(seconds: 0);
          position = Duration(seconds: 0);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widthOfScreen = MediaQuery.of(context).size.width;

    return Container(
      color: Color(0xff343b43),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _buildMarquee(),
          widget.showReadMoreButton ? _buildReadMoreButton() : Container(),
          buildControlRow(),
          buildSeekBar()
        ],
      ),
    );
  }

  Widget buildSeekBar() {
    return Stack(
      children: <Widget>[
        Container(
          height: 16,
          color: Color(0xff595f65),
        ),
        Container(
          width: getSeekWidth(),
          height: 16,
          color: _lightColor,
        )
      ],
    );
  }

  double getSeekWidth() {
    if (position == null || maxDuration == null) return 0;
    if (position.inMilliseconds == 0 || maxDuration.inMilliseconds == 0)
      return 0;

    var width = position.inMilliseconds.toDouble() /
        maxDuration.inMilliseconds.toDouble() *
        widthOfScreen.toDouble();

    return width <= 0 ? 0 : width;
  }

  Widget buildControlRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.padded,
            child: Text('← 15s', style: Theme.of(context).textTheme.display2),
            onPressed: _rewind,
          ),
          FlatButton(
            child: getPlayOrPauseIcon(),
            onPressed: _playing ? _pause : _play,
          ),
          FlatButton(
            child: Text('15s →', style: Theme.of(context).textTheme.display2),
            onPressed: _fastForward,
          ),
        ],
      ),
    );
  }

  Icon getPlayOrPauseIcon() {
    return _playing
        ? Icon(Icons.pause, color: _lightColor, size: 32)
        : Icon(Icons.play_arrow, color: _lightColor, size: 32);
  }

  Widget _buildMarquee() {
    return Container(
      height: 48,
      child: Marquee(
        blankSpace: 48,
        startPadding: 16,
        crossAxisAlignment: CrossAxisAlignment.center,
        accelerationCurve: Curves.easeInOut,
        text: widget.fileModel != null ? widget.fileModel.title : "  ",
        style: Theme.of(context).textTheme.display3,
      ),
    );
  }

  void _play() async {
    int result =
        await MeditoAudioPlayer().audioPlayer.play(widget.fileModel?.url);
    if (result == 1) {
      setState(() {
        _playing = true;
      });
    }
  }

  void _pause() async {
    int result = await MeditoAudioPlayer().audioPlayer.pause();
    if (result == 1) {}
  }

  void _rewind() async {
    MeditoAudioPlayer()
        .audioPlayer
        .seek(new Duration(seconds: position.inSeconds - 15))
        .then((result) {});
  }

  void _fastForward() async {
    MeditoAudioPlayer()
        .audioPlayer
        .seek(new Duration(seconds: position.inSeconds + 15))
        .then((result) {});
  }

  void _stop() async {
    int result = await MeditoAudioPlayer().audioPlayer.stop();
    MeditoAudioPlayer().audioPlayer.release();
  }

  Widget _buildReadMoreButton() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 26.0, right: 26.0),
            child: OutlineButton(
              child: Text(
                "READ MORE",
                style: Theme.of(context).textTheme.display2,
              ),
              highlightedBorderColor: MeditoColors.lightColor,
              borderSide: BorderSide(color: MeditoColors.lightColor),
              onPressed: widget.readMorePressed,
            ),
          ),
        ),
      ],
    );
  }
}