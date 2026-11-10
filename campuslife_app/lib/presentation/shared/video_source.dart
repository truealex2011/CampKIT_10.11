export 'video_source/video_default.dart'
    if (dart.library.io) 'video_source/video_native.dart'
    if (dart.library.js_interop) 'video_source/video_web.dart';
