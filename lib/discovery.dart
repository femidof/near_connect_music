import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  String type = '_sizzy._tcp';
  late BonsoirDiscovery discovery;
  List<BonsoirService> discoveredServices = [];

  @override
  void initState() {
    super.initState();
    print("discoverying");
    init();
  }

  init() async {
    discovery = BonsoirDiscovery(type: type);
    await discovery.ready;

    discovery.eventStream!.listen((event) {
      // `eventStream` is not null as the discovery instance is "ready" !
      if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
        print('Service found : ${event.service?.toJson()}');
        event.service!.resolve(discovery
            .serviceResolver); // Should be called when the user wants to connect to this service.
        setState(() {
          discoveredServices.add(event.service!);
          print(event.service!);
        });
      } else if (event.type ==
          BonsoirDiscoveryEventType.discoveryServiceResolved) {
        print('Service resolved : ${event.service?.toJson()}');
        setState(() {
          discoveredServices[discoveredServices.indexWhere(
                  (service) => service.name == event.service?.name)] =
              event.service!;
        });
      } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
        print('Service lost : ${event.service?.toJson()}');
        setState(() {
          discoveredServices.remove(event.service!);
          print(event.service!);
        });
      }
    });

    await discovery.start();
  }

  disp() async {
    await discovery.stop();
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
        child: discoveredServices.isEmpty
            ? const Text("No services available")
            : ListView.builder(
                itemCount: discoveredServices.length,
                itemBuilder: (context, index) {
                  final service = discoveredServices[index];
                  return ListTile(
                    title: Text(service.name), // ?? "Unnamed Service"),
                    subtitle: Text(service.type), //?? "IPv4 not available"),
                    onTap: () {
                      // Implement logic to connect to the selected service
                    },
                  );
                },
              ),
      ),
    );
  }
}
