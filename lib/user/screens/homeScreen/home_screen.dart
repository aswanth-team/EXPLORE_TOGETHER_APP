import 'dart:math';

import 'home_posts_screen.dart';
import 'package:flutter/material.dart';
import '../../../data/users.dart';
import '../uploadScreen/upload_trip_and_images_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Map<String, dynamic>> posts;

  late List<String> allSuggestions;
  late List<Map<String, dynamic>> searchResults;
  String selectedGender = 'All';
  String selectedCompletionStatus = 'All';
  String tripDuration = '';
  bool filterApplied = false;

  List<Map<String, dynamic>> _generatePostFeed(
      List<Map<String, dynamic>> users) {
    List<Map<String, dynamic>> allPosts = [];

    for (var user in users) {
      for (var post in user["userPosts"]) {
        allPosts.add({
          "postId": post["postId"],
          "images": (post["locationImages"] as List<dynamic>?)
                  ?.where((element) => element != null)
                  .map((e) => e.toString())
                  .toList() ??
              [],

          "location": post["tripLocation"],
          "locationDescription": post["tripLocationDescription"],
          "buddyLoaction": post['userLocation'],
          "tripDuration": post["tripDuration"],
          "userImage": user["userImage"],
          "userName": user["userName"],
          "userVisitingPlaces": (post["planToVisitPlaces"] as List<dynamic>?)
                  ?.where((element) => element != null)
                  .map((e) => e.toString())
                  .toList() ??
              [],
          // Use post instead of user
          "userVisitedPlaces": (post["visitedPlaces"] as List<dynamic>?)
                  ?.where((element) => element != null)
                  .map((e) => e.toString())
                  .toList() ??
              [],

          "userGender": user["userGender"],
          "tripCompleted": post["tripCompleted"],
        });

        print(
            "User: ${user['userName']}, Visiting Places: ${post['planToVisitPlaces']}");
      }
    }

    allPosts.shuffle();
    return _interleavePostsByUser(allPosts);
  }

  List<Map<String, dynamic>> _interleavePostsByUser(
      List<Map<String, dynamic>> posts) {
    Map<String, List<Map<String, dynamic>>> userPosts = {};

    for (var post in posts) {
      userPosts.putIfAbsent(post['userName'], () => []).add(post);
    }

    List<Map<String, dynamic>> result = [];
    while (userPosts.isNotEmpty) {
      for (var user in userPosts.keys.toList()) {
        if (userPosts[user]!.isNotEmpty) {
          result.add(userPosts[user]!.removeAt(0));
        }
        if (userPosts[user]!.isEmpty) {
          userPosts.remove(user);
        }
      }
    }
    return result;
  }

  String filterLocation = '';
  List<Map<String, dynamic>> filteredPosts = [];

  // Helper function for Levenshtein Distance
  int levenshteinDistance(String s1, String s2) {
    List<List<int>> dp =
        List.generate(s1.length + 1, (_) => List<int>.filled(s2.length + 1, 0));

    for (int i = 0; i <= s1.length; i++) {
      for (int j = 0; j <= s2.length; j++) {
        if (i == 0) {
          dp[i][j] = j;
        } else if (j == 0) {
          dp[i][j] = i;
        } else if (s1[i - 1] == s2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] =
              1 + [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]].reduce(min);
        }
      }
    }
    return dp[s1.length][s2.length];
  }

  // Function to calculate string similarity based on Levenshtein distance
  double calculateStringSimilarity(String a, String b) {
    int maxLength = max(a.length, b.length);
    if (maxLength == 0) return 1.0;

    int distance = levenshteinDistance(a, b);
    return 1.0 - (distance / maxLength);
  }

  // Function to check if two strings are similar (with a customizable threshold)
  bool isSimilar(String query, String target, {double threshold = 0.7}) {
    return calculateStringSimilarity(
            query.toLowerCase(), target.toLowerCase()) >=
        threshold;
  }

  // Create a TextEditingController for the search bar
  TextEditingController _searchController = TextEditingController();
  TextEditingController tripDurationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    posts = _generatePostFeed(users);
    searchResults = posts;
    filteredPosts = searchResults;

    // Combine all post locations and visiting places into a unique list
    allSuggestions = posts
        .expand((post) {
          String? location = post['location'];
          List<dynamic>? visitingPlaces = post['userVisitingPlaces'];

          // Create a list containing location and visiting places
          List<String> suggestions = [];
          if (location != null && location.isNotEmpty) {
            suggestions.add(location); // Add location if it's not null
          }
          if (visitingPlaces != null) {
            suggestions.addAll(
                visitingPlaces.map((place) => place.toString()).toList());
          }
          return suggestions;
        })
        .toSet()
        .toList(); // Remove duplicates and convert to a list
  }

  // Function to apply filters after search
  void applyFilters() {
    setState(() {
      filterApplied = true;
      filteredPosts = searchResults.where((post) {
        // Gender filter
        if (selectedGender != 'All' &&
            post['userGender']?.toLowerCase() != selectedGender.toLowerCase()) {
          return false;
        }

        // Trip duration filter
        if (tripDuration.isNotEmpty) {
          int duration = int.tryParse(tripDuration) ?? 0;
          if (post['tripDuration'] != duration) return false;
        }

        if (selectedCompletionStatus != 'All') {
          bool isCompleted = post['tripCompleted'] ?? false;
          if (selectedCompletionStatus == 'Completed' && !isCompleted) {
            return false;
          }
          if (selectedCompletionStatus == 'Incomplete' && isCompleted) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }

  void resetFilters() {
    setState(() {
      selectedGender = 'All';
      selectedCompletionStatus = 'All';
      tripDuration = '';
      tripDurationController.clear();
      filterApplied = false;
      filteredPosts = posts;
    });
  }

  void onSearchChanged(String query) {
    setState(() {
      // Filter posts based on the search query
      searchResults = posts.where((post) {
        bool locationMatches = isSimilar(query, post['location'] ?? '');
        bool visitingPlacesMatch = (post['userVisitingPlaces'] ?? [])
            .any((place) => isSimilar(query, place.toString()));
        return locationMatches || visitingPlacesMatch;
      }).toList();

      // Apply the filter to the updated search results
      if (filterApplied) {
        applyFilters();
      } else {
        filteredPosts = searchResults; // Update visible posts
      }
    });
  }

  // Pull-to-refresh callback method
  Future<void> _refreshPosts() async {
    setState(() {
      selectedGender = 'All';
      selectedCompletionStatus = 'All';
      tripDuration = '';
      tripDurationController.clear();
      // Reload the posts data (or fetch fresh data if from an API)
      posts = _generatePostFeed(users); // Refresh posts
      searchResults = posts;
      filteredPosts = posts;
    });
  }

  void showFilterPopup() {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Options'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Completion Status Dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Completion Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButton<String>(
                          value: selectedCompletionStatus,
                          hint: Text('Select Status'),
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCompletionStatus = newValue!;
                            });
                          },
                          items: <String>['All', 'Incomplete', 'Completed']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    // Gender Dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gender',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButton<String>(
                          value: selectedGender,
                          hint: Text('Select Gender'),
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedGender = newValue!;
                            });
                          },
                          items: <String>['All', 'Male', 'Female', 'Other']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Trip Duration Text Field
                    TextFormField(
                      controller: tripDurationController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Trip Duration (days)',
                      ),
                      onChanged: (value) {
                        setState(() {
                          tripDuration = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),

                    // Buttons for Apply and Reset
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            applyFilters();
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Apply'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            resetFilters();
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Reset'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Map<String, dynamic> userData = {
    "userImage": "assets/profile/aswanth.webp",
    "userName": "aswanth123",
    "userMobileNumber": 85423343242,
    "userFullName": "Aswanth K",
    "userBio":
        "Lover of nature and travel. Always exploring new places and capturing memories. I believe in living life to the fullest. Come join my journey!",
    "userGender": "Male",
    "userDOB": "January 1, 1995",
    "userLocation": ["kerala", "kannur"],
    "userPosts": [
      {
        "postId": "post1",
        "tripLocation": "Ooty",
        "tripLocationDescription":
            "Ooty is a resort town in the Western Ghats mountains, in southern India's Tamil Nadu state.",
        "locationImages": [
          "assets/locimage/oo.jfif",
          "assets/locimage/ooty.webp",
          "assets/locimage/ootya.jpg",
        ],
        "tripCompleted": true,
        "tripDuration": 5,
        "tripRating": 4.5,
        "tripBuddies": [
          'sagar123',
          'ajmal12',
          'vyshnav221',
        ],
        "tripFeedback": "Nice Better Experience For Me",
        "planToVisitPlaces": [
          'Toy Train',
          'Ooty Lake',
          ' Ooty Botanical Gardens',
          'Ooty Rose Gardens',
          'Thread Garden',
          'Doddabetta Peak',
          'Dolphins Nose'
        ],
        "visitedPlaces": [
          'Toy Trainr',
          'Doddabetta Peak',
          'Ooty Botanical Gardens',
        ],
      },
      {
        "postId": "post2",
        "tripLocation": "Mount Fuji",
        "tripLocationDescription":
            "Japan’s Mt. Fuji is an active volcano about 100 kilometers southwest of Tokyo",
        "tripDuration": 3,
        "locationImages": [
          "assets/locimage/mountfuji1.webp",
          "assets/locimage/mountfuji2.jpg",
          "assets/locimage/mountfuji3.jfif",
        ],
        "tripCompleted": false,
        "tripRating": null,
        "tripBuddies": null,
        "tripFeedback": null,
        "planToVisitPlaces": [
          'Subashiri 5th Station',
          'Fujinomiya 5th Station',
          'Snow Town Yeti',
          'Lake Kawaguchiko'
        ],
        "visitedPlaces": null,
      }
    ],
    "tripPhotos": [
      'assets/profile/aswanth.webp',
      "assets/locimage/mountfuji22.jfif",
      "assets/locimage/mountfuji33.jpg",
      "assets/locimage/mountfuji44.jfif",
    ],
    "userSocialLinks": {
      "instagram": "https://www.instagram.com/a.swnth_",
      "facebook": "https://www.facebook.com/aswanth.kumar",
      "gmail": "aswanth.kumar@gmail.com",
      "twitter": "https://x.com/__x"
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  height: 40,
                  child: Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty();
                      }
                      return allSuggestions.where((suggestion) => suggestion
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()));
                    },
                    onSelected: (String selection) {
                      // Update the search results based on the selected suggestion
                      _searchController.text = selection;
                      onSearchChanged(selection);
                    },
                    optionsViewBuilder: (BuildContext context,
                        AutocompleteOnSelected<String> onSelected,
                        Iterable<String> options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          child: Container(
                            width: MediaQuery.of(context).size.width -
                                50, // Adjust width
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final option = options.elementAt(index);
                                return ListTile(
                                  title: Text(option),
                                  trailing: Icon(Icons.search,
                                      color: Colors.grey), // Add icon
                                  onTap: () {
                                    onSelected(option);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      _searchController = textEditingController;
                      return TextField(
                        controller: _searchController,
                        focusNode: focusNode,
                        onChanged: onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Search by location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0,
                            horizontal: 10.0,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                filterLocation = '';
                                _searchController.clear();
                                selectedGender = 'All';
                                selectedCompletionStatus = 'All';
                                tripDuration = '';
                                tripDurationController.clear();
                                filterApplied = false;
                                filteredPosts = posts;
                              });
                            },
                          ),
                          prefixIcon: Icon(Icons.search),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            //IconButton(
            //    icon: Icon(
            //        Icons.add_circle,
            //      size: 30,
            //      color: Colors.blueAccent,
            //    ),
            //   onPressed: () {
            //     print("Add button pressed");
            //    },
            //  ),
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: showFilterPopup,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPosts, // Refresh callback
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredPosts.length,
                    itemBuilder: (context, index) {
                      final post = filteredPosts[index];
                      return UsersPosts(
                        index: index,
                        postId: post['postId'], // Pass postId here
                        images: post['images'],
                        location: post['location'],
                        locationDescription: post['locationDescription'],
                        tripDuration: post['tripDuration'].toString(),
                        userImage: post['userImage'],
                        userName: post['userName'],
                        userGender: post['userGender'],
                        tripCompleted: post['tripCompleted'],
                        userVisitingPlaces: post['userVisitingPlaces'],
                        userVistedPlaces: post['userVisitedPlaces'],
                      );
                    },
                  ),
                ),
              ],
            ),
            /*     Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text("Post"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PostUploadScreen(username: "aswanth123"),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            title: Text("Image"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ImageUploadScreen(username: "aswanth123"),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.blueAccent,
                mini: true,
                shape: CircleBorder(),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
