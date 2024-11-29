import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../login_screen.dart'; // Make sure to import your LoginScreen class

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          // Support Option
          ListTile(
            title: Text('Support'),
            onTap: () {
              // Navigate to Support page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SupportPage()),
              );
            },
          ),
          
          // Help Option
          ListTile(
            title: Text('Help'),
            onTap: () {
              // Navigate to Help page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpPage()),
              );
            },
          ),
          
          // Account Management Option
          ListTile(
            title: Text('Account Management'),
            onTap: () {
              // Navigate to Account Management page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountManagementPage()),
              );
            },
          ),
          
          // Logout Option
          ListTile(
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              // Clear cache, user details, and log out
              await clearUserDetails();
              
              // Navigate to LoginScreen after logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  // Function to clear user details and cache
  Future<void> clearUserDetails() async {
    // Example using shared_preferences to clear user data
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();  // Clears all shared preferences data
    
    // You can also clear other data, such as cached images, stored session tokens, etc.
    // If you're using a cache manager, you can clear it here as well.
  }
}

// Example placeholder pages for navigation
class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Support')),
      body: Center(child: Text('Support Page')),
    );
  }
}

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help')),
      body: Center(child: Text('Help Page')),
    );
  }
}

class AccountManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Management')),
      body: Center(child: Text('Account Management Page')),
    );
  }
}
