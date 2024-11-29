import 'dart:io';

import 'package:flutter/material.dart';

import 'image_upload_screen.dart';


class PostUploadScreen extends StatefulWidget {
  final String username;

  PostUploadScreen({required this.username});

  @override
  _PostUploadScreenState createState() => _PostUploadScreenState();
}

class _PostUploadScreenState extends State<PostUploadScreen> {
  TextEditingController tripLocationController = TextEditingController();
  TextEditingController locationDetailsController = TextEditingController();
  TextEditingController visitingPlacesController = TextEditingController();
  List<String> selectedVisitingPlaces = [];
  List<File> selectedImages = [];

  int postId =
      1; // You should get this from your database or wherever posts are stored

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Post Upload")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image upload section
            ImageUploadSection(
              onImageSelected: (images) {
                setState(() {
                  selectedImages = images;
                });
              },
            ),
            // Trip location text field
            TextField(
              controller: tripLocationController,
              decoration: InputDecoration(labelText: "Trip Location"),
            ),
            // Location details text field
            TextField(
              controller: locationDetailsController,
              decoration: InputDecoration(labelText: "Location Details"),
            ),
            // Visiting places text field
            TextField(
              controller: visitingPlacesController,
              decoration: InputDecoration(labelText: "Visiting Places"),
              onChanged: (value) {
                if (value.contains(',') &&
                    !selectedVisitingPlaces.contains(value)) {
                  setState(() {
                    selectedVisitingPlaces.add(value.trim());
                    visitingPlacesController.clear();
                  });
                }
              },
            ),
            // Display visiting places as tags
            Wrap(
              children: selectedVisitingPlaces.map((place) {
                return Chip(
                  label: Text(place),
                  onDeleted: () {
                    setState(() {
                      selectedVisitingPlaces.remove(place);
                    });
                  },
                );
              }).toList(),
            ),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cancel action
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validate fields before uploading
                    if (tripLocationController.text.isEmpty ||
                        locationDetailsController.text.isEmpty ||
                        selectedImages.isEmpty ||
                        selectedVisitingPlaces.isEmpty) {
                      // Show validation error
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Please fill all fields and select images.")));
                    } else {
                      // Call upload function
                      uploadPost();
                    }
                  },
                  child: Text("Upload"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void uploadPost() {
    // Call your API or function to upload the post
    print("Username: ${widget.username}");
    print("Post ID: $postId");
    print("Trip Location: ${tripLocationController.text}");
    print("Location Details: ${locationDetailsController.text}");
    print("Visiting Places: $selectedVisitingPlaces");
    // For images, you can print or send them as needed.
  }
}
