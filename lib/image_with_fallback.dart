import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

// Hata görselinin Base64 kodu
const String errorImgBase64 = '''
PHN2ZyB3aWR0aD0iODgiIGhlaWdodD0iODgiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgc3Ryb2tlPSIjMDAwIiBzdHJva2UtbGluZWpvaW49InJvdW5kIiBvcGFjaXR5PSIuMyIgZmlsbD0ibm9uZSIgc3Ryb2tlLXdpZHRoPSIzLjciPjxyZWN0IHg9IjE2IiB5PSIxNiIgd2lkdGg9IjU2IiBoZWlnaHQ9IjU2IiByeD0iNiIvPjxwYXRoIGQ9Im0xNiA1OCAxNi0xOCAzMiAzMiIvPjxjaXJjbGUgY3g9IjUzIiBjeT0iMzUiIHI9IjciLz48L3N2Zz4KCg==
''';

Uint8List errorImgBytes() {
  return base64Decode(errorImgBase64);
}

class ImageWithFallback extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final String? alt;

  const ImageWithFallback({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.alt,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      // Eğer hiç URL yoksa direkt hata görseli göster
      return Image.memory(
        errorImgBytes(),
        width: width,
        height: height,
        fit: fit,
      );
    }
    return Image.network(
      imageUrl!,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Yüklenemezse hata görselini göster
        return Image.memory(
          errorImgBytes(),
          width: width,
          height: height,
          fit: fit ?? BoxFit.cover,
        );
      },
      semanticLabel: alt,
    );
  }
}