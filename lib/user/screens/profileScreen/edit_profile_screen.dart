import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Function(Map<String, dynamic>) onSave;

  const EditProfile({
    Key? key,
    required this.userData,
    required this.onSave,
  }) : super(key: key);

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

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        userImage = result.files.single.path ?? userImage;
      });
    }
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
              // Profile Image with Edit Icon
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          userImage.isNotEmpty ? AssetImage(userImage) : null,
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
              // Full Name
              TextFormField(
                initialValue: userFullName,
                decoration: const InputDecoration(labelText: 'Full Name'),
                onChanged: (value) => userFullName = value,
              ),
              const SizedBox(height: 16),
              // DOB
              TextFormField(
                initialValue: userDOB,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onChanged: (value) => userDOB = value,
              ),
              const SizedBox(height: 16),
              // Gender
              TextFormField(
                initialValue: userGender,
                decoration: const InputDecoration(labelText: 'Gender'),
                onChanged: (value) => userGender = value,
              ),
              const SizedBox(height: 16),
              // Location
              TextFormField(
                initialValue: userLocation,
                decoration: const InputDecoration(labelText: 'Location'),
                onChanged: (value) => userLocation = value,
              ),
              const SizedBox(height: 16),
              // Bio
              TextFormField(
                initialValue: userBio,
                decoration: const InputDecoration(labelText: 'Bio'),
                maxLines: 3,
                onChanged: (value) => userBio = value,
              ),
              const SizedBox(height: 16),
              // Social Links
              TextFormField(
                initialValue: userSocialLinks['instagram'] ?? '',
                decoration: const InputDecoration(labelText: 'Instagram'),
                onChanged: (value) => userSocialLinks['instagram'] = value,
              ),
              TextFormField(
                initialValue: userSocialLinks['facebook'] ?? '',
                decoration: const InputDecoration(labelText: 'Facebook'),
                onChanged: (value) => userSocialLinks['facebook'] = value,
              ),
              TextFormField(
                initialValue: userSocialLinks['gmail'] ?? '',
                decoration: const InputDecoration(labelText: 'Gmail'),
                onChanged: (value) => userSocialLinks['gmail'] = value,
              ),
              TextFormField(
                initialValue: userSocialLinks['twitter'] ?? '',
                decoration: const InputDecoration(labelText: 'Twitter'),
                onChanged: (value) => userSocialLinks['twitter'] = value,
              ),
              const SizedBox(height: 20),
              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSave({
                      'userImage': userImage,
                      'userName': userName,
                      'userFullName': userFullName,
                      'userDOB': userDOB,
                      'userGender': userGender,
                      'userLocation': userLocation,
                      'userBio': userBio,
                      'userSocialLinks': userSocialLinks,
                    });
                  },
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
