import 'package:app/apiServices/notification_service.dart';
import 'package:app/constants/colors.dart';
import 'package:app/apiServices/long_lat_service.dart';
import 'package:app/home/profilescreen/change_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class AddressScreen extends StatefulWidget {
  AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool isLoading = true;
  String? currAddress;
  final MapController mapController = MapController();
  LocationData? currentLocation;

  Marker? selectedLocationMarker;
  Marker? currentLocationMarker;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    var location = Location();

    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          _showError("Location service is required");
          setState(() => isLoading = false);
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          _showError("Location permission is required");
          setState(() => isLoading = false);
          return;
        }
      }
      var userLocation = await location.getLocation();
      _updateCurrentLocationMarker(userLocation);

      await _setCurrentLocationAsSelected();

      setState(() => isLoading = false);

      location.onLocationChanged.listen(_updateCurrentLocationMarker);
    } catch (e) {
      _showError("Failed to get current location");
      setState(() => isLoading = false);
    }
  }

  void _updateCurrentLocationMarker(LocationData newLocation) {
    setState(() {
      currentLocation = newLocation;
      currentLocationMarker = Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(
          newLocation.latitude!,
          newLocation.longitude!,
        ),
        child: const Icon(Icons.my_location, color: Colors.blue, size: 40.0),
      );
    });
  }

  Future<void> _setCurrentLocationAsSelected() async {
    if (currentLocation != null) {
      setState(() {
        selectedLocationMarker = Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(
            currentLocation!.latitude!,
            currentLocation!.longitude!,
          ),
          child: const Icon(
            Icons.location_on,
            color: Colors.red,
            size: 40,
          ),
        );
        currAddress = "Current Location";
      });

      mapController.move(
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        15,
      );
    }
  }

  Future<void> _setAddressOnMap(String address) async {
    try {
      final coords = await getCoordinatesFromAPI(address);
      if (coords != null) {
        setState(() {
          selectedLocationMarker = Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(coords["lat"]!, coords["lon"]!),
            child: const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 40,
            ),
          );
        });

        mapController.move(LatLng(coords["lat"]!, coords["lon"]!), 15);
      } else {
        _showError("Location not found");
      }
    } catch (e) {
      _showError("Failed to set location on map");
    }
  }

  Future<void> _onLocationSelected(String newAddress) async {
    try {
      await _setAddressOnMap(newAddress);

      setState(() => currAddress = newAddress);

      Navigator.pop(context);
      showNotification(
        id: 6,
        title: "Location Updated",
        body: "Your location was updated to: $newAddress",
      );
    } catch (e) {
      showNotification(
        id: 7,
        title: "Update Failed",
        body: "We couldn’t update your location. Please try again.",
      );
    }
  }

  _showChangeLocationDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      barrierColor: Colors.black26,
      builder: (BuildContext context) {
        final double sheetHeight = MediaQuery.of(context).size.height - 330;

        return Container(
          height: sheetHeight,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ChangeLocation(
            selectedLocation: currAddress,
            onLocationSelected: _onLocationSelected,
          ),
        );
      },
    );
  }

  void _goToCurrentLocation() {
    if (currentLocation != null) {
      mapController.move(
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        15.0,
      );
    } else {
      _showError("Current location not available");
    }
  }

  void _resetToCurrentLocation() async {
    if (currentLocation != null) {
      await _setCurrentLocationAsSelected();

      showNotification(
        id: 8,
        title: "Location Reset",
        body: "Your location has been reset to your current position.",
      );
    } else {
      showNotification(
        id: 9,
        title: "Unavailable",
        body: "Your current location is not available.",
      );
    }
  }

  void _showError(String message) {
    showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000), // unique ID
      title: "Error",
      body: message,
    );
  }

  List<Marker> get _allMarkers {
    List<Marker> markers = [];
    if (currentLocationMarker != null) markers.add(currentLocationMarker!);
    if (selectedLocationMarker != null) markers.add(selectedLocationMarker!);
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Location',
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Open Sans",
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          if (currAddress != "Current Location" && currentLocation != null)
            IconButton(
              icon: const Icon(Icons.gps_fixed),
              onPressed: _resetToCurrentLocation,
              tooltip: "Reset to current location",
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24.0),
            width: double.infinity,
            height: 280,
            decoration: const BoxDecoration(color: Colors.white),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: isLoading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text("Getting your location..."),
                        ],
                      ),
                    )
                  : FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter: selectedLocationMarker?.point ??
                            currentLocationMarker?.point ??
                            const LatLng(0, 0),
                        initialZoom: 15.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        ),
                        if (_allMarkers.isNotEmpty)
                          MarkerLayer(markers: _allMarkers),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 12),
          if (currAddress != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Selected Location:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            currAddress!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (currAddress == "Current Location")
                          const Icon(
                            Icons.my_location,
                            color: Colors.blue,
                            size: 20,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              onPressed: _showChangeLocationDialog,
              child: const Text(
                "Change Location",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCurrentLocation,
        backgroundColor: AppColors.primaryPurple,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}
