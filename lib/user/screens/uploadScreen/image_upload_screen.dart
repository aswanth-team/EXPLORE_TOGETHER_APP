import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  final String username;

  ImageUploadScreen({required this.username});

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Upload")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image upload section
            ImageUploadSection(
              onImageSelected: (images) {
                setState(() {
                  selectedImage = images.isNotEmpty ? images.first : null;
                });
              },
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
                    if (selectedImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please select an image.")));
                    } else {
                      uploadImage();
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

  void uploadImage() {
    String imageName =
        'image${DateTime.now().millisecondsSinceEpoch}'; // Rename image logic
    print("Username: ${widget.username}");
    print("Image: $imageName");
    // Add your logic to upload the image here
  }
}

class ImageUploadSection extends StatelessWidget {
  final Function(List<File>) onImageSelected;

  ImageUploadSection({required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Implement image picker
        final pickedImages = await ImagePicker().pickMultiImage();
        if (pickedImages != null) {
          onImageSelected(pickedImages.map((e) => File(e.path)).toList());
        }
      },
      child: Container(
        height: 200,
        color: Colors.grey[200],
        child: Center(child: Icon(Icons.add_a_photo, size: 50)),
      ),
    );
  }
}
