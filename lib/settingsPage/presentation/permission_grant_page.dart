import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionGrantPage extends StatelessWidget {
  final VoidCallback onPermissionGranted;

  const PermissionGrantPage({super.key, required this.onPermissionGranted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("grant permission")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "as a media player, we might need to access your files. \nThis is offline, we don't collect data",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await Permission.manageExternalStorage.request();
                onPermissionGranted();
              },
              child: const Text("grant permission"),
            ),
          ],
        ),
      ),
    );
  }
}
