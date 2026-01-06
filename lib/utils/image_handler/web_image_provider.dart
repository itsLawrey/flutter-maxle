import 'dart:convert';
import 'package:flutter/material.dart';

ImageProvider? getPlatformProfileImage(String index) {
  try {
    // Web: treat string as Base64
    String base64String = index;
    if (base64String.contains(',')) {
      base64String = base64String.split(',').last;
    }
    return MemoryImage(base64Decode(base64String));
  } catch (e) {
    debugPrint('Error decoding base64 image: $e');
    return null;
  }
}
