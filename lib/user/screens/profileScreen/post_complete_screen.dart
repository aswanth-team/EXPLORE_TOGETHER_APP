import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PostCompleteScreen extends StatefulWidget {
  final String postId;
  final String username;

  const PostCompleteScreen(
      {required this.postId, required this.username, Key? key})
      : super(key: key);

  @override
  _PostCompleteScreenState createState() => _PostCompleteScreenState();
}

class _PostCompleteScreenState extends State<PostCompleteScreen> {
  final TextEditingController tripBuddiesController = TextEditingController();
  final TextEditingController visitedPlacesController = TextEditingController();
  final List<String> tripBuddies = [];
  final List<String> visitedPlaces = [];
  String? tripFeedback;
  double? tripRating;
  FocusNode tripBuddiesFocusNode = FocusNode();
  FocusNode visitedPlacesFocusNode = FocusNode();
  bool visitedPlacesDisabled =
      false; // Flag to disable the visited places input

  @override
  void dispose() {
    tripBuddiesController.dispose();
    visitedPlacesController.dispose();
    tripBuddiesFocusNode.dispose();
    visitedPlacesFocusNode.dispose();
    super.dispose();
  }

  // Adds a tag to the list of trip buddies or visited places
  void _addTag(
      String tag, TextEditingController controller, List<String> list) {
    if (tag.isNotEmpty && !list.contains(tag)) {
      setState(() {
        list.add(tag);
      });
      controller.clear(); // Clear the text field after adding the tag
    } else {
      controller.clear(); // Clear the text field if the tag is a duplicate
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Duplicate tag detected!")));
    }
  }

  // Validation check before submitting the form
  void _onComplete() {
    // Check if there’s any remaining text in the controllers and add them as tags
    if (tripBuddiesController.text.isNotEmpty) {
      _handleTagInput(
          tripBuddiesController.text, tripBuddiesController, tripBuddies);
    }
    if (visitedPlacesController.text.isNotEmpty) {
      _handleTagInput(
          visitedPlacesController.text, visitedPlacesController, visitedPlaces);
    }

    if (tripBuddies.isEmpty ||
        visitedPlaces.isEmpty ||
        tripFeedback == null ||
        tripRating == null) {
      // Show validation message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("All fields are required")));
    } else {
      // Call function to save data
      completeTripDetails();
    }
  }

  // Simulate completing the trip
  void completeTripDetails() {
    // Format the lists as requested
    String formattedTripBuddies = _formatListAsString(tripBuddies);
    String formattedVisitedPlaces = _formatListAsString(visitedPlaces);

    print("Trip completed!");
    print("Post ID: ${widget.postId}");
    print("Username: ${widget.username}");
    print("Trip Rating: $tripRating");
    print("Trip Buddies: $formattedTripBuddies");
    print("Visited Places: $formattedVisitedPlaces");
    print("Trip Feedback: $tripFeedback");

    // Navigate back to the previous screen
    Navigator.pop(context);
  }

  // Function to format a list as a string with single quotes around each element
  String _formatListAsString(List<String> list) {
    return "[${list.map((e) => "'$e'").join(', ')}]";
  }

  // Handles adding tags when the user presses Enter or enters a comma
  void _handleTagInput(
      String value, TextEditingController controller, List<String> list) {
    // Remove comma and add tag
    String tag = value.trim().replaceAll(',', '').replaceAll('\n', '').trim();
    if (tag.isNotEmpty) {
      _addTag(tag, controller, list);
    }
  }

  // Remove a tag from the list
  void _removeTag(String tag, List<String> list) {
    setState(() {
      list.remove(tag);
    });
  }

  // Check if the visited places limit is reached
  void _checkVisitedPlacesLimit() {
    if (visitedPlaces.length >= 8) {
      setState(() {
        visitedPlacesDisabled = true; // Disable input if 8 tags are added
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Complete Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Trip Buddies input field
            TextField(
              controller: tripBuddiesController,
              focusNode: tripBuddiesFocusNode,
              decoration: InputDecoration(
                labelText: 'Trip Buddies (comma separated)',
              ),
              onChanged: (value) {
                // Detecting if the value ends with comma or Enter key
                if (value.endsWith(",") || value.endsWith("\n")) {
                  _handleTagInput(value, tripBuddiesController, tripBuddies);
                }
              },
              onSubmitted: (value) {
                // Handle Enter key
                _handleTagInput(value, tripBuddiesController, tripBuddies);
                tripBuddiesFocusNode
                    .requestFocus(); // Keep focus on the input field
              },
            ),
            Wrap(
              children: tripBuddies
                  .map((tag) => Chip(
                        label: Text(tag),
                        deleteIcon: Icon(Icons.close, size: 18),
                        onDeleted: () => _removeTag(tag, tripBuddies),
                      ))
                  .toList(),
            ),

            // Visited Places input field
            TextField(
              controller: visitedPlacesController,
              focusNode: visitedPlacesFocusNode,
              decoration: InputDecoration(
                labelText: 'Visited Places (comma separated)',
              ),
              onChanged: (value) {
                if (!visitedPlacesDisabled) {
                  // Detecting if the value ends with comma or Enter key
                  if (value.endsWith(",") || value.endsWith("\n")) {
                    _handleTagInput(
                        value, visitedPlacesController, visitedPlaces);
                    _checkVisitedPlacesLimit(); // Check the limit after adding a tag
                  }
                }
              },
              onSubmitted: (value) {
                if (!visitedPlacesDisabled) {
                  _handleTagInput(
                      value, visitedPlacesController, visitedPlaces);
                  _checkVisitedPlacesLimit(); // Check the limit after adding a tag
                }
                visitedPlacesFocusNode
                    .requestFocus(); // Keep focus on the input field
              },
              enabled: !visitedPlacesDisabled, // Disable input after 8 tags
            ),
            Wrap(
              children: visitedPlaces
                  .map((tag) => Chip(
                        label: Text(tag),
                        deleteIcon: Icon(Icons.close, size: 18),
                        onDeleted: () {
                          _removeTag(tag, visitedPlaces);
                          _checkVisitedPlacesLimit(); // Recheck limit after removal
                        },
                      ))
                  .toList(),
            ),

            // Trip Feedback input field
            TextField(
              decoration: InputDecoration(
                labelText: 'Trip Feedback',
              ),
              onChanged: (value) => tripFeedback = value,
            ),

            // Rating bar for trip rating
            RatingBar.builder(
              initialRating: tripRating ?? 0,
              minRating: 1,
              itemSize: 30,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) =>
                  Icon(Icons.star, color: Colors.yellow),
              onRatingUpdate: (rating) => setState(() => tripRating = rating),
            ),
            Spacer(),

            // Complete button
            ElevatedButton(
              onPressed: _onComplete,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Complete'),
            ),
          ],
        ),
      ),
    );
  }
}
