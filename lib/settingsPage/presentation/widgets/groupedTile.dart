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
  // TODO: if title given, add widget
  final String? title;
  const GroupedTile({required this.children, this.title, super.key});

  @override
  Widget build(BuildContext context) {
    // white background
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),

        // display widget
        child: Column(
          children: List.generate(children.length * 2 - 1, (index) {
            if (index.isOdd) {
              return const Divider(); // Divider between children
            } else {
              return children[index ~/ 2]; // Actual child widget
            }
          }),
        ));
  }
}
