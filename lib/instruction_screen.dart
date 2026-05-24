import 'package:flutter/material.dart';
import 'onboarding_videos_screen.dart';

class InstructionScreen extends StatefulWidget {
  const InstructionScreen({super.key});

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, dynamic>> steps = [
    {
      "title": "Welcome to Browse Wildlife",
      "description":
          "The Browse Wildlife App helps caretakers, gatherers and landholders work together to provide safe browse for wildlife. Before using the app, read these instructions so you understand your role and how to use the app responsibly.",
      "image": "assets/images/welcome.jpg",
      "points": [
        "Caretakers can create browse requests for animals in care.",
        "Gatherers can accept available requests and collect browse safely.",
        "Landholders can list suitable plants available on their property.",
        "All users should follow safety, privacy and property access rules.",
      ],
    },
    {
      "title": "For Caretakers: Create a Browse Request",
      "description":
          "Caretakers use the order form to request browse for the animals they are caring for. The request should include clear details so gatherers know exactly what is needed.",
      "image": "assets/images/upload.jpg",
      "points": [
        "Select the animal that needs browse.",
        "Choose the browse type, amount and quantity type.",
        "Add extra request details if there are special instructions.",
        "Submit the request so gatherers can view it on the request board.",
        "You can edit or delete your own order if the details change.",
      ],
    },
    {
      "title": "For Gatherers: Accept and Collect Safely",
      "description":
          "Gatherers help by accepting browse requests and collecting suitable plant material. Only accept a request if you can complete it safely and responsibly.",
      "image": "assets/images/collect.jpg",
      "points": [
        "Check the request board and choose a request you can complete.",
        "Review the animal, browse type, quantity and postcode before accepting.",
        "After accepting, follow the provided collection and access information.",
        "Only collect from approved private property with permission.",
        "Do not collect from public land, Crown land or restricted areas.",
      ],
    },
    {
      "title": "For Landholders: List Available Browse",
      "description":
          "Landholders can list browse plants available on their property so gatherers know where suitable plants may be collected.",
      "image": "assets/images/search.jpg",
      "points": [
        "Select the browse plants available on your property.",
        "Add your address, postcode and contact information carefully.",
        "Choose the days and times gatherers can access the property.",
        "Add warnings, restrictions or access instructions if needed.",
        "Only list plants from property you are authorised to manage.",
      ],
    },
    {
      "title": "Safety and PPE Before Collecting",
      "description":
          "Safety is important when collecting browse. Always prepare before entering a property or handling plant material.",
      "image": "assets/images/collect.jpg",
      "points": [
        "Wear suitable PPE such as gloves, enclosed shoes and sun protection.",
        "Check the area for hazards such as uneven ground, insects or sharp branches.",
        "Use clean tools and disinfect them before and after collection.",
        "Do not over-harvest. Take only what is needed so plants can regrow.",
        "Stop collecting if the area feels unsafe or access is unclear.",
      ],
    },
    {
      "title": "Photos and Plant Identification",
      "description":
          "Clear photos help users understand the browse being requested or offered. Good photos also support plant identification and safer collection.",
      "image": "assets/images/search.jpg",
      "points": [
        "Take photos in good lighting where the leaves are easy to see.",
        "Capture close-up photos of leaves, flowers, bark or branches if available.",
        "Avoid blurry photos or photos taken too far away.",
        "Check plant information carefully before collecting or feeding browse.",
        "If unsure about a plant, ask for help before using it for animals.",
      ],
    },
    {
      "title": "Ready for Training Videos",
      "description":
          "You have now read the key instructions. The next screen contains training videos that show safety preparation, photography guidance and browse collection examples.",
      "image": "assets/images/welcome.jpg",
      "points": [
        "Watch the PPE video before collecting browse.",
        "Watch the photography video to learn how to take useful plant photos.",
        "Review plant-specific videos before collecting unfamiliar browse.",
        "You can return to these instructions later if needed.",
      ],
    },
  ];

 void goToVideoScreen() {
  final args =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => OnboardingVideosScreen(
        user: args!,
      ),
    ),
  );
}

  void nextPage() {
    if (currentIndex < steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      goToVideoScreen();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      appBar: AppBar(
        title: const Text("How to Use the App"),
        backgroundColor: const Color.fromRGBO(46, 165, 107, 1),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: goToVideoScreen,
            child: const Text(
              "Skip",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: steps.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final step = steps[index];
                final List<String> points =
                    List<String>.from(step["points"] as List);

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          step["image"]!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(232, 246, 238, 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.eco,
                                size: 70,
                                color: Color.fromRGBO(46, 165, 107, 1),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        step["title"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        step["description"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        elevation: 2,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: points.map((point) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Color.fromRGBO(46, 165, 107, 1),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        point,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              steps.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentIndex == index ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? const Color.fromRGBO(46, 165, 107, 1)
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(46, 165, 107, 1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: nextPage,
                child: Text(
                  currentIndex == steps.length - 1
                      ? "Continue to Videos"
                      : "Next",
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
