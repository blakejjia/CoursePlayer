import 'package:flutter/material.dart';

/// [GroupedTile] is special designed for Settings page
///
/// * Creates vertical array of [Widget]
/// * [Divider] will be given between Widgets
class GroupedTile extends StatelessWidget {
  /// [Widget] being
  final List<Widget> children;

  /// Determine a title
  /// if not null, it will be displayed before children
  final String? title;
  const GroupedTile({required this.children, this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title != null
            ? Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 24.0),
                child: Text(title!),
              )
            : SizedBox(
                height: 20,
              ),
        Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(32),
            ),

            // display widget
            child: Column(
              children: List.generate(children.length * 2 - 1, (index) {
                if (index.isOdd) {
                  return Divider(
                    thickness: 2,
                    height: 1,
                    color: Theme.of(context).colorScheme.surface,
                  ); // Divider between children
                } else {
                  return children[index ~/ 2]; // Actual child widget
                }
              }),
            )),
      ],
    );
  }
}
