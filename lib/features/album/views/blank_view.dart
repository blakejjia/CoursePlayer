part of '../album_page.dart';

class BlankView extends StatefulWidget {
  const BlankView({super.key});

  @override
  State<BlankView> createState() => _BlankViewState();
}

class _BlankViewState extends State<BlankView> {
  bool _isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionInBackground();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: _isPermissionGranted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "choose your mp3 files location",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await chooseAudioRootDir(context);
                    },
                    icon: const Icon(Icons.folder_open),
                    label: const Text("Choose Root Directory"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              )
            : NoPermissionView(onPermissionChanged));
  }

  onPermissionChanged(bool value) {
    setState(() {
      _isPermissionGranted = value;
    });
  }

  Future<void> _checkPermissionInBackground() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        setState(() {
          _isPermissionGranted = false;
        });
      } else {
        setState(() {
          _isPermissionGranted = true;
        });
      }
    });
  }
}
