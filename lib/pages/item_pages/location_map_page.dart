import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationMapPage extends StatefulWidget {
  final Map<String, dynamic> itemDocs;
  final User user;
  final Item item;

  const LocationMapPage({
    super.key,
    required this.itemDocs,
    required this.user,
    required this.item,
  });

  @override
  State<LocationMapPage> createState() => _LocationMapPageState();
}

class _LocationMapPageState extends State<LocationMapPage> {
  @override
  Widget build(BuildContext context) {
    final LatLng itemLatLng = LatLng(
      widget.item.location['coordinates'][1],
      widget.item.location['coordinates'][0],
    );

    final LatLng userLatLng = LatLng(
      widget.user.location!['coordinates'][1],
      widget.user.location!['coordinates'][0],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Location Map"),
        actions: [
          TextButton(onPressed: () async{
            final emailUri = Uri(scheme: "mailto", path: "nextgenhealthcaresupport.se@gmail.com", query:
              Uri.encodeFull("subject= Reporting ${widget.user.userName}&body=I am reporting *${widget.user.userName}* with userId *${widget.user.userId}* for ")
            );
            if(await canLaunchUrl(emailUri)){
              await launchUrl(emailUri);
            }else{await launchUrl(emailUri);}
          }, child: const Text("Report User"))
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            height: MediaQuery.sizeOf(context).height * .70,
            width: MediaQuery.sizeOf(context).width * .95,
            child: FlutterMap(
              options: MapOptions(initialZoom: 15, initialCenter: itemLatLng),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName:
                      'com.saadc.next_gen_ai_healthcare', // Replace with your package
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
          Text("Returning Date: ${widget.itemDocs['returnDate']}"),
          Text("User: ${widget.user.userId}"),
          Text("Item: ${widget.item.itemName}"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * .35,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final String googleMapsUrl =
                        'https://www.google.com/maps/dir/?api=1&destination=${widget.item.location['coordinates'][1]},${widget.item.location['coordinates'][0]}';
                    if (true) {
                      // await canLaunchUrl(Uri.parse(googleMapsUrl))
                      await launchUrl(
                        Uri.parse(googleMapsUrl),
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Could not open Google Maps')),
                      );
                    }
                  },
                  icon: const Icon(Icons.map),
                  label: const Text("Directions"),
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * .35,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final message =
                        'Check out this location: https://www.google.com/maps?q=${widget.item.location['coordinates'][1]},${widget.item.location['coordinates'][0]}';

                    final phone =
                        widget.user.phoneNumber?.replaceAll('+', '') ?? "";

                    final whatsappUrl =
                        'https://wa.me/$phone?text=${Uri.encodeComponent(message)}';

                    if (true) {
                      // await canLaunchUrl(Uri.parse(whatsappUrl))
                      await launchUrl(
                        Uri.parse(whatsappUrl),
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Could not open WhatsApp')),
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
