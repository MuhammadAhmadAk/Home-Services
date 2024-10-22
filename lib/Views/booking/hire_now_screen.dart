import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:home_services/Utils/Components/custom_snakbar.dart';
import 'package:home_services/Views/bottom_navbar.dart';
import 'package:home_services/_DB%20services/bloc/booking%20cubit/booking_cubit.dart';
import 'package:home_services/_DB%20services/bloc/booking%20cubit/booking_state.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;

class HireNowScreen extends StatefulWidget {
  final Map<String, dynamic> workerdetails;
  const HireNowScreen({super.key, required this.workerdetails});

  @override
  _HireNowScreenState createState() => _HireNowScreenState();
}

class _HireNowScreenState extends State<HireNowScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController workTypeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController workStartTimeController = TextEditingController();
  final TextEditingController workEndTimeController = TextEditingController();

  int hours = 1;
  double pricePerHour = 50.0;
  String? selectedPaymentMethod = "Cash"; // Default payment method

  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  loc.LocationData? currentLocation;
  String? currentAddress;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _buttonAnimation = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    fullNameController.dispose();
    contactController.dispose();
    emailController.dispose();
    workTypeController.dispose();
    addressController.dispose();
    workStartTimeController.dispose();
    workEndTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          selectedStartTime = pickedTime;
          workStartTimeController.text = pickedTime.format(context);
        } else {
          selectedEndTime = pickedTime;
          workEndTimeController.text = pickedTime.format(context);
        }
      });
    }
  }

  loc.Location location = loc.Location();
  bool serviceEnabled = false;
  loc.PermissionStatus permissionGranted = loc.PermissionStatus.denied;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hire Now', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingConfirmedState) {
            showMessage(context, "Success", "Booking processed successfully");
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => CustomNavbar(),
            ));
          } else if (state is BookingErrorState) {
            showMessage(context, "Error", state.errorMessage.toString());
            print("Booking Error: ${state.errorMessage}");
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Personal Details",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // Full Name Field
                  TextFormField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your full name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Contact Field
                  TextFormField(
                    controller: contactController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Contact Number",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your contact number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Email Field
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Work Details",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // Work Type Field
                  TextFormField(
                    controller: workTypeController,
                    decoration: InputDecoration(
                      labelText: "Type of Work (e.g., Cleaning, Electrical)",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please specify the type of work";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Work Time Fields
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: workStartTimeController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Work Start Time",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            suffixIcon: const Icon(Icons.access_time),
                          ),
                          onTap: () => _selectTime(context, true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please select start time";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          controller: workEndTimeController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Work End Time",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            suffixIcon: const Icon(Icons.access_time),
                          ),
                          onTap: () => _selectTime(context, false),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please select end time";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Address Field
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: "Work Location Address",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.location_on),
                        onPressed:
                            _getCurrentLocation, // Fetch location when pressed
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Payment Details",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // Payment Method Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedPaymentMethod,
                    items: const [
                      DropdownMenuItem(value: "Cash", child: Text("Cash")),
                      DropdownMenuItem(
                          value: "Credit Card", child: Text("Credit Card")),
                      DropdownMenuItem(
                          value: "Bank Transfer", child: Text("Bank Transfer")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Select Payment Method",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Cost Summary
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Cost Summary",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Price per hour:",
                                style: TextStyle(fontSize: 18)),
                            Text("\$$pricePerHour",
                                style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total hours:",
                                style: TextStyle(fontSize: 18)),
                            Text("$hours hours",
                                style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total cost:",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text(
                              "\$${(pricePerHour * hours).toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Hire Now Button
                  (state is BookingLoadingState)
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<BookingCubit>().createHireBook(
                                      fullName: fullNameController.text,
                                      contactNumber: contactController.text,
                                      email: emailController.text,
                                      workType: workTypeController.text,
                                      address: addressController.text,
                                      startTime: workStartTimeController.text,
                                      endTime: workEndTimeController.text,
                                      locations: {
                                        "lat": currentLocation!.latitude,
                                        "lng": currentLocation!.longitude
                                      },
                                      paymentMethod:
                                          selectedPaymentMethod.toString(),
                                      worker: widget.workerdetails,
                                    );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text(
                              "Hire Now",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    // Check if location services are enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return; // Location services not enabled
      }
    }

    // Check for location permission
    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return; // Permission not granted
      }
    }

    // Fetch the current location
    try {
      currentLocation = await location.getLocation();
      setState(() {});
    } catch (e) {
      print("Error fetching location: $e");
    }
    try {
      currentLocation = await location.getLocation();
      setState(() {
        addressController.text =
            "Lat: ${currentLocation?.latitude}, Lon: ${currentLocation?.longitude}"; // Update address with coordinates
      });

      // Convert coordinates to a human-readable address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLocation!.latitude!,
        currentLocation!.longitude!,
      );

      if (placemarks.isNotEmpty) {
        currentAddress =
            "${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].country}";
        print(
            "Converted Address: $currentAddress"); // Print the converted address
        setState(() {
          addressController.text = currentAddress!;
        });
      }
    } catch (e) {
      print("Error fetching location: $e");
    }
  }
}
