import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';




class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  late GoogleMapController _controller;

  double _geofenceRadius = 10.0; // in meters
  LatLng _geofenceCenter = LatLng(0, 0);  // center of the geofence

  late User currentUser;


  Future<bool> _isInsideGeofence(Position position) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    // Get the current user's location
    final currentUserPosition = LatLng(position.latitude, position.longitude);
    _geofenceCenter =
        currentUserPosition; // update the geofence center to the user's location
    print('the Radius: $_geofenceRadius');
    print('The current user is: $currentUser');

    // Check if the current user is within the geofence
    final distanceInMeters = await Geolocator.distanceBetween(
      _geofenceCenter.latitude,
      _geofenceCenter.longitude,
      currentUserPosition.latitude,
      currentUserPosition.longitude,
    );
    print(
        'Distance from current user to geofence center: $distanceInMeters meters');

    // Retrieve other user locations from Firestore
    QuerySnapshot<Map<String, dynamic>>? otherUsersSnapshot;
    try {
      print('Before Firestore query');
      otherUsersSnapshot = await FirebaseFirestore.instance
          .collection('location')
          .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .orderBy('uid')
          .orderBy('timestamp', descending: true)
          .get();
      print('After Firestore query');
      print('Number of documents: ${otherUsersSnapshot.docs.length}');
    } catch (e) {
      print('Firestore query failed with error: $e');
    }

// Check if any other user is within the geofence
    bool isOtherUserWithinGeofence = false;
    if (otherUsersSnapshot != null) {
      for (final otherUserDoc in otherUsersSnapshot.docs) {
        final otherUserPosition = LatLng(
          otherUserDoc['latitude'] as double,
          otherUserDoc['longitude'] as double,
        );
        final distanceInMeters = await Geolocator.distanceBetween(
          _geofenceCenter.latitude,
          _geofenceCenter.longitude,
          otherUserPosition.latitude,
          otherUserPosition.longitude,
        );
        debugPrint(
            'Distance from other user to geofence center: $distanceInMeters meters');
        if (distanceInMeters <= _geofenceRadius) {
          isOtherUserWithinGeofence = true;
          break;
        }
      }
    }
// No user is within the geofence
    return isOtherUserWithinGeofence;
  }


    Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    /// Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final user = await FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance.collection('location').add({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': Timestamp.now(),
      'uid': user.uid,
    });

    // Update the _geofenceCenter variable to the user's current location
    _geofenceCenter = LatLng(position.latitude, position.longitude);

    return await Geolocator.getCurrentPosition();
  }


  void _checkGeofence() async {
    final position = await _determinePosition();
    final isInsideGeofence = await _isInsideGeofence(position);
    if (isInsideGeofence) {
      // Show a dialog if any other user is within the geofence
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alert'),
            content: const Text('There are other users within the geofence.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {

      // Show a dialog if no user is within the geofence
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alert'),
            content: const Text('No users within the geofence.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),

                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _determinePosition().then((Position position) {
      if (mounted) {
        setState(() {
          final LatLng _currentPosition =
              LatLng(position.latitude, position.longitude);
          final CameraPosition _currentCameraPosition = CameraPosition(
              target: _currentPosition, zoom: 18.0, tilt: 5, bearing: 0);
          _controller.animateCamera(
              CameraUpdate.newCameraPosition(_currentCameraPosition));
        });
      }
    });
  }

  static final LatLng _kMapCenter = LatLng(10.3004, 123.8880);

  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 18.0, tilt: 5, bearing: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
          circles: Set<Circle>.of([
            Circle(
              circleId: CircleId('myCircle'),
              center: _geofenceCenter,
              radius: _geofenceRadius,
              strokeWidth: 2,
              strokeColor: Colors.red,
              fillColor: Colors.red.withOpacity(0.3),
            ),
          ]),
          initialCameraPosition: _kInitialPosition,
          mapType: MapType.hybrid,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomGesturesEnabled: true,
          compassEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _checkGeofence,
        child: Icon(Icons.check),
      ),
    );
  }
}
