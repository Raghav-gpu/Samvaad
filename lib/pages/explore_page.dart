import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:bot/services/gemini_service.dart';
import 'package:bot/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with TickerProviderStateMixin {
  late MapController _mapController;
  LatLng _currentLocation = LatLng(28.7041, 77.1025);
  final GeminiService _geminiService = GeminiService();
  late AnimationController _glowController;
  String _currentPlace = "Tap a category to explore";
  String _placeDescription = "";
  bool _isLoading = false;
  Set<String> _usedLocations = {};

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _glowController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _exploreLocation(String category) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final prompt = """
Suggest a famous $category location that is not commonly known. Use the current timestamp as a seed for randomness: ${DateTime.now().millisecondsSinceEpoch}.

Respond with a JSON object having the following keys:
* "place_name": The name of the location (string).
* "latitude": The latitude of the location (number).
* "longitude": The longitude of the location (number).
* "short_description": A brief description of the location (string, 1-2 lines maximum).

Ensure the coordinates are valid (latitude between -90 and 90, longitude between -180 and 180). If no suitable location is found, return a JSON object with a single key: "error" and a descriptive error message as the value. Do not include any other text outside the JSON object.
""";

      String response;
      int attempts = 0;
      do {
        response = await _geminiService
            .getGeminiResponse(prompt)
            .timeout(Duration(seconds: 15));
        attempts++;
        if (attempts > 10)
          throw Exception(
              "Couldn't find a unique location after multiple tries.");

        final cleanedResponse = response.replaceAll(RegExp(r'```json|```'), '');
        final Map<String, dynamic> data = jsonDecode(cleanedResponse);

        if (!data.containsKey('error') &&
            !_usedLocations.contains(data['place_name'])) {
          _usedLocations.add(data['place_name']);
          break; // Exit the loop if a unique location is found
        }
      } while (true);

      final Map<String, dynamic> data =
          jsonDecode(response.replaceAll(RegExp(r'```json|```'), ''));

      if (data.containsKey('error')) {
        throw Exception(data['error']);
      }

      final String placeName = data['place_name'];
      final double latitude = data['latitude'];
      final double longitude = data['longitude'];
      final String description = data['short_description'];

      setState(() {
        _currentLocation = LatLng(latitude, longitude);
        _currentPlace = placeName;
        _placeDescription = description;
      });

      // Smooth map transition
      _mapController.move(
        _currentLocation,
        _mapController.camera.zoom + 2,
      );
    } catch (e) {
      _showError("Couldn't find location: ${e.toString()}");
      print("Error: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
    setState(() {
      _currentPlace = "Error";
      _placeDescription = message;
    });
  }

  Widget _categoryButton(String category, IconData icon) {
    return GestureDetector(
      onTap: () => _exploreLocation(category),
      child: Container(
        width: 90,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.85),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.cyan, size: 28),
            SizedBox(height: 6),
            Text(
              category,
              textAlign: TextAlign.center,
              style: GoogleFonts.orbitron(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Explore with Samvaad",
            style: GoogleFonts.orbitron(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.background,
        elevation: 4,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentLocation,
                    initialZoom: 4,
                    interactionOptions: InteractionOptions(
                      flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _currentLocation,
                          child: ScaleTransition(
                            scale: Tween(begin: 0.8, end: 1.2).animate(
                              CurvedAnimation(
                                  parent: _glowController,
                                  curve: Curves.easeInOut),
                            ),
                            child: Icon(Icons.location_pin,
                                color: AppColors.accent, size: 40),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (_isLoading) Center(child: OrbLoader()),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _categoryButton("Historical", Icons.landscape),
                _categoryButton("Nature", Icons.park),
                _categoryButton("Urban", Icons.location_city),
                _categoryButton("Mysterious", Icons.visibility_off),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Text(_currentPlace,
                    style: GoogleFonts.orbitron(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Center(
                  child: Text(_placeDescription,
                      style: GoogleFonts.orbitron(
                          fontSize: 14, color: Colors.grey)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Glowing Orb Loader
class OrbLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(); // Replace this with a glowing effect
  }
}
