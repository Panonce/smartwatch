import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Respond extends StatefulWidget {
  const Respond({Key? key}) : super(key: key);

  @override
  State<Respond> createState() => _RespondState();
}

class _RespondState extends State<Respond> {
  final Completer<GoogleMapController> _controller = Completer();

  //static const LatLng userLocation = LatLng();
  //static const LatLng volunteerLocation = LatLng();

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  /// marker icons
  BitmapDescriptor userIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor volunteerIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(
            newLoc.latitude!,
            newLoc.longitude!,
          )),
        ),
      );
      setState(() {});
    });
  }

/*void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(userLocation.latitude, userLocation.longitude),
      PointLatLng(volunteerLocation.latitude, volunteerLocation.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }*/

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/user.png")
        .then((icon) {
      userIcon = icon;
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/location.png")
        .then((icon) {
      volunteerIcon = icon;
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    setCustomMarkerIcon();
    //getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Responding',
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
      ),
      body: currentLocation == null
          ? Center(child: Text("Loading"))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(10.3004, 123.8880),
                zoom: 14.5,
              ),
              polylines: {
                Polyline(
                  polylineId: PolylineId("route"),
                  points: polylineCoordinates,
                  color: Colors.deepOrange.shade200,
                  width: 6,
                ),
              },
              markers: {
                Marker(
                  markerId: MarkerId("user"),
                  icon: userIcon,
                  //position: userLocation,
                ),
                Marker(
                  markerId: MarkerId("volunteer"),
                  icon: volunteerIcon,
                  //position: volunteerLocation,
                ),
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
            ),
    );
  }
}
