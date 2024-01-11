import 'dart:io';
import 'dart:typed_data';

main() async {
  final server = await ServerSocket.bind('0.0.0.0', 52098); //::1
  // Server();

  print("Server is running on: ${server.address.host}:${server.port}");

  await for (var socket in server) {
    handleConnection(socket);
  }

  server.listen((Socket event) {
    handleConnection(event);
  });
}

List<Socket> clients = [];

void handleConnection(Socket client) {
  print(
    "Server: Connection from ${client.remoteAddress.address}:${client.remotePort}",
  );

  client.listen(
    (Uint8List data) async {
      final message = String.fromCharCodes(data);

      for (final c in clients) {
        c.write("Server: $message joined the party!");
      }
      print(message);

      clients.add(client);
      client.write("Server: You are logged in as: $message");
    }, // handle errors
    onError: (error) {
      print(error);
      client.close();
    },

    // handle the client closing the connection
    onDone: () {
      print('Server: Client left');
      client.close();
    },
  );

  sendMessage(client);
}

sendMessage(Socket client) {
  client.add([1]);
  client.write([1]);
}
