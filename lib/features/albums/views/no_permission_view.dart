import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NoPermissionView extends StatelessWidget {
  final void Function(bool) onPermissionChanged;

  const NoPermissionView(this.onPermissionChanged, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: _buildPage(
          context,
          icon: Icons.celebration,
          title: "Your Journey Starts Here",
          description: "We need access to your folders to load your mp3 files",
          button: ElevatedButton(
            onPressed: () {
              Permission.manageExternalStorage.request().then((value) {
                onPermissionChanged(value.isGranted);
              });
            },
            child: Text("Grant Permission to Access Folders"),
          ),
        )),
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
