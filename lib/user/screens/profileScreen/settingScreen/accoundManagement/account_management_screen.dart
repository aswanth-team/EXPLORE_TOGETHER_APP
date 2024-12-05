import 'package:flutter/material.dart';

import '../../edit_profile_screen.dart';

Map<String, dynamic> userData = {
  "userImage": "assets/profile/aswanth.webp",
  "userName": "aswanth123",
  "userMobileNumber": 85423343242,
  "userFullName": "Aswanth K",
  "userBio":
      "Lover of nature and travel. Always exploring new places and capturing memories. I believe in living life to the fullest. Come join my journey!",
  "userGender": "Male",
  "userDOB": "January 1, 1995",
  "userLocation": "Kannur, Kerala",
  "userSocialLinks": {
    "instagram": "https://www.instagram.com/a.swnth",
    "facebook": "https://www.facebook.com/aswanth.kumar",
    "gmail": "aswanth.kumar@gmail.com",
    "twitter": "https://x.com/__x"
  },
  "userPosts": [
    {
      "postId": "post1",
      "tripLocation": "vattavada",
      "tripLocationDescription":
          "The city that never sleeps. Amazing places to visit!",
      "locationImages": [
        "assets/locimage/vattavada1.jpg",
        "assets/locimage/vattavada2.jpg",
        "assets/locimage/vattavada4.jpg",
      ],
      "tripCompleted": true,
      "tripDuration": 6,
      "tripRating": 4.5,
      "tripBuddies": [
        'aswanth123',
        'ajmal12',
        'vyshnav221',
      ],
      "tripFeedback": "nice",
      "planToVisitPlaces": [
        'Mattupetty Dam',
        'Top Station',
        'Pampadum Shola National Park',
        'Vattavada Beauty View Point',
        ' Strawberry Farm',
        ' Pazhathottam View Point',
        ' Chilanthiyar Waterfall'
      ],
      "visitedPlaces": [
        'Mattupetty Dam',
        'Top Station',
        'Vattavada Beauty View Point'
      ],
    },
    {
      "postId": "post2",
      "tripLocation": "Manali",
      "tripLocationDescription":
          "Manali is a high-altitude Himalayan resort town in India’s northern Himachal Pradesh state.",
      "tripDuration": 7,
      "locationImages": [
        "assets/locimage/manali1.jfif",
        "assets/locimage/manali2.jfif",
        "assets/locimage/manali3.jpg",
        "assets/locimage/manali4.jpg",
      ],
      "tripCompleted": false,
      "tripRating": null,
      "tripBuddies": null,
      "tripFeedback": null,
      "planToVisitPlaces": [
        'Hadimba Mata Temple',
        'Solang',
        'Old Manali',
        'Hidimba Devi Temple',
        'Jogini Waterfall',
        'Shri Anjani Mahadev Mandir'
      ],
      "visitedPlaces": null,
    }
  ],
  "tripPhotos": [
    'assets/profile/aswanth.webp',
    "assets/locimage/andamanandnicobarislands11.jpg",
    "assets/locimage/andamanandnicobarislands22.jpg",
    "assets/locimage/andamanandnicobarislands22.jpg",
    "assets/locimage/andamanandnicobarislands22.jpg",
    "assets/locimage/andamanandnicobarislands22.jpg",
    "assets/locimage/andamanandnicobarislands22.jpg",
    "assets/locimage/andamanandnicobarislands22.jpg",
    "assets/locimage/andamanandnicobarislands33.webp",
  ],
};

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
