import 'package:flutter/material.dart';

extension ColorExtension on String {
  Color hexToColor() {
    final buffer = StringBuffer();

    if(length == 6 || length == 7) {
      buffer.write('ff');
    }

    buffer.write(replaceFirst('#', ''));

    return Color(int.parse(buffer.toString(), radix: 16));
  }
}