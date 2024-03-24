import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;
  LatLng? _homeLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0), // Initial center of the map
          zoom: 15, // Initial zoom level
        ),
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _controller = controller;
          });
        },
        onTap: _selectLocation,
        markers: _homeLocation != null
            ? {
                Marker(
                  markerId: MarkerId('home'),
                  position: _homeLocation!,
                  infoWindow: InfoWindow(title: 'Home'),
                ),
              }
            : {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveHomeLocation,
        child: Icon(Icons.save),
      ),
    );
  }

  void _selectLocation(LatLng latLng) {
    setState(() {
      _homeLocation = latLng;
    });
  }

  void _saveHomeLocation() {
    if (_homeLocation != null) {
      // Save _homeLocation to storage or perform any other action
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Home location saved!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a home location!'),
      ));
    }
  }
}

