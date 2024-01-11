import 'dart:io';
import 'dart:typed_data';

Future<void> main() async {
  final socket = await Socket.connect("0.0.0.0", 52098);
  print(
      'Server: Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

  socket.listen(
    (Uint8List data) {
      final serverResponse = String.fromCharCodes(data);
      print("Client $serverResponse");
    },
    // handle errors
    onError: (error) {
      print("Client: $error");
      socket.destroy();
    },

    // handle server ending connection
    onDone: () {
      print('Client: Server left.');
      socket.destroy();
    },
  );

// Ask user for its username
  String? username;

  do {
    print("Client: Please enter your username");
    username = stdin.readLineSync();
  } while (username == null || username.isEmpty);

  socket.write(username);
}
