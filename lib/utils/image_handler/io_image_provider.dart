import 'dart:io';
import 'package:flutter/material.dart';

ImageProvider? getPlatformProfileImage(String index) {
  // Mobile: treat string as a file path
  return FileImage(File(index));
}
