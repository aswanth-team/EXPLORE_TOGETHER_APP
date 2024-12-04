import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path/path.dart'
    as path; // For handling file paths and extensions

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> userData;

  EditProfile({required this.userData});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late String userImage;
  late String userName;
  late String userFullName;
  late String userDOB;
  late String userGender;
  late String userLocation;
  late String userBio;
  late Map<String, String> userSocialLinks;

  bool hasChanges = false;

  @override
  void initState() {
    super.initState();
    userImage = widget.userData['userImage'] ?? '';
    userName = widget.userData['userName'] ?? '';
    userFullName = widget.userData['userFullName'] ?? '';
    userDOB = widget.userData['userDOB'] ?? '';
    userGender = widget.userData['userGender'] ?? '';
    userLocation = widget.userData['userLocation'] ?? '';
    userBio = widget.userData['userBio'] ?? '';
    userSocialLinks =
        Map<String, String>.from(widget.userData['userSocialLinks'] ?? {});
  }

  void setChanges() {
    setState(() {
      hasChanges = true;
    });
  }

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      String filePath = result.files.single.path ?? userImage;
      String extension = path.extension(filePath); // Get file extension
      String newImageName = '$userName$extension'; // Format as username.<type>

      setState(() {
        userImage = filePath; // Local file path
        setChanges();
      });

      // Simulate Firebase storage format preparation
      print('Prepared image for Firebase: $newImageName');
    }
  }

  Future<void> selectDOB(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        userDOB = "${selectedDate.toLocal()}".split(' ')[0]; // Format date
        setChanges();
      });
    }
  }

  void saveProfile() {
    // Prepare data for saving
    String extension = path.extension(userImage);
    String firebaseImageName = '$userName$extension';

    final updatedUserData = {
      'userImage': firebaseImageName, // Prepared for Firebase
      'userName': userName,
      'userFullName': userFullName,
      'userDOB': userDOB,
      'userGender': userGender,
      'userLocation': userLocation,
      'userBio': userBio,
      'userSocialLinks': userSocialLinks,
    };

    print(updatedUserData);

    Navigator.pop(context, updatedUserData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: userImage.startsWith('assets/')
                          ? AssetImage(userImage)
                          : FileImage(File(userImage)) as ImageProvider,
                      child: userImage.isEmpty
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: pickImage,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: userFullName,
                decoration: const InputDecoration(labelText: 'Full Name'),
                onChanged: (value) {
                  userFullName = value;
                  setChanges();
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                controller: TextEditingController(text: userDOB),
                onTap: () {
                  selectDOB(context); // Open date picker
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: userGender.isEmpty ? null : userGender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: const [
                  DropdownMenuItem(
                    value: 'Male',
                    child: Text('Male'),
                  ),
                  DropdownMenuItem(
                    value: 'Female',
                    child: Text('Female'),
                  ),
                  DropdownMenuItem(
                    value: 'Other',
                    child: Text('Other'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    userGender = value ?? '';
                    setChanges();
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: userLocation,
                decoration: const InputDecoration(labelText: 'Location'),
                onChanged: (value) {
                  userLocation = value;
                  setChanges();
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: userBio,
                decoration: const InputDecoration(labelText: 'Bio'),
                maxLines: 3,
                onChanged: (value) {
                  userBio = value;
                  setChanges();
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: userSocialLinks['instagram'] ?? '',
                decoration: const InputDecoration(labelText: 'Instagram'),
                onChanged: (value) {
                  userSocialLinks['instagram'] = value;
                  setChanges();
                },
              ),
              TextFormField(
                initialValue: userSocialLinks['facebook'] ?? '',
                decoration: const InputDecoration(labelText: 'Facebook'),
                onChanged: (value) {
                  userSocialLinks['facebook'] = value;
                  setChanges();
                },
              ),
              TextFormField(
                initialValue: userSocialLinks['gmail'] ?? '',
                decoration: const InputDecoration(labelText: 'Gmail'),
                onChanged: (value) {
                  userSocialLinks['gmail'] = value;
                  setChanges();
                },
              ),
              TextFormField(
                initialValue: userSocialLinks['twitter'] ?? '',
                decoration: const InputDecoration(labelText: 'Twitter'),
                onChanged: (value) {
                  userSocialLinks['twitter'] = value;
                  setChanges();
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: hasChanges ? saveProfile : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasChanges ? Colors.green : Colors.grey,
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
