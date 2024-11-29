import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _TripPageState();

  static void showPostTripPopup() {}

  static void showUploadImagePopup() {}
}

class _TripPageState extends State<UploadPage> {
  final List<File> locationImages = [];
  final List<String> visitingPlaces = [];
  File? tripImage;

  final TextEditingController locationNameController = TextEditingController();
  final TextEditingController locationDescriptionController =
      TextEditingController();
  final TextEditingController tripDurationController = TextEditingController();
  final TextEditingController visitingPlaceController = TextEditingController();

  void resetPostTripFields() {
    setState(() {
      locationImages.clear();
      locationNameController.clear();
      locationDescriptionController.clear();
      tripDurationController.clear();
      visitingPlaces.clear();
    });
  }

  void resetUploadImageField() {
    setState(() {
      tripImage = null;
    });
  }

  Future<String> getStoragePath(String subFolder) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$subFolder';
    final dir = Directory(path);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return path;
  }

  Future<void> pickLocationImages() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        locationImages.clear();
        locationImages.addAll(result.files
            .map((file) => File(file.path!))
            .take(3)
            .toList()); // Max 3 images
      });
    }
  }

  Future<void> pickTripImage() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        tripImage = File(result.files.first.path!);
      });
    }
  }

  void postUpload() async {
    if (locationImages.isEmpty ||
        locationNameController.text.isEmpty ||
        locationDescriptionController.text.isEmpty ||
        tripDurationController.text.isEmpty ||
        visitingPlaces.isEmpty) {
      showWarning('Please fill in all fields');
      return;
    }

    final locationImagesPath = await getStoragePath('locationImages');
    for (var i = 0; i < locationImages.length; i++) {
      locationImages[i].copySync('$locationImagesPath/image_$i.jpg');
    }

    print('Location Name: ${locationNameController.text}');
    print('Description: ${locationDescriptionController.text}');
    print('Duration: ${tripDurationController.text}');
    print('Visiting Places: $visitingPlaces');
    print('Location Images saved to $locationImagesPath');

    resetPostTripFields();
    Navigator.of(context).pop();
  }

  void uploadImage() async {
    if (tripImage == null) {
      showWarning('Please upload an image');
      return;
    }

    final tripImagesPath = await getStoragePath('tripImages');
    tripImage!.copySync('$tripImagesPath/trip_image.jpg');

    print('Image uploaded to $tripImagesPath');
    resetUploadImageField();
    Navigator.of(context).pop();
  }

  void showWarning(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void showPostTripPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Post Trip'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Upload Section
                    ElevatedButton(
                      onPressed: pickLocationImages,
                      child: const Text('Upload Location Images (Max 3)'),
                    ),
                    Wrap(
                      spacing: 5,
                      children: locationImages
                          .map((file) => Image.file(file, height: 50))
                          .toList(),
                    ),
                    TextField(
                      controller: locationNameController,
                      decoration:
                          const InputDecoration(labelText: 'Location Name'),
                    ),
                    TextField(
                      controller: locationDescriptionController,
                      decoration: const InputDecoration(
                          labelText: 'Location Description'),
                    ),
                    TextField(
                      controller: tripDurationController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Trip Duration'),
                    ),
                    TextField(
                      controller: visitingPlaceController,
                      decoration:
                          const InputDecoration(labelText: 'Visiting Places'),
                      onChanged: (value) {
                        if (value.contains(',')) {
                          final tag = value.replaceAll(',', '').trim();
                          if (tag.isNotEmpty && visitingPlaces.length < 10) {
                            setState(() {
                              visitingPlaces.add(tag);
                              visitingPlaceController.clear();
                            });
                          }
                        }
                      },
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty &&
                            visitingPlaces.length < 10) {
                          setState(() {
                            visitingPlaces.add(value.trim());
                            visitingPlaceController.clear();
                          });
                        }
                      },
                    ),
                    Wrap(
                      spacing: 5,
                      children: visitingPlaces
                          .map((tag) => Chip(
                                label: Text(tag),
                                deleteIcon: const Icon(Icons.close),
                                onDeleted: () {
                                  setState(() {
                                    visitingPlaces.remove(tag);
                                  });
                                },
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    resetPostTripFields();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: postUpload,
                  child: const Text('Upload'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showUploadImagePopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Upload Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: pickTripImage,
                child: const Text('Select Image'),
              ),
              if (tripImage != null) Image.file(tripImage!, height: 100),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                resetUploadImageField();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: uploadImage,
              child: const Text('Upload'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Post Trip') {
                showPostTripPopup();
              } else if (value == 'Upload Image') {
                showUploadImagePopup();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Post Trip', child: Text('Post Trip')),
              const PopupMenuItem(
                  value: 'Upload Image', child: Text('Upload Image')),
            ],
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: const Center(child: Text('Welcome to the Trip App!')),
    );
  }
}
