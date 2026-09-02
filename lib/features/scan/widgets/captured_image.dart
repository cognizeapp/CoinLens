import 'package:flutter/material.dart';

import 'captured_image_io.dart'
    if (dart.library.html) 'captured_image_web.dart' as impl;

/// Renders a locally captured/uploaded image. The path is a file path on
/// mobile/desktop and a blob URL on web — [impl] picks the right widget.
class CapturedImage extends StatelessWidget {
  const CapturedImage({super.key, required this.path});
  final String path;

  @override
  Widget build(BuildContext context) => impl.buildCapturedImage(path);
}
