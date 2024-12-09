import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final otpController = TextEditingController(); // Single controller for OTP
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool usernameExists = false;
  bool otpVerified = false;

  // Input Decoration Function
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      floatingLabelBehavior:
          FloatingLabelBehavior.never, // Prevents top-left float
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

  // Simulate OTP verification logic
  Future<bool> _verifyOtp() async {
    String enteredOtp = otpController.text;
    if (enteredOtp == "123456") {
      return true;
    } else {
      return false;
    }
  }

  // Simulate password change function
  Future<void> _changePassword() async {
    String username = usernameController.text;
    String newPassword = newPasswordController.text;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password changed successfully!")),
    );

    // Navigate back to the previous screen after password change
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/defaults/registration.png'), // Set your background image here
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!usernameExists)
                TextFormField(
                  controller: usernameController,
                  decoration: _inputDecoration("Username", Icons.person),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your username";
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 20),

              // Check button: Verify if the username exists
              if (!usernameExists)
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        usernameExists = true;
                      });
                    }
                  },
                  child: const Text("Check Username"),
                ),
              const SizedBox(height: 20),

              // OTP Field: Single text field for OTP entry
              if (usernameExists && !otpVerified)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Pinput(
                    length: 6,
                    showCursor: true,
                    onCompleted: (pin) async {
                      otpController.text =
                          pin; // Assign the pin to your controller
                      bool isOtpVerified = await _verifyOtp();
                      if (isOtpVerified) {
                        setState(() {
                          otpVerified = true;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Invalid OTP, try again.")),
                        );
                      }
                    },
                    validator: (pin) {
                      if (pin == null || pin.isEmpty || pin.length != 6) {
                        return "Please enter a 6-digit OTP";
                      }
                      return null;
                    },
                  ),
                ),
              const SizedBox(height: 20),

              // Verify Button: Shows after OTP fields
              if (usernameExists && !otpVerified)
                ElevatedButton(
                  onPressed: () async {
                    bool isOtpVerified = await _verifyOtp();
                    if (isOtpVerified) {
                      setState(() {
                        otpVerified = true;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Invalid OTP, try again.")),
                      );
                    }
                  },
                  child: const Text("Verify OTP"),
                ),
              const SizedBox(height: 20),

              // New Password and Confirm Password Fields
              if (otpVerified)
                Column(
                  children: [
                    TextFormField(
                      controller: newPasswordController,
                      decoration: _inputDecoration("New Password", Icons.lock),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a new password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: confirmPasswordController,
                      decoration: _inputDecoration(
                          "Confirm New Password", Icons.lock_outline),
                      obscureText: true,
                      validator: (value) {
                        if (value != newPasswordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _changePassword();
                        }
                      },
                      child: const Text("Change Password"),
                    ),
                  ],
                ),
              TextButton.icon(
                icon: Icon(Icons.cancel,
                    color: Colors.red), // Cancel icon with red color
                label: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.red, // Set matching color for the text
                    fontSize: 16, // Optional: Adjust text size
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous screen
                },
                style: TextButton.styleFrom(
                  foregroundColor:
                      Colors.red, // Set text and icon color when pressed
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
