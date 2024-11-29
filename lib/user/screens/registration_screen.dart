import 'package:flutter/material.dart';

import '../../login_screen.dart';


// This is the RegistrationScreen widget, which is the main screen for user registration
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Global key for form validation
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers for each input field
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController aadhaarController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Gender selection variable
  String? gender;

  // Password visibility toggle variables
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  // Set a single background image (this will be your static image)
  final String _backgroundImage = 'assets/bg2.jpg';

  // Function to show date picker and set the selected date in the dobController
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // Email validation pattern
  String? _validateEmail(String? value) {
    final emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regex = RegExp(emailPattern);
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!regex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  // Required field validation function
  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  // Confirm password validation function (checks if passwords match)
  String? _confirmPasswordValidator(String? value) {
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Input decoration helper function to style text fields
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.blueGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide:
            BorderSide(color: const Color.fromARGB(255, 2, 34, 61), width: 2),
      ),
      prefixIcon: Icon(icon, color: Colors.blueGrey),
      fillColor: Colors.white.withOpacity(0.5), // Reduced opacity (50%)
      filled: true,
    );
  }

  // This function handles the form submission if all fields are valid
  void signuphandle() {
    if (_formKey.currentState!.validate()) {
      // Print out form values (used for debugging or further processing)
      print("Name: ${nameController.text}");
      print("DOB: ${dobController.text}");
      print("Gender: $gender");
      print("Aadhaar Number: ${aadhaarController.text}");
      print("Mobile Number: ${mobileController.text}");
      print("Username: ${usernameController.text}");
      print("Email: ${emailController.text}");
      print("Password: ${passwordController.text}");
      print("Confirm Password: ${confirmPasswordController.text}");

      // Navigate to Login Screen after successful registration
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginScreen();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Static background image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_backgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.black.withOpacity(0.4), // 40% opacity overlay
              ),
            ),
          ),
          // Slightly transparent black overlay to darken the background
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          // Centered content with form and text fields
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Main Heading with enhanced styling
                      Text(
                        'Become a part of us',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 10.0,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Form fields for user input
                      TextFormField(
                        controller: nameController,
                        decoration: _inputDecoration('Name', Icons.person),
                        validator: _requiredValidator,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: dobController,
                              readOnly: true,
                              decoration: _inputDecoration(
                                  'Date of Birth', Icons.calendar_today),
                              onTap: () => _selectDate(context),
                              validator: _requiredValidator,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: gender,
                              decoration:
                                  _inputDecoration('Gender', Icons.person),
                              items: ['Male', 'Female', 'Others']
                                  .map((String value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      ))
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  gender = newValue;
                                });
                              },
                              validator: (value) =>
                                  value == null ? 'Gender is required' : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: aadhaarController,
                        decoration: _inputDecoration(
                            'Aadhaar Number', Icons.credit_card),
                        validator: _requiredValidator,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: mobileController,
                        decoration:
                            _inputDecoration('Mobile Number', Icons.phone),
                        validator: _requiredValidator,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: usernameController,
                        decoration:
                            _inputDecoration('Username', Icons.account_circle),
                        validator: _requiredValidator,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: emailController,
                        decoration:
                            _inputDecoration('Email Address', Icons.email),
                        validator: _validateEmail,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _isPasswordHidden,
                        decoration:
                            _inputDecoration('Password', Icons.lock).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordHidden = !_isPasswordHidden;
                              });
                            },
                          ),
                        ),
                        validator: _requiredValidator,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: _isConfirmPasswordHidden,
                        decoration:
                            _inputDecoration('Confirm Password', Icons.lock)
                                .copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordHidden =
                                    !_isConfirmPasswordHidden;
                              });
                            },
                          ),
                        ),
                        validator: _confirmPasswordValidator,
                      ),
                      SizedBox(height: 20),
                      // Register button
                      ElevatedButton(
                        onPressed: signuphandle,
                        child: Text("Register"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Redirect to login page if user already has an account
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text:
                                'Already have an account? ', // First part of text
                            style: TextStyle(
                              color: Colors.white, // White color for this part
                              fontWeight: FontWeight.bold,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Login', // Second part of text
                                style: TextStyle(
                                  color: Colors.red, // Red color for 'Login'
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
