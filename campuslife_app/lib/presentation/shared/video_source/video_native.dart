import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

bool isAssetPath(String path) =>
    path.startsWith('assets/') ||
    path.startsWith('images/') ||
    path.startsWith('media/');

VideoPlayerController? openVideoController(String path) {
  if (path.startsWith('http')) {
    return VideoPlayerController.networkUrl(Uri.parse(path));
  }
  if (isAssetPath(path)) {
    return VideoPlayerController.asset(path);
  }
  final file = File(path);
  if (!file.existsSync()) return null;
  return VideoPlayerController.file(file);
}

Future<int> probeVideoDurationMs(String path) async {
  final controller = openVideoController(path);
  if (controller == null) return 0;
  try {
    await controller.initialize();
    return controller.value.duration.inMilliseconds;
  } catch (_) {
    return 0;
  } finally {
    controller.dispose();
  }
}

Widget mediaImage(String path, {required Widget placeholder}) {
  if (path.isEmpty) return placeholder;
  if (isAssetPath(path)) {
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
  if (path.startsWith('http')) {
    return Image.network(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
  return Image.file(
    File(path),
    fit: BoxFit.cover,
    errorBuilder: (_, _, _) => placeholder,
  );
}
