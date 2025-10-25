import '../../api/config.dart';

class ImageUrlHelper {
  /// Constructs a full URL for profile images
  /// Handles both relative and absolute paths
  static String getProfileImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      // Return default profile image as asset
      return 'Photos/profile.png';
    }

    // If it's already a full URL, return as is
    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    // Normalize the path - remove leading slash if present
    final normalizedPath = imagePath.startsWith('/')
        ? imagePath.substring(1)
        : imagePath;

    // Construct the full URL
    final baseUrl = ApiConfig.currentBaseUrl.replaceAll(
      '/public/index.php',
      '/public',
    );
    return '$baseUrl/$normalizedPath';
  }

  /// Constructs a full URL for any image path
  static String getImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    final baseUrl = ApiConfig.currentBaseUrl.replaceAll(
      '/public/index.php',
      '/public',
    );
    return '$baseUrl/$imagePath';
  }
}
