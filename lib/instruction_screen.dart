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

  final List<Map<String, String>> steps = [
    {
      "title": "Welcome to Browse",
      "description":
          "This guide will help you understand how to use the Browse Wildlife App before watching the training videos.",
      "image": "assets/images/welcome.jpg",
    },
    {
      "title": "Find Browse Plants",
      "description":
          "Use the app to learn about suitable browse plants such as eucalyptus, wattle, native grasses and camellia.",
      "image": "assets/images/search.jpg",
    },
    {
      "title": "Collect Safely",
      "description":
          "Follow safe collection steps so plants are harvested carefully without causing damage.",
      "image": "assets/images/collect.jpg",
    },
    {
      "title": "Upload and Submit",
      "description":
          "Take clear photos, add the required details, and submit your browse information through the app.",
      "image": "assets/images/upload.jpg",
    },
  ];

  void goToVideoScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OnboardingVideosScreen(),
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
      appBar: AppBar(
        title: const Text("How to Use the App"),
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
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          steps[index]["image"]!,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        steps[index]["title"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        steps[index]["description"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
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
                  color: currentIndex == index ? Colors.green : Colors.grey,
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