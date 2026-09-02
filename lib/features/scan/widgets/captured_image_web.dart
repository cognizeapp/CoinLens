import 'package:flutter/material.dart';

/// On web, image_picker returns a blob URL usable directly by [Image.network].
Widget buildCapturedImage(String path) => Image.network(
      path,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
