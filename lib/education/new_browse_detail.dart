import 'package:flutter/material.dart';
import '../models/browseInformation.dart';

class BrowseDetailPage extends StatelessWidget {
  final Browse browse;

  const BrowseDetailPage({super.key, required this.browse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      appBar: AppBar(
        title: const Text(
          'Browse Information',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top image section
            SizedBox(
              width: double.infinity,
              height: 200,
              child: Image.asset(
                browse.topImageUrl,
                fit: BoxFit.cover,
              ),
            ),

            // Plant name and description
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    browse.commonName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    browse.latinName,
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    browse.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 21, 21, 21),
                    ),
                  ),
                ],
              ),
            ),

            // Feature sections
            _buildFeatureSection(context, 'Leaf Shape', browse.leafImageUrl, browse.leafShape),
            _buildFeatureSection(context, 'Plant Shape', browse.plantImageUrl, browse.plantShape),
            _buildFeatureSection(context, 'Bark Texture', browse.barkImageUrl, browse.barkTexture),
            _buildFeatureSection(context, 'Flowers', browse.flowersImageUrl, browse.flowers),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Helper to create each section (Leaf Shape, Bark Texture, etc.)
  Widget _buildFeatureSection(
    BuildContext context,
    String title,
    String imageUrl,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Added GestureDetector around image to enable tap-to-expand
              GestureDetector(
                onTap: () => _showExpandedImage(context, imageUrl), //  Opens fullscreen image
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Description text
              Expanded(
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Added function to display image fullscreen with dark overlay
  void _showExpandedImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true, // Tap outside to close the image
      barrierColor: Colors.black.withOpacity(0.9), // Dark background when image is open
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.pop(context), // Close when tapping outside image
          child: Center(
            child: Hero(
              tag: imageUrl,
              child: InteractiveViewer( //  Allows zooming and panning
                panEnabled: true,
                minScale: 1,
                maxScale: 4,
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
