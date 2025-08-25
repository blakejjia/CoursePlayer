import 'package:flutter/material.dart';

import '../../../core/backEnd/data/models/models.dart';
import '../logic/writeTag.dart';

class ChangeArtistPopUp extends StatefulWidget {
  final List<Song>? buffer;
  final List<String> parts;
  final String baseFolder;
  ChangeArtistPopUp(this.baseFolder, this.buffer, {super.key})
      : parts = ['all', ...?buffer?.map((song) => song.parts).toSet()];

  @override
  State<ChangeArtistPopUp> createState() => _ChangeArtistPopUpState();
}

class _ChangeArtistPopUpState extends State<ChangeArtistPopUp> {
  late String selection;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selection = "all";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Artist Name'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // textfield
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'New Artist Name',
            ),
          ),
          const SizedBox(height: 20),
          // drop down button
          DropdownButton<String>(
            value: selection,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selection = newValue;
                });
              }
            },
            items: widget.parts.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        // cancel button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        // ok button
        TextButton(
          onPressed: () {
            String? subfolder =
                (selection == "" || selection == "all") ? null : selection;
            writeArtistTag(widget.baseFolder, _controller.text,
                subfolderName: subfolder);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
