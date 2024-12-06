import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
//import 'dart:math';
import 'get_started_screen.dart'; // Add this package for pin input

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final dobController = TextEditingController();
  final locationController = TextEditingController();
  final aadharController = TextEditingController();
  final usernameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? _gender;
  int _step = 1;
  String otp = "";
  String generatedOtp = "";
  Timer? _timer;
  int _start = 60; // Timer for OTP resend

  // Input Decoration
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
      prefixIcon: Icon(icon, color: Colors.white),
      fillColor: Colors.black.withOpacity(0.3),
      filled: true,
    );
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.lightBlueAccent, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.lightBlueAccent, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selectedDate != null) {
      setState(() {
        dobController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  // Start OTP timer
  void startTimer() {
    _start = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _timer?.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _step++;
      });
    }
  }

  void _previousStep() {
    setState(() {
      _step--;
    });
  }

  // Generate a random OTP
  String _generateOtp() {
    //final random = Random();
    //return (random.nextInt(900000) + 100000).toString(); // 6-digit OTP
    return '777777';
  }

  // Simulate sending OTP (Replace this with actual SMS API integration)
  Future<void> _sendOtp(String mobileNumber) async {
    setState(() {
      generatedOtp = _generateOtp(); // Generate OTP
    });
    print("OTP Sent to $mobileNumber: $generatedOtp");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP sent to your mobile number.")),
    );
    startTimer();
  }

  // Store user details (currently printing)
  void _storeUserDetails() {
    print("Full Name: ${fullNameController.text}");
    print("Gender: $_gender");
    print("DOB: ${dobController.text}");
    print("Location: ${locationController.text}");
    print("Aadhar: ${aadharController.text}");
    print("Username: ${usernameController.text}");
    print("Mobile Number: ${mobileNumberController.text}");
    print("Email: ${emailController.text}");
    print("Password: ${passwordController.text}");
    // Add logic to save to the database
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/defaults/registration.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Become a part of us!",
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 70),
                    Form(
                      key: _formKey,
                      child: _step == 1
                          ? _buildStep1()
                          : _step == 2
                              ? _buildStep2()
                              : _buildStep3(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        SizedBox(
          width: 350, // Set the desired width
          child: TextFormField(
            controller: fullNameController,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration("Full Name", Icons.person),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your full name";
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 350, // Set width for the dropdown
          child: DropdownButtonFormField<String>(
            value: _gender,
            decoration: _inputDecoration("Gender", Icons.person_outline),
            items: ["Male", "Female", "Other"]
                .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(
                        gender,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ))
                .toList(),
            dropdownColor: const Color.fromARGB(255, 77, 154, 255),
            onChanged: (value) {
              setState(() {
                _gender = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please select your gender";
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 350, // Set width for the DOB field
          child: TextFormField(
            controller: dobController,
            readOnly: true,
            style: const TextStyle(color: Colors.white),
            onTap: _selectDate,
            decoration: _inputDecoration("DOB", Icons.cake),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please select your date of birth";
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 350, // Set the desired width
          child: TextFormField(
            controller: locationController,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration("Location", Icons.location_on),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your location";
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _nextStep,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            "Next",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

/*TextFormField(
          controller: aadharController,
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration("Aadhar Number", Icons.credit_card),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your Aadhar number";
            }
            return null;
          },
        ),*/
  // Build Step 2 - Additional details
  Widget _buildStep2() {
    return Column(
      children: [
        SizedBox(
          width: 350, // Set the desired width
          child: TextFormField(
            controller: usernameController,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration("Username", Icons.person),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your username";
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 350, // Set the desired width
          child: TextFormField(
            controller: mobileNumberController,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration("Mobile Number", Icons.phone),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your mobile number";
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 350, // Set the desired width
          child: TextFormField(
            controller: emailController,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration("Email", Icons.email),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your email";
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 350, // Set the desired width
          child: TextFormField(
            controller: passwordController,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration("Password", Icons.lock),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your password";
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 350, // Set the desired width
          child: TextFormField(
            controller: confirmPasswordController,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration("Confirm Password", Icons.lock),
            obscureText: true,
            validator: (value) {
              if (value != passwordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Align buttons to the edges
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _step = 1;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Back",
                style: TextStyle(
                  color: Colors.white, // Set text color to white
                ),
              ),
            ),
            SizedBox(
              width: 100,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _sendOtp(mobileNumberController.text);
                  setState(() {
                    _step = 3;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Register",
                style: TextStyle(
                  color: Colors.white, // Set text color to white
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Build Step 3 - OTP Verification
  Widget _buildStep3() {
    return Column(
      children: [
        const Text(
          "Enter OTP",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        // Edit icon to go back to registration step
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              // Navigate back to Step 2 (where user can edit details)
              setState(() {
                _step = 2;
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        Pinput(
          length: 6,
          onChanged: (value) {
            otp = value;
          },
          onCompleted: (value) {
            setState(() {
              otp = value;
            });
          },
          defaultPinTheme: PinTheme(
            height: 56,
            width: 56,
            textStyle: const TextStyle(fontSize: 22, color: Colors.black),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Resend OTP in $_start seconds",
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (otp == generatedOtp) {
              _storeUserDetails();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const GetStartedPage()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Invalid OTP")),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightGreenAccent,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text("Verify OTP"),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _start == 0
              ? () {
                  // Logic to resend OTP
                  startTimer();
                  setState(() {
                    // Reset OTP and resend
                  });
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 92, 51),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            "Resend OTP",
            style: TextStyle(
              color: Colors.white, // Set text color to white
            ),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: RegistrationScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
