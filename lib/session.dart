import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SessionRoom extends StatefulWidget {
  const SessionRoom({
    Key? key,
    required this.hostname,
    required this.port,
  }) : super(key: key);
  final String hostname;
  final int port;

  @override
  State<SessionRoom> createState() => _SessionRoomState();
}

class _SessionRoomState extends State<SessionRoom> {
  var player = AudioPlayer();
  late Socket serverSocket;

  @override
  void initState() {
    super.initState();
    connect();
  }

  connect() async {
    serverSocket = await Socket.connect(widget.hostname, widget.port);

    player.playbackEventStream.listen((event) {
      // Handle playback events if needed
      print('Playback event: $event');
    });

    player.playerStateStream.listen((event) {});

    player.play();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
