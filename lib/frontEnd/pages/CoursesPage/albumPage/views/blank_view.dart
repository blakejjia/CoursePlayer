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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "There's nothing here, try:",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: (_isPermissionGranted)
                ? ElevatedButton(
                    onPressed: () {
                      rebuildDb(context.read<SettingsCubit>().state.audioPath);
                    },
                    child: Text("rebuild database"))
                : ElevatedButton(
                    onPressed: () {
                      Permission.manageExternalStorage.request().then((value) {
                        if (value.isGranted) {
                          setState(() {
                            _isPermissionGranted = true;
                          });
                        } else {
                          setState(() {
                            _isPermissionGranted = false;
                          });
                        }
                      });
                    },
                    child: Text("Grant permission")),
          ),
        ],
      ),
    );
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
