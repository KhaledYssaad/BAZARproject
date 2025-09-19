import 'package:app/constants/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChangeLocation extends StatefulWidget {
  final void Function(String) onLocationSelected;
  String? selectedLocation;

  ChangeLocation(
      {required this.selectedLocation,
      super.key,
      required this.onLocationSelected});

  @override
  State<ChangeLocation> createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {
  late String? selectedLocation;
  @override
  void initState() {
    super.initState();
    selectedLocation = widget.selectedLocation;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 4,
            width: 56,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.BordersGrey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Detail Address",
                      style: TextStyle(
                        fontFamily: "Open Sans",
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        height: 1.35,
                        letterSpacing: -0.03 * 18,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.my_location_outlined,
                        color: AppColors.primaryPurple,
                        size: 24,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            final TextEditingController locationController =
                                TextEditingController();
                            return Dialog(
                              backgroundColor: Colors
                                  .transparent, // transparent to allow rounded corners
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Enter Location",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromARGB(235, 12, 12, 68),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Use UserInfoInput style directly
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Location",
                                            style: TextStyle(
                                              fontFamily: "Roboto",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(
                                                  235, 12, 12, 68),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          TextField(
                                            controller: locationController,
                                            style: const TextStyle(
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              height: 1.5,
                                              letterSpacing: 0,
                                            ),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor:
                                                  AppColors.VeryLightGrey,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 14,
                                                      horizontal: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      child: FilledButton(
                                        style: FilledButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryPurple,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () {
                                          String location =
                                              locationController.text;
                                          setState(() {
                                            selectedLocation = location;
                                          });
                                          widget.onLocationSelected(location);
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Submit",
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
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryPurple10,
                      ),
                      child: const Icon(
                        Icons.location_pin,
                        color: AppColors.primaryPurple,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Current Location",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          if (selectedLocation != null)
                            Text(
                              selectedLocation!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (selectedLocation == null)
                            const Text(
                              "No location selected",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black38,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
