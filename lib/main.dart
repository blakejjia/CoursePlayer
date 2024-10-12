import 'package:course_player/Views/my_app.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FileListPage(),
    );
  }
}

class FileListPage extends StatefulWidget {
  const FileListPage({super.key});

  @override
  _FileListPageState createState() => _FileListPageState();
}

class _FileListPageState extends State<FileListPage> {
  String data = 'Loading...';

  @override
  void initState() {
    super.initState();
    requestStoragePermissionAndListFiles();
  }

  Future<void> requestStoragePermissionAndListFiles() async {
    // 请求存储权限
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    listFilesInDirectory();
  }

  void listFilesInDirectory() async {
    final directory = Directory('/storage/emulated/0');
    if (await directory.exists()) {
      List<FileSystemEntity> files = directory.listSync();
      setState(() {
        data = files.isEmpty
            ? 'No files found'
            : files.map((file) => file.path).join('\n');
      });
    } else {
      setState(() {
        data = 'Directory does not exist';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File List')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Trying to ls storage/emulated/0'),
            const SizedBox(height: 20),
            Text("Data found:\n$data"),
          ],
        ),
      ),
    );
  }
}
