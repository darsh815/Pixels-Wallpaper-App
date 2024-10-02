import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';
import 'package:image_picker/image_picker.dart';

class WallpaperHomePage extends StatefulWidget {
  @override
  _WallpaperHomePageState createState() => _WallpaperHomePageState();
}

class _WallpaperHomePageState extends State<WallpaperHomePage> {
  List<String> wallpapers = [];
  bool isLoading = true;
  File? _selectedImage; // Holds the image selected from the gallery

  // Sample categories
  List<String> categories = [
    'Nature',
    'Technology',
    'Animals',
    'Architecture',
    'People',
    'Abstract',
    'Art',
    'Food',
    'Sports'
  ];
  String selectedCategory = 'Nature'; // Default category

  @override
  void initState() {
    super.initState();
    fetchWallpapers(selectedCategory);
  }

  Future<void> fetchWallpapers(String category) async {
    final response = await http.get(
      Uri.parse(
          'https://api.unsplash.com/photos/random?count=30&client_id=a0gCuCC7ggEckgzSBh5lCbfMEw50--d4W8qq0O7L4ts&query=$category'),
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      setState(() {
        wallpapers = data.map<String>((item) => item['urls']['regular']).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load wallpapers');
    }
  }

  Future<void> setWallpaper(String url) async {
    var file = await http.get(Uri.parse(url));

    await WallpaperManagerFlutter().setwallpaperfromFile(
      File.fromRawPath(file.bodyBytes),
      WallpaperManagerFlutter.HOME_SCREEN,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Wallpaper set successfully!')),
    );
  }

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Method to set the picked image as wallpaper
  Future<void> _setImageAsWallpaper() async {
    if (_selectedImage != null) {
      try {
        await WallpaperManagerFlutter().setwallpaperfromFile(
          _selectedImage!,
          WallpaperManagerFlutter.HOME_SCREEN,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wallpaper set successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to set wallpaper')),
        );
      }
    }
  }

  // Method to show preview of the selected image
  void _showImagePreview(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Get the screen size using MediaQuery
        var screenSize = MediaQuery.of(context).size;

        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Container to limit the size of the image preview to fit the screen
              Container(
                width: screenSize.width * 0.9, // Set width to 90% of the screen width
                height: screenSize.height * 0.7, // Set height to 70% of the screen height
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setWallpaper(imageUrl);
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Set as Wallpaper'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog without setting wallpaper
                },
                child: Text('Cancel'),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallpaper App'),
      ),
      body: Column(
        children: [
          // Category Selector
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = categories[index];
                      isLoading = true;
                      fetchWallpapers(selectedCategory);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: selectedCategory == categories[index]
                          ? Colors.blue
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: selectedCategory == categories[index]
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Wallpaper Grid
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                childAspectRatio: 0.75,
              ),
              itemCount: wallpapers.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showImagePreview(wallpapers[index]), // Show preview on tap
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: wallpapers[index],
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Button to pick image from gallery
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image from Gallery'),
            ),
          ),
          // If image is selected, show a button to set it as wallpaper
          if (_selectedImage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _setImageAsWallpaper,
                child: Text('Set Selected Image as Wallpaper'),
              ),
            ),
        ],
      ),
    );
  }
}
