import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../userDetailsScreen/post_details_screen.dart';
import 'edit_profile_screen.dart';
import 'post_complete_screen.dart';
import 'settingScreen/settings_screen.dart';

Map<String, dynamic> userData = {
  "userImage": "assets/profile/aswanth.webp",
  "userName": "aswanth123",
  "userMobileNumber": 85423343242,
  "useremail": "ajmaluk123nyd@gmail.com",
  "userFullName": "Aswanth K",
  "userGender": "Male",
  "userDOB": "January 1, 1995",
  "userLocation": "Kannur, Kerala",
  "userBio":
      "Lover of nature and travel. Always exploring new places and capturing memories",
  "instagram": "https://www.instagram.com/a.swnth",
  "facebook": "https://www.facebook.com/aswanth.kumar",
  "gmail": "aswanth.kumar@gmail.com",
  "twitter": "https://x.com/__x",
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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<dynamic> userPosts = userData['userPosts'] ?? [];
  final List<dynamic> tripPhotos = userData['tripPhotos'] ?? [];
  bool showPosts = true;

  void deleteTripPhoto(String photoPath, String username, int index) {
    // Remove the photo from the UI
    setState(() {
      tripPhotos.remove(photoPath);
    });

    // Call your backend function to delete the photo from the database
    // Your function to delete the trip photo from the database goes here
    print('Deleted trip photo: $photoPath by $username in $index');
  }

  void deletePost(String postId, String username) {
    // Remove post from the UI
    setState(() {
      userPosts.removeWhere((post) => post['postId'] == postId);
    });

    // Call your backend function to delete the post from the database
    // Your function to delete the post from the database goes here
    print('Deleted post: $postId by $username');
  }

  Color getBorderColor(String gender) {
    if (gender.toLowerCase() == "male") {
      return Colors.lightBlue;
    } else if (gender.toLowerCase() == "female") {
      return Colors.pinkAccent.shade100;
    } else {
      return Colors.yellow.shade600;
    }
  }

  String userImage =
      userData['userImage'] ?? 'assets/defaults/defaultUserImage.jpeg';

  void _navigateToEditProfile() async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditProfile(userData: userData), // Passing data to EditProfile
      ),
    );

    // Check if the data was updated, then update the UI
    if (updatedData != null) {
      setState(() {
        userData = updatedData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalPosts = userPosts.length;
    final int completedPosts =
        userPosts.where((post) => post['tripCompleted'] == true).length;
    return Scaffold(
      appBar: AppBar(
        title: Text(userData['userName']),
        actions: [
          // Notification Icon (Left Side)
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification press (if required)
              // For example, navigate to a notifications page
            },
          ),
          // Burger Icon (Right Side)
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Navigate to the settings page when burger icon is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: User Image and Post Counts
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Open the full-screen image in a dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pop(); // Close the dialog on tap
                              },
                              child: InteractiveViewer(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: getBorderColor(userData[
                                              'userGender'] ??
                                          ''), // Use gender to determine border color
                                      width: 1.0, // Set border width
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Optional: Rounded corners
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Match border radius
                                    child: Image.asset(
                                      userImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: getBorderColor(userData['userGender'] ??
                              ''), // Dynamically set border color
                          width: 2, // Border width
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(userImage),
                        backgroundColor: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Center the row content
                          children: [
                            // Column for "Posts"
                            Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Center the content vertically in the column
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // Align content to the center horizontally
                              children: [
                                Text(
                                  '$totalPosts', // The count (number) at the top
                                  style: const TextStyle(
                                    fontSize:
                                        24, // Larger font size for the count
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Posts', // Label below the count
                                  style: TextStyle(
                                    fontSize:
                                        12, // Smaller font size for the label
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                                width:
                                    60), // Reduced space between "Posts" and "Completed"

                            // Column for "Completed"
                            Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Center the content vertically in the column
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // Align content to the center horizontally
                              children: [
                                Text(
                                  '$completedPosts', // The count (number) at the top
                                  style: const TextStyle(
                                    fontSize:
                                        24, // Larger font size for the count
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Completed', // Label below the count
                                  style: TextStyle(
                                    fontSize:
                                        12, // Smaller font size for the label
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // User Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData['userFullName'],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('DOB: ${userData['userDOB']}'),
                  const SizedBox(height: 8),
                  Text('Gender: ${userData['userGender']}'),
                  const SizedBox(height: 16),
                  Text(userData['userBio'],
                      style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
            // Social Links
            // Social Links Row
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center align the row
              children: [
                // Instagram Icon
                if (userData['instagram']?.isNotEmpty ?? false)
                  IconButton(
                    onPressed: () {
                      final instagramLink = userData['instagram'];
                      launchUrl(Uri.parse(instagramLink));
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.instagram,
                      color: Colors.purple,
                      size: 15, // Adjust size as needed
                    ),
                    tooltip: 'Instagram',
                  ),
                if (userData['instagram']?.isNotEmpty ?? false)
                  const SizedBox(width: 6),

                // Twitter (X) Icon
                if (userData['twitter']?.isNotEmpty ?? false)
                  IconButton(
                    onPressed: () {
                      final twitterLink = userData['twitter'];
                      launchUrl(Uri.parse(twitterLink));
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.x, // Icon for Twitter (X)
                      color: Color.fromARGB(255, 0, 0, 0),
                      size: 15, // Adjust size as needed
                    ),
                    tooltip: 'Twitter',
                  ),
                if (userData['twitter']?.isNotEmpty ?? false)
                  const SizedBox(width: 6),

                // Gmail Icon
                if (userData['gmail']?.isNotEmpty ?? false)
                  IconButton(
                    onPressed: () {
                      final gmailLink = userData['gmail'];
                      launchUrl(Uri(
                        scheme: 'mailto',
                        path: gmailLink,
                      ));
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.envelope,
                      color: Colors.red,
                      size: 15, // Adjust size as needed
                    ),
                    tooltip: 'Gmail',
                  ),
                if (userData['gmail']?.isNotEmpty ?? false)
                  const SizedBox(width: 6),

                // Facebook Icon
                if (userData['facebook']?.isNotEmpty ?? false)
                  IconButton(
                    onPressed: () {
                      final facebookLink = userData['facebook'];
                      launchUrl(Uri.parse(facebookLink));
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.facebook,
                      color: Colors.blue,
                      size: 15, // Adjust size as needed
                    ),
                    tooltip: 'Facebook',
                  ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Create a container to wrap the buttons and set its width to 95% of the device width
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.95, // 95% of the device width
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Edit Profile button
                        Container(
                          width: MediaQuery.of(context).size.width *
                              0.45, // 45% of the width for each button
                          child: ElevatedButton(
                            onPressed: _navigateToEditProfile,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  Colors.white, // Set background color to white
                              side: BorderSide(
                                color: Colors.black,
                                width: 0.3, // Decreased the border width to 1
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5), // Decreased border radius
                              ),
                            ),
                            child: const Text("Edit Profile"),
                          ),
                        ),
                        const SizedBox(
                            width: 5), // Add spacing between the buttons
                        // Settings button
                        Container(
                          width: MediaQuery.of(context).size.width *
                              0.45, // 45% of the width for each button
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to the settings page when the button is pressed
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingsPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  Colors.white, // Set background color to white
                              side: BorderSide(
                                color: Colors.black,
                                width: 0.3, // Decreased the border width to 1
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5), // Decreased border radius
                              ),
                            ),
                            child: const Text("Settings"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Post button with underline effect
                  Column(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            showPosts = true;
                          });
                        },
                        icon: const Icon(
                          Icons.grid_on,
                          color: Colors
                              .black, // Set the color of the icon to black
                        ),
                        label: const Text(
                          'Posts',
                          style: TextStyle(
                              color: Colors
                                  .black), // Set the color of the text to black
                        ),
                      ),

                      // Underline when Posts is selected
                      if (showPosts)
                        Container(
                          height: 2,
                          width: 50,
                          color: Colors.blue,
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Trip button with underline effect
                  Column(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            showPosts = false;
                          });
                        },
                        icon: const Icon(
                          Icons.photo_album,
                          color: Colors
                              .black, // Set the color of the icon to black
                        ),
                        label: const Text(
                          'Trip Images',
                          style: TextStyle(
                              color: Colors
                                  .black), // Set the color of the text to black
                        ),
                      ),

                      // Underline when Trip Images is selected
                      if (!showPosts)
                        Container(
                          height: 2,
                          width: 50,
                          color: Colors.black,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Display Posts or Trip Images
            if (showPosts)
              Column(
                children: [
                  // Show Posts Section
                  if (userPosts.isEmpty)
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          // Larger emoji 🚫
                          Text(
                            '🚫',
                            style: TextStyle(
                              fontSize: 50, // Increase the size of the emoji
                            ),
                          ),
                          // Text below the emoji
                          Text(
                            'No posts available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4, // Reduced horizontal gap
                        mainAxisSpacing: 4, // Reduced vertical gap
                        childAspectRatio:
                            0.80, // You can further adjust this if needed
                      ),
                      itemCount: userPosts.length,
                      itemBuilder: (context, index) {
                        final post = userPosts[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostDetailScreen(
                                  postId: post['postId'],
                                  username: userData['userName'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: (post['tripCompleted'] ?? false)
                                  ? Colors.green[100]
                                  : Colors.white,
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color.fromARGB(255, 138, 222, 255)
                                          .withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image at the top
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        post['locationImages'][0],
                                        fit: BoxFit.cover,
                                        height: 100,
                                        width: double.infinity,
                                      ),
                                      // Three-dot menu in top right corner
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                                0.2), // Semi-transparent background
                                            borderRadius: BorderRadius.circular(
                                                20), // Rounded corners for the container
                                          ),
                                          child: PopupMenuButton<String>(
                                            icon: const Icon(
                                              Icons.more_vert,
                                              color: Colors
                                                  .black, // Icon color set to black for contrast
                                            ),
                                            onSelected: (value) {
                                              if (value == 'delete') {
                                                deletePost(post['postId'],
                                                    userData['userName']);
                                              } else if (value == 'complete') {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PostCompleteScreen(
                                                      postId: post['postId'],
                                                      username:
                                                          userData['userName'],
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  6), // Rounded corners for the menu
                                            ),
                                            color: Colors.grey[
                                                800], // Dark background for the menu
                                            elevation:
                                                6, // Slight shadow effect for the menu
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical:
                                                    10), // Padding for menu items
                                            itemBuilder:
                                                (BuildContext context) => [
                                              const PopupMenuItem<String>(
                                                value: 'delete',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.delete,
                                                      color: Colors
                                                          .red, // Red color for delete option
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            8), // Space between the icon and text
                                                    Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                        color: Colors
                                                            .white, // White text for better contrast
                                                        fontWeight: FontWeight
                                                            .bold, // Bold text for emphasis
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (post['tripCompleted'] ==
                                                  false)
                                                const PopupMenuItem<String>(
                                                  value: 'complete',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.check_circle,
                                                        color: Colors
                                                            .green, // Green color for the complete option
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        'Complete',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(
                                          post['tripLocation'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      // if (post['tripCompleted'] ?? false)
                                      //   RatingBar.builder(
                                      //       initialRating:
                                      //         post['tripRating'] ?? 0,
                                      // minRating: 0,
                                      //     itemSize: 10,
                                      //     direction: Axis.horizontal,
                                      //     allowHalfRating: true,
                                      //      itemCount: 5,
                                      //     itemBuilder: (context, _) =>
                                      //          const Icon(Icons.star,
                                      //               color: Colors.yellow),
                                      //     onRatingUpdate: (rating) {
                                      //         print(rating);
                                      //      },
                                      //     ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              )
            else
              // Show Trip Images Section
              Column(
                children: [
                  if (tripPhotos.isEmpty)
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            '🚫',
                            style: TextStyle(
                              fontSize: 50, // Increase the size of the emoji
                            ),
                          ),
                          Text(
                            'No trip images available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Three images per row
                        crossAxisSpacing: 8, // Horizontal space between items
                        mainAxisSpacing: 8, // Vertical space between items
                      ),
                      itemCount: tripPhotos.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Show the image in a dialog when clicked
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Image.asset(
                                          tripPhotos[index],
                                          fit: BoxFit
                                              .contain, // Ensures full image fits without cropping
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Stack(
                            children: [
                              // Here we set BoxFit.cover to zoom the image to fill the grid cell
                              Image.asset(
                                tripPhotos[index],
                                fit: BoxFit
                                    .cover, // Ensures image fills the grid space, zooming if needed
                                width: double
                                    .infinity, // Makes image stretch to fit the container width
                                height: double
                                    .infinity, // Makes image stretch to fit the container height
                              ),
                              // Three-dot menu for delete option
                              Positioned(
                                top: 5,
                                right: 5,
                                child: PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert,
                                      color: Colors
                                          .white), // Icon color set to white
                                  onSelected: (value) {
                                    if (value == 'delete') {
                                      // Call function to delete the trip photo from the UI and DB
                                      deleteTripPhoto(tripPhotos[index],
                                          userData['userName'], index);
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Rounded corners for the menu
                                  ),
                                  color: Colors.grey[
                                      800], // Background color for the menu
                                  elevation: 8, // Shadow for a raised effect
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8), // Padding for items
                                  itemBuilder: (BuildContext context) => [
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete,
                                              color: Colors
                                                  .red), // Icon with red color for delete action
                                          SizedBox(
                                              width:
                                                  8), // Space between icon and text
                                          Text(
                                            'Delete',
                                            style: TextStyle(
                                              color: Colors
                                                  .white, // Text color set to white
                                              fontWeight:
                                                  FontWeight.bold, // Bold text
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(const MaterialApp(
      home: ProfilePage(),
    ));
