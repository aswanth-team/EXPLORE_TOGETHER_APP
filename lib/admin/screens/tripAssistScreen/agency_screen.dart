import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../../data/agencies.dart'; 

void main() {
  runApp(const MaterialApp(
    home: TravelAgencyPage(),
  ));
}

class TravelAgencyPage extends StatefulWidget {
  const TravelAgencyPage({super.key});

  @override
  _TravelAgencyPageState createState() => _TravelAgencyPageState();
}

class _TravelAgencyPageState extends State<TravelAgencyPage> {
  TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> filteredAgencies = [];
  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    filteredAgencies = agencies; // Initially, show all agencies
  }

  List<String> getCategories() {
    final categories = agencies.map((agency) => agency['category']).toSet();
    return ['All', ...categories]; // Add 'All' as the default option
  }

  void _filterAgencies(String query) {
    setState(() {
      filteredAgencies = agencies.where((agency) {
        final matchSearch =
            agency['agencyName']!.toLowerCase().contains(query.toLowerCase());
        final matchCategory =
            selectedCategory == "All" || agency['category'] == selectedCategory;
        return matchSearch && matchCategory;
      }).toList();
    });
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      filteredAgencies = agencies; // Reset to original agencies data
    });
  }

  void _updateAgency(Map<String, dynamic> updatedAgency) {
    print('Agency Updated: ${updatedAgency['agencyName']}');
    print('All Data: $updatedAgency');
  }

  void _removeAgency(int index) {
    setState(() {
      filteredAgencies.removeAt(index);
    });
    print('Agency Removed');
  }

  @override
  Widget build(BuildContext context) {
    final List<String> categories = getCategories();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip Providers"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) => _filterAgencies(query),
              decoration: InputDecoration(
                hintText: 'Search here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterAgencies(''); // Reset filter
                  },
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                final isSelected = category == selectedCategory;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                      _filterAgencies(_searchController.text);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: filteredAgencies.length,
                itemBuilder: (context, index) {
                  final agency = filteredAgencies[index];
                  return GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[100],
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            agency['agencyImage']!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  agency['agencyName']!,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () {
                                    final url = Uri.parse(agency['agencyWeb']!);
                                    if (url.scheme == 'http' ||
                                        url.scheme == 'https') {
                                      launchUrl(
                                        url,
                                        mode: LaunchMode.externalApplication,
                                      ).catchError((error) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Could not open ${url.toString()}'),
                                          ),
                                        );
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Invalid URL: ${url.toString()}'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'Details',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showEditPopup(context, agency, index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _removeAgency(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditPopup(
      BuildContext context, Map<String, dynamic> agency, int index) {
    TextEditingController nameController =
        TextEditingController(text: agency['agencyName']);
    TextEditingController webController =
        TextEditingController(text: agency['agencyWeb']);
    TextEditingController categoryController =
        TextEditingController(text: agency['category']);

    List<String> originalTags = List<String>.from(agency['agencyKeywords'] ?? []);
    List<String> tags = List<String>.from(originalTags);

    TextEditingController tagController = TextEditingController();
    String imageName = agency['agencyImage']!;

    final picker = ImagePicker();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Agency'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(imageName),
                          radius: 30,
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (pickedFile != null) {
                              setState(() {
                                imageName = pickedFile.path;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(labelText: 'Agency Name'),
                    ),
                    TextField(
                      controller: webController,
                      decoration: const InputDecoration(labelText: 'Agency Web'),
                    ),
                    TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: tags.map((tag) {
                        return Chip(
                          label: Text(tag),
                          deleteIcon: const Icon(Icons.cancel),
                          onDeleted: () {
                            setState(() {
                              tags.remove(tag);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    TextField(
                      controller: tagController,
                      decoration: const InputDecoration(
                          hintText: 'Add keyword (Press Enter or comma)'),
                      onSubmitted: (value) {
                        _addTag(value, tags, tagController, setState);
                      },
                      onChanged: (value) {
                        if (value.endsWith(',')) {
                          _addTag(value, tags, tagController, setState);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Map<String, dynamic> updatedAgency = {
                      'agencyName': nameController.text,
                      'agencyWeb': webController.text,
                                           'category': categoryController.text,
                      'agencyKeywords': tags,
                      'agencyImage': imageName, // Updated image path
                    };

                    _updateAgency(updatedAgency); // Call update function
                    setState(() {
                      filteredAgencies[index] = updatedAgency;
                    });

                    Navigator.pop(context); // Close dialog
                  },
                  child: const Text('Change'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addTag(String value, List<String> tags, TextEditingController controller,
      Function setState) {
    String tag = value.trim().replaceAll(',', '');
    if (tag.isNotEmpty && !tags.contains(tag)) {
      setState(() {
        tags.add(tag);
      });
    }
    controller.clear();
  }
}

