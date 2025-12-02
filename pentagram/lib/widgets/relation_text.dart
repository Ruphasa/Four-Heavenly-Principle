// Deprecated: This widget has been removed in favor of direct repository-driven UI.
// Left as a no-op to avoid temporary import breakages; safe to delete.
import 'package:flutter/material.dart';

class RelationText extends StatelessWidget {
  final String? id;
  final String placeholder;
  final TextStyle? style;

  const RelationText({super.key, this.id, this.placeholder = '-', this.style});

  @override
  Widget build(BuildContext context) {
    return Text(placeholder, style: style);
  }
}
