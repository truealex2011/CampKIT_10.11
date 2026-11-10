import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

bool isAssetPath(String path) =>
    path.startsWith('assets/') ||
    path.startsWith('images/') ||
    path.startsWith('media/');

VideoPlayerController? openVideoController(String path) => null;

Future<int> probeVideoDurationMs(String path) async => 0;

Widget mediaImage(String path, {required Widget placeholder}) => placeholder;
