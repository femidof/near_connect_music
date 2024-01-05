import 'package:flutter/material.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:uuid/uuid.dart';

class BroadcastScreen extends StatefulWidget {
  const BroadcastScreen({super.key});

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  var uuid = const Uuid();
  late BonsoirBroadcast broadcast;
  // MediaStream? _mediaStream = MediaStream(" ", " ");

  @override
  void initState() {
    super.initState();
    print("broadcasting");
    init();
  }

  void init() async {
    BonsoirService service = BonsoirService(
      name: '${uuid.v1().split('-').last} Near Share Services',
      type: '_sizzy._tcp',
      port: 3333,
    );

    broadcast = BonsoirBroadcast(service: service);
    await broadcast.ready;
    await broadcast.start();
  }

  void disp() async {
    await broadcast.stop();
  }

  @override
  void dispose() {
    disp();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Broadcasting your music here!',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: null,
              child: Text(
                  "Broadcasting ${uuid.v1().split('-').last} Near Share Services"),
            ),
          ],
        ),
      ),
    );
  }
}
