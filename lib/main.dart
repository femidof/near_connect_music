import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:near_connect/discovery.dart';
import 'package:near_connect/broadcast.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (await Permission.audio.status != PermissionStatus.granted) {
    await Permission.audio.request();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _askPermissions();
  }

  _askPermissions() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      //permission is granted
      print("granted permission");
    } else {
      //permission denied or undermined
      print("denied permission");
      await [Permission.audio].request();
      await [Permission.microphone].request();
      await [Permission.mediaLibrary].request();
    }
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.audio.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.audio].request();
      return permissionStatus[Permission.audio] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  disp() async {
    await _player.dispose();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Near Share Services"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const BroadcastScreen();
                  },
                ));
              },
              child: const Text("Broadcast"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const DiscoveryScreen();
                  },
                ));
              },
              child: const Text("Discovery"),
            ),
            IconButton(
                onPressed: () async {
                  try {
                    final play = await _player.setUrl(
                      "http://commondatastorage.googleapis.com/codeskulptor-demos/DDR_assets/Sevish_-__nbsp_.mp3",
                    );
                    // 'https://gp1.wpc.edgecastcdn.net/802892/production/audio_player/download_song_direct/24836203/4245b5b9e2fdccefcd230c28ac1e6d61');

                    _player.play();
                  } catch (e) {
                    print(e);
                  }
                },
                icon: const Icon(Icons.play_arrow)),
          ],
        ),
      ),
    );
  }
}
