import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionGrantPage extends StatelessWidget {
  final VoidCallback onPermissionGranted;

  const PermissionGrantPage({super.key, required this.onPermissionGranted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Permission Required")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "This app requires access to storage to function properly.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Permission.manageExternalStorage.request();
                onPermissionGranted();
              },
              child: const Text("Grant Permission"),
            ),
          ],
        ),
      ),
    );
  }
}
