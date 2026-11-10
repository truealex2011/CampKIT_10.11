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
  return isAssetPath(path) ? VideoPlayerController.asset(path) : null;
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
  if (path.isEmpty || !isAssetPath(path) && !path.startsWith('http')) {
    return placeholder;
  }
  return path.startsWith('http')
      ? Image.network(
          path,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => placeholder,
        )
      : Image.asset(
          path,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => placeholder,
        );
}
