import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapGeolocation extends StatefulWidget {
  const MapGeolocation({Key? key}) : super(key: key);

  @override
  State<MapGeolocation> createState() => _MapGeolocationState();
}

class _MapGeolocationState extends State<MapGeolocation> {
  List<LatLng> tappedPoints = [];
  LatLng? currentPosition;
  late final MapController _mapController;
  String action = '';

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    tappedPoints.add(LatLng(21.0278, 105.8342));
    // initLocationService();
  }

  @override
  Widget build(BuildContext context) {
    final markers = tappedPoints.map((latlng) {
      return Marker(
        width: 10,
        height: 10,
        point: latlng,
        builder: (ctx) => const Icon(Icons.location_on_outlined),
      );
    }).toList();
    return Scaffold(
      body: SafeArea(
          bottom: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Tap to add new mark'),
            ),
             Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 10),
              child: Text(action, style: const TextStyle(color: Colors.red),),
            ),
            Flexible(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(21.0278, 105.8342),
                  zoom: 13,
                  onTap: _handleTap,
                  onLongPress: getLocation,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  void _handleTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      tappedPoints.add(latlng);
      action = 'Bạn vừa tap vào điểm : Kinh độ : ${latlng.latitude.toStringAsFixed(3)}  -  Vĩ độ : ${latlng.longitude.toStringAsFixed(3)}';
    });
  }

  void getLocation(TapPosition tapPosition, LatLng latlng) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      await Geolocator.openAppSettings();
      await Geolocator.openLocationSettings();
      Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(
        'thisss vi do : ${position.latitude} - kinh do : ${position.longitude}');
    _mapController.move(LatLng(position.latitude, position.longitude), 16);
    setState(() {
      tappedPoints.add(LatLng(position.latitude, position.longitude));
      action = 'Tọa độ của bạn : Kinh độ : ${position.latitude}  -  Vĩ độ : ${position.longitude}';
    });
  }
}
