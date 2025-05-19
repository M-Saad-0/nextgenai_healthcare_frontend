import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationMapPage extends StatefulWidget {
  final Map<String, dynamic> itemLocation;
  final Map<String, dynamic> userLocation;
  final Item item;

  const LocationMapPage({
    super.key,
    required this.itemLocation,
    required this.userLocation,
    required this.item,
  });

  @override
  State<LocationMapPage> createState() => _LocationMapPageState();
}

class _LocationMapPageState extends State<LocationMapPage> {
  @override
  Widget build(BuildContext context) {
    final LatLng itemLatLng = LatLng(
      widget.itemLocation['coordinates'][1],
      widget.itemLocation['coordinates'][0],
    );

    final LatLng userLatLng = LatLng(
      widget.userLocation['coordinates'][1],
      widget.userLocation['coordinates'][0],
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Location Map")),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            height: MediaQuery.sizeOf(context).height*.8,
            width: MediaQuery.sizeOf(context).width*.95,
            child: FlutterMap(
             options: MapOptions(
              initialZoom: 15,
              initialCenter: itemLatLng
             ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.saadc.next_gen_ai_healthcare', // Replace with your package
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 40,
                      height: 40,
                      point: userLatLng,
                      child: const Icon(
                        Icons.person_pin_circle,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                    Marker(
                      width: 40,
                      height: 40,
                      point: itemLatLng,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width*.35,

                child: ElevatedButton.icon(
                onPressed: () async {
                  final String googleMapsUrl =
                    'https://www.google.com/maps/dir/?api=1&destination=${widget.itemLocation['coordinates'][1]},${widget.itemLocation['coordinates'][0]}';
                  if (true) {
                    // await canLaunchUrl(Uri.parse(googleMapsUrl))
                  await launchUrl(Uri.parse(googleMapsUrl),   mode: LaunchMode.externalApplication,
);
                  } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open Google Maps')),
                  );
                  }
                },
                icon: const Icon(Icons.map),
                label: const Text("Directions"),
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width*.35,
                child: ElevatedButton.icon(
                onPressed: () async {
                  final String whatsappUrl =
                    'https://wa.me/?text=Check%20out%20this%20location:%20https://www.google.com/maps?q=${widget.itemLocation['coordinates'][1]},${widget.itemLocation['coordinates'][0]}';
                  if (true) {
                    // await canLaunchUrl(Uri.parse(whatsappUrl))
                  await launchUrl(Uri.parse(whatsappUrl),   mode: LaunchMode.externalApplication,
);
                  } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open WhatsApp')),
                  );
                  }
                },
                icon: const Icon(Icons.call),
                label: const Text("Chat"),
                ),
              ),
            ],
            ),
        ],
      ),
    );
  }
}
