import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionGrantPage extends StatelessWidget {
  final VoidCallback onPermissionGranted;

  const PermissionGrantPage({super.key, required this.onPermissionGranted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("给予权限")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "作为一个播放器，需要访问文件哦~",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await Permission.manageExternalStorage.request();
                onPermissionGranted();
              },
              child: const Text("获取文件访问权限"),
            ),
          ],
        ),
      ),
    );
  }
}
