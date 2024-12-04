import 'package:flutter/material.dart';

class AccountManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Management')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Profile'),
            trailing: Icon(Icons.chevron_right), // Added trailing icon
            onTap: () {
              // Navigate to Edit Profile page
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password'),
            trailing: Icon(Icons.chevron_right), // Added trailing icon
            onTap: () {
              // Navigate to Change Password page
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.red), // Red icon
            title: Text(
              'Delete Account',
              style: TextStyle(color: Colors.red), // Red text
            ),
            onTap: () {
              // Navigate to Delete Account page
            },
          ),
        ],
      ),
    );
  }
}
