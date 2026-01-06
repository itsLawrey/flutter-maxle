import 'package:flutter/material.dart';

import 'image_handler/stub_image_provider.dart'
    if (dart.library.io) 'image_handler/io_image_provider.dart'
    if (dart.library.html) 'image_handler/web_image_provider.dart';

/// Returns an ImageProvider for the given profile image string.
/// Returns null if the string represents a color index.
ImageProvider? getProfileImageProvider(String profileImageIndex) {
  final int? colorIndex = int.tryParse(profileImageIndex);
  if (colorIndex != null) {
    return null; // It's a color index
  }

  // Delegate to platform-specific implementation
  return getPlatformProfileImage(profileImageIndex);
}
