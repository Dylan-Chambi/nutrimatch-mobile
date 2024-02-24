import 'dart:math';

import 'package:flutter/material.dart';

Widget loadImageFromUrl(String? imageUrl, BoxFit fit,
    {double? height, double? width, double? maxHeight, double? maxWidth}) {
  try {
    if (imageUrl == null) {
      return FittedBox(
        fit: fit,
        child: Icon(
          Icons.fastfood,
          size: max(maxHeight ?? height ?? 50, maxWidth ?? width ?? 50),
          color: Colors.grey,
        ),
      );
    }
    return Image.network(
      imageUrl,
      fit: fit,
      height: getHeight(height, maxHeight),
      width: getWidth(width, maxWidth),
    );
  } catch (e) {
    return FittedBox(
      fit: fit,
      child: Icon(
        Icons.fastfood,
        size: max(maxHeight ?? height ?? 50, maxWidth ?? width ?? 50),
        color: Colors.grey,
      ),
    );
  }
}

double? getHeight(double? height, double? maxHeight) {
  if (height == null) {
    return null;
  } else if (maxHeight == null) {
    return height;
  } else {
    return min(height, maxHeight);
  }
}

double? getWidth(double? width, double? maxWidth) {
  if (width == null) {
    return null;
  } else if (maxWidth == null) {
    return width;
  } else {
    return min(width, maxWidth);
  }
}
