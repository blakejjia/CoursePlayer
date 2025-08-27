import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeView extends StatefulWidget {
  final void Function(bool) onPermissionChanged;
  const WelcomeView(this.onPermissionChanged, {super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {});
            },
            children: [
              _buildPage(
                context,
                icon: Icons.lightbulb,
                title: "Welcome to Courser!",
                description:
                    "Your new learning partner, designed to make mp3 learning seamless and enjoyable.",
              ),
              _buildPage(
                context,
                icon: Icons.headphones,
                title: "Designed for Learning",
                description:
                    "This app is designed for listening to courses. Enjoy features like playlist continuation, default playback speed, and more.",
              ),
              _buildPage(
                context,
                icon: Icons.block,
                title: "No Ads, No Interruptions",
                description:
                    "Focus on your learning without any distractions or advertisements.",
              ),
              _buildPage(
                context,
                icon: Icons.celebration,
                title: "Your Journey Starts Here",
                description:
                    "We need access to your folders to load your mp3 files",
                button: ElevatedButton(
                  onPressed: () {
                    Permission.manageExternalStorage.request().then((value) {
                      widget.onPermissionChanged(value.isGranted);
                    });
                  },
                  child: Text("Grant Permission to Access Folders"),
                ),
              )
            ],
          ),
        ),
        SmoothPageIndicator(
          controller: _pageController,
          count: 4,
          effect: WormEffect(
            dotHeight: 8.0,
            dotWidth: 8.0,
            activeDotColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPage(BuildContext context,
      {required IconData icon,
      required String title,
      required String description,
      Widget? button}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 80,
          color: Theme.of(context).colorScheme.primary,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withValues(alpha: 0.7),
                ),
            textAlign: TextAlign.center,
          ),
        ),
        if (button != null) button,
      ],
    );
  }
}
