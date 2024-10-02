import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class WallpaperHomePage extends StatefulWidget {
  @override
  _WallpaperHomePageState createState() => _WallpaperHomePageState();
}

class _WallpaperHomePageState extends State<WallpaperHomePage> {
  List<String> wallpapers = [];
  bool isLoading = true;

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
    // You might need to adjust the API URL for category filtering.
    final response = await http.get(
      Uri.parse('https://api.unsplash.com/photos/random?count=30&client_id=a0gCuCC7ggEckgzSBh5lCbfMEw50--d4W8qq0O7L4ts&query=$category'),
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

    print('Wallpaper set successfully!');
    // Optionally show a snackbar or a dialog to inform the user that the wallpaper has been set.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Wallpaper set successfully!')),
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
                      isLoading = true; // Show loading indicator while fetching new wallpapers
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
                childAspectRatio: 0.75, // Adjust aspect ratio for better fitting
              ),
              itemCount: wallpapers.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => setWallpaper(wallpapers[index]),
                  child: Container(
                    height: 150, // Set the height of the image container
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2), // Add border around the image
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10), // Clip to match border radius
                      child: CachedNetworkImage(
                        imageUrl: wallpapers[index],
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
