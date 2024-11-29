import 'package:flutter/material.dart';
import 'admin/screens/admin_screen.dart';
import 'user/screens/registration_screen.dart';
import 'user/screens/user_screen.dart';


// LoginScreen widget where users can log in with their credentials
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Global key for form validation
  TextEditingController usernameController =
      TextEditingController(); // Controller for username/email input
  TextEditingController passwordController =
      TextEditingController(); // Controller for password input
  bool _isPasswordHidden = true; // Boolean to toggle password visibility

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

  // Function to handle the login process (dummy function for now)
  void loginHandle() {
    if (_formKey.currentState!.validate()) {
      // Here, you would usually call an API or some logic to verify the user's credentials
      print("Username/Email: ${usernameController.text}");
      print("Password: ${passwordController.text}");

      // Check the values of username and password (text properties, not the controllers themselves)
      if (usernameController.text == "login" &&
          passwordController.text == "password") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminScreen(),
          ),
        );
      } else {
        // Navigate to the user screen after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Static background image with overlay for transparency
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg2.jpg'), // Your background image
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color:
                    Colors.black.withOpacity(0.4), // Overlay with 40% opacity
              ),
            ),
          ),
          // Main content in the center of the screen
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Main Heading for the Login Screen
                      Text(
                        'Welcome Back!',
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
                      SizedBox(height: 10),
                      // Subheading for the Login Screen
                      Text(
                        'Please log in to continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 40),
                      // Username or Email input field
                      TextFormField(
                        controller: usernameController,
                        decoration:
                            _inputDecoration('Username or Email', Icons.person),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username or email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      // Password input field
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20),
                      // "Forgot Password?" link on the right side
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Navigate to forgot password screen (You can create this screen)
                            print("Forgot Password Clicked");
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 255, 0, 0)),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Login Button
                      ElevatedButton(
                        onPressed: loginHandle,
                        child: Text("Login"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                      ),

                      SizedBox(height: 20),
                      // "Don't have an account? Signup" link at the bottom
                      TextButton(
                        onPressed: () {
                          // Navigate to the Registration Screen for sign-up
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationScreen()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: TextStyle(
                              color: Colors.white, // White color for this part
                              fontWeight: FontWeight.bold,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Signup', // Blue color for 'Signup'
                                style: TextStyle(
                                  color: Colors.blue, // Blue color for 'Signup'
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
