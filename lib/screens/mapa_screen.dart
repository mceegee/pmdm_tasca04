import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

// NOVA FUNCIONALITAT:
// Ubicació actual
// https://www.youtube.com/watch?v=4ucWoHtBby0
// https://pub.dev/packages/location

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final locationController = Location();

  late LatLng currentPosition;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  MapType currentMapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    fetchLocationUpdates();
    final ScanModel scan =
        ModalRoute.of(context)?.settings.arguments as ScanModel;

    final CameraPosition currentLocationCamera = CameraPosition(target: currentPosition, zoom: 17, tilt: 50);

    final CameraPosition _puntInicial =
        CameraPosition(target: scan.getLatLng(), zoom: 17, tilt: 50);

    Set<Marker> markers = new Set<Marker>();
    markers.add(
        new Marker(position: scan.getLatLng(), markerId: MarkerId('desti')));
    markers.add(new Marker(
        position: currentPosition!, markerId: MarkerId('localitzacio')));

    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapType: currentMapType,
        markers: markers,
        initialCameraPosition: _puntInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.location_pin),
            onPressed: () async {
              // https://stackoverflow.com/questions/62722671/google-maps-camera-position-updating-issues-in-flutter
              final GoogleMapController controller = await _controller.future;
              controller
                  .moveCamera(CameraUpdate.newCameraPosition(_puntInicial));
            },
          ),
          IconButton(
            icon: Icon(Icons.layers_outlined),
            onPressed: () {
              // https://stackoverflow.com/questions/63430486/flutter-google-maps-how-can-you-change-maptype-after-runtime
              setState(() {
                currentMapType = (currentMapType == MapType.normal)
                    ? MapType.hybrid
                    : MapType.normal;
              });
            },
          ),
          IconButton(
               onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              controller
                  .moveCamera(CameraUpdate.newCameraPosition(currentLocationCamera));
            },
              icon: Icon(Icons.person_pin_circle_outlined))
        ],
      ),
    );
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus isGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    isGranted = await locationController.hasPermission();
    if (isGranted == PermissionStatus.denied) {
      isGranted = await locationController.requestPermission();
      if (isGranted != PermissionStatus.granted) {
        return;
      }
    }
    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }
    });
  }
}
