import 'dart:io';

import 'package:flutter/material.dart';

Widget buildCapturedImage(String path) => Image.file(
      File(path),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
