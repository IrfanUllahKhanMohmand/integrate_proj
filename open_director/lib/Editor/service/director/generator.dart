// import 'package:flutter/foundation.dart';
// import 'dart:io';
// import 'dart:async';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:flutter/painting.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;
// import 'package:logger/logger.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
// import 'package:open_director/service_locator.dart';
// import 'package:open_director/model/model.dart';

// class Generator {
//   final logger = locator.get<Logger>();
//   final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

//   BehaviorSubject<FFmpegStat> _ffmepegStat =
//       BehaviorSubject.seeded(FFmpegStat());
//   Observable<FFmpegStat> get ffmepegStat$ => _ffmepegStat.stream;
//   FFmpegStat get ffmepegStat => _ffmepegStat.value;

//   getVideoDuration(String path) async {
//     Map<dynamic, dynamic> info = await _flutterFFmpeg.getMediaInformation(path);
//     return info['duration'];
//   }

//   generateVideoThumbnail(String srcPath, String thumbnailPath, int pos,
//       VideoResolution videoResolution) async {
//     VideoResolutionSize size = _videoResolutionSize(videoResolution);
//     List pathList = thumbnailPath.split('.');
//     pathList[pathList.length - 2] += '_${size.width}x${size.height}';
//     String path = pathList.join('.');
//     String arguments = '-loglevel error -y -i "$srcPath" ' +
//         '-ss ${pos / 1000} -vframes 1 -vf scale=-2:${size.height} "$path"';
//     await _flutterFFmpeg.execute(arguments);
//     return path;
//   }

//   generateImageThumbnail(String srcPath, String thumbnailPath,
//       VideoResolution videoResolution) async {
//     VideoResolutionSize size = _videoResolutionSize(videoResolution);
//     List pathList = thumbnailPath.split('.');
//     pathList[pathList.length - 2] += '_${size.width}x${size.height}';
//     String path = pathList.join('.');
//     String arguments = '-loglevel error -y -r 1 -i "$srcPath" ' +
//         '-ss 0 -vframes 1 -vf scale=-2:${size.height} "$path"';
//     await _flutterFFmpeg.execute(arguments);
//     return path;
//   }

//   generateVideoAll(List<Layer> layers, VideoResolution videoResolution) async {
//     // To free memory
//     imageCache.clear();

//     final String galleryDirPath = '/storage/emulated/0/Movies/OpenDirector';
//     await Permission.storage.request();
//     await new Directory(galleryDirPath).create();

//     String arguments = _commandLogLevel('error');
//     arguments += _commandInputs(layers[0]);
//     arguments += _commandInputs(layers[2]);
//     arguments += ' -filter_complex "';
//     arguments += _commandImageVideoFilters(layers[0], 0, videoResolution);
//     arguments += _commandAudioFilters(layers[2], layers[0].assets.length);
//     if (layers[2].assets.length > 0) {
//       arguments +=
//           _commandConcatenateVideoStreamsWithoutAudio(layers[0], 0, false);
//       arguments +=
//           _commandConcatenateStreams(layers[2], layers[0].assets.length, true);
//     } else {
//       arguments +=
//           _commandConcatenateVideoStreamsWithAudio(layers[0], 0, false);
//     }

//     arguments += await _commandTextAssets(layers[1], videoResolution);
//     arguments = arguments.substring(0, arguments.length - 1);
//     arguments += '"';
//     arguments += _commandCodecsAndFormat(CodecsAndFormat.H264AacMp4);
//     String dateSuffix = dateTimeString(DateTime.now());
//     String outputPath = p.join(galleryDirPath, 'Open_Director_$dateSuffix.mp4');
//     arguments += _commandOutputFile(
//         path: outputPath,
//         withAudio: layers[2].assets.length > 0,
//         overwrite: true);

//     String out =
//         await executeCommand(arguments, finished: true, outputPath: outputPath);
//     return out;
//   }

//   generateVideoBySteps(
//       List<Layer> layers, VideoResolution videoResolution) async {
//     // To release memory
//     imageCache.clear();

//     int rc = await generateVideosForAssets(layers[0], videoResolution);
//     if (rc != 0) return;

//     rc = await concatVideos(layers, videoResolution);
//     if (rc != 0) return;

//     final String galleryDirPath = '/storage/emulated/0/Movies/OpenDirector';
//     await Permission.storage.request();
//     await new Directory(galleryDirPath).create();

//     String arguments = _commandLogLevel('error');

//     final Directory extStorDir = await getExternalStorageDirectory();
//     String videoConcatenatedPath =
//         p.join(extStorDir.path, 'temp', 'concanenated.mp4');
//     arguments += _commandInput(videoConcatenatedPath);
//     arguments += await _commandInputForAudios(layers[2]);

//     arguments += ' -filter_complex "';
//     arguments += _commandAudioFilters(layers[2], 1);
//     arguments += _commandConcatenateStreams(layers[2], 1, true);
//     arguments += await _commandTextAssets(layers[1], videoResolution);
//     arguments = arguments.substring(0, arguments.length - 1);
//     arguments += '"';

//     arguments += _commandCodecsAndFormat(CodecsAndFormat.H264AacMp4);
//     String dateSuffix = dateTimeString(DateTime.now());
//     String outputPath = p.join(galleryDirPath, 'Open_Director_$dateSuffix.mp4');
//     arguments += _commandOutputFile(
//         path: outputPath,
//         withAudio: layers[2].assets.isNotEmpty,
//         overwrite: true);

//     await executeCommand(arguments, finished: true, outputPath: outputPath);
//     await _deleteTempDir();
//   }

//   generateVideosForAssets(Layer layer, VideoResolution videoResolution) async {
//     final Directory extStorDir = await getExternalStorageDirectory();
//     await Directory(p.join(extStorDir.path, 'temp')).create();
//     int fileNum = 1;
//     for (int i = 0; i < layer.assets.length; i++) {
//       int rc = await generateVideoForAsset(
//           i, fileNum, layer.assets.length, layer.assets[i], videoResolution);
//       if (rc != 0) return rc;
//       fileNum++;
//     }
//     return 0;
//   }

//   generateVideoForAsset(int index, int fileNum, int totalFiles, Asset asset,
//       VideoResolution videoResolution) async {
//     String arguments = _commandLogLevel('error');
//     arguments += _commandInput(asset.srcPath);
//     arguments += ' -filter_complex "';
//     if (asset.type == AssetType.image) {
//       arguments += _commandPadForAspectRatioFilter(videoResolution);
//       arguments += _commandKenBurnsEffectFilter(videoResolution, asset);
//     } else if (asset.type == AssetType.video) {
//       arguments += _commandPadForAspectRatioFilter(videoResolution);
//       arguments += _commandTrimFilter(asset, false);
//     }
//     arguments += _commandScaleFilter(videoResolution);
//     arguments = arguments.substring(0, arguments.length - 1);
//     arguments += '[v]"';
//     arguments += _commandCodecsAndFormat(CodecsAndFormat.H264AacMp4);

//     final Directory extStorDir = await getExternalStorageDirectory();
//     String outputPath = p.join(extStorDir.path, 'temp', 'v$index.mp4');
//     arguments +=
//         _commandOutputFile(path: outputPath, withAudio: false, overwrite: true);

//     return await executeCommand(arguments,
//         fileNum: fileNum, totalFiles: totalFiles);
//   }

//   concatVideos(List<Layer> layers, VideoResolution videoResolution) async {
//     String arguments = _commandLogLevel('error');
//     String listPath = await _listForConcat(layers[0]);
//     arguments += ' -f concat -safe 0 -i "$listPath" -c copy';

//     final Directory extStorDir = await getExternalStorageDirectory();
//     String outputPath = p.join(extStorDir.path, 'temp', 'concanenated.mp4');
//     arguments += ' -y "$outputPath"';

//     return await executeCommand(arguments);
//   }

//   _listForConcat(Layer layer) async {
//     final Directory extStorDir = await getExternalStorageDirectory();
//     String tempPath = p.join(extStorDir.path, 'temp');
//     String list = '';
//     for (int i = 0; i < layer.assets.length; i++) {
//       list += "file '${p.join(tempPath, "v" + i.toString() + ".mp4")}'\n";
//     }
//     File file = await File(p.join(tempPath, 'list.txt')).writeAsString(list);
//     return file.path;
//   }

//   _deleteTempDir() async {
//     print('_deleteTempDir()');
//     final Directory extStorDir = await getExternalStorageDirectory();
//     String tempPath = p.join(extStorDir.path, 'temp');
//     await Directory(tempPath).delete(recursive: true);
//   }

//   executeCommand(
//     String arguments, {
//     String outputPath,
//     int fileNum,
//     int totalFiles,
//     bool finished = false,
//   }) {
//     final completer = new Completer<String>();
//     DateTime initTime = DateTime.now();

//     _flutterFFmpeg.enableStatisticsCallback((int time,
//         int size,
//         double bitrate,
//         double speed,
//         int videoFrameNumber,
//         double videoQuality,
//         double videoFps) {
//       _ffmepegStat.add(FFmpegStat(
//         time: time,
//         size: size,
//         bitrate: bitrate,
//         speed: speed,
//         videoFrameNumber: videoFrameNumber,
//         videoQuality: videoQuality,
//         videoFps: videoFps,
//         timeElapsed: DateTime.now().difference(initTime).inMilliseconds,
//         fileNum: fileNum,
//         totalFiles: totalFiles,
//       ));
//     });

//     _flutterFFmpeg.enableStatistics();

//     _flutterFFmpeg.execute(arguments).then((int rc) async {
//       if (rc == 0) {
//         ffmepegStat.finished = finished;
//         ffmepegStat.outputPath = outputPath;
//         _ffmepegStat.add(ffmepegStat);
//         Duration diffTime = DateTime.now().difference(initTime);
//         logger.i('Generator.executeCommand() $diffTime)');
//         completer.complete(outputPath);
//       } else if (rc != 255) {
//         ffmepegStat.error = true;
//         _ffmepegStat.add(ffmepegStat);
//         _flutterFFmpeg.getLastCommandOutput().then((output) async {
//           logger.e('Generator.executeCommand() $output');
//         });
//         completer.complete(null);
//       } else {
//         completer.complete(null);
//       }
//       ffmepegStat.time = 0;
//       _flutterFFmpeg.resetStatistics();
//       _flutterFFmpeg.disableStatistics();
//     });

//     return completer.future;
//   }

//   finishVideoGeneration() async {
//     _ffmepegStat.add(FFmpegStat());
//     await _flutterFFmpeg.cancel();
//   }

//   String _commandLogLevel(String level) => '-loglevel $level ';

//   String _commandInputs(Layer layer) {
//     if (layer.assets.isEmpty) return "";
//     return layer.assets
//         .map((asset) => _commandInput(asset.srcPath))
//         .reduce((a, b) => a + b);
//   }

//   _commandInputForAudios(Layer layer) async {
//     String arguments = '';
//     for (int i = 0; i < layer.assets.length; i++) {
//       arguments += _commandInput(layer.assets[i].srcPath);
//     }
//     return arguments;
//   }

//   String _commandInput(path) => ' -i "$path"';

//   String _commandImageVideoFilters(
//       Layer layer, int startIndex, VideoResolution videoResolution) {
//     String arguments = "";
//     for (var i = 0; i < layer.assets.length; i++) {
//       arguments += '[${startIndex + i}:v]';
//       arguments += _commandPadForAspectRatioFilter(videoResolution);
//       if (layer.assets[i].type == AssetType.image) {
//         arguments +=
//             _commandKenBurnsEffectFilter(videoResolution, layer.assets[i]);
//       } else if (layer.assets[i].type == AssetType.video) {
//         arguments += _commandTrimFilter(layer.assets[i], false);
//       }
//       arguments += _commandScaleFilter(videoResolution);
//       arguments += 'copy[v${startIndex + i}];';
//     }
//     return arguments;
//   }

//   String _commandAudioFilters(Layer layer, int startIndex) {
//     String arguments = "";
//     for (var i = 0; i < layer.assets.length; i++) {
//       arguments += '[${startIndex + i}:a]' +
//           _commandTrimFilter(layer.assets[i], true) +
//           'acopy[au${startIndex + i}];';
//     }
//     return arguments;
//   }

//   String _commandTrimFilter(Asset asset, bool audio) =>
//       '${audio ? "a" : ""}trim=${asset.cutFrom / 1000}' +
//       ':${(asset.cutFrom + asset.duration) / 1000},' +
//       '${audio ? "a" : ""}setpts=PTS-STARTPTS,';

//   String _commandPadForAspectRatioFilter(VideoResolution videoResolution) {
//     VideoResolutionSize size = _videoResolutionSize(videoResolution);
//     return "pad=w='max(ceil(ceil(ih/2)*2/${size.height / size.width}/2)*2,ceil(iw/2)*2)':" +
//         "h='max(ceil(ceil(iw/2)*2*${size.height / size.width}/2)*2,ceil(ih/2)*2)':" +
//         "x=(ow-iw)/2:y=(oh-ih)/2,";
//   }

//   String _commandScaleFilter(VideoResolution videoResolution) {
//     VideoResolutionSize size = _videoResolutionSize(videoResolution);
//     return 'scale=${size.width}:${size.height}:force_original_aspect_ratio=increase, crop=${size.width}:${size.height},setsar=1,';
//   }

//   VideoResolutionSize _videoResolutionSize(VideoResolution videoResolution) {
//     switch (videoResolution) {
//       case VideoResolution.fullHd:
//         return VideoResolutionSize(width: 1920, height: 1080);
//       case VideoResolution.hd:
//         return VideoResolutionSize(width: 1280, height: 720);
//       case VideoResolution.mini:
//         return VideoResolutionSize(width: 64, height: 36);
//       default:
//         return VideoResolutionSize(width: 640, height: 360);
//     }
//   }

//   String videoResolutionString(VideoResolution videoResolution) {
//     switch (videoResolution) {
//       case VideoResolution.fullHd:
//         return 'Full HD 1080px';
//       case VideoResolution.hd:
//         return 'HD 720px';
//       case VideoResolution.mini:
//         return 'Thumbnail 36px';
//       default:
//         return 'SD 360px';
//     }
//   }

//   String _commandKenBurnsEffectFilter(
//       VideoResolution videoResolution, Asset asset) {
//     VideoResolutionSize size = _videoResolutionSize(videoResolution);
//     // Default framerate 25 in zoompan
//     double d = asset.duration / 1000 * 25;
//     String s = "${size.width}x${size.height}";
//     // Zoom 20%
//     String z = asset.kenBurnZSign == 1
//         ? "'zoom+${0.2 / d}'"
//         : (asset.kenBurnZSign == -1
//             ? "'if(eq(on,1),1.2,zoom-${0.2 / d})'"
//             : "1.2");
//     String x = asset.kenBurnZSign != 0
//         ? "'${asset.kenBurnXTarget}*(iw-iw/zoom)'"
//         : (asset.kenBurnXTarget == 1
//             ? "'(${asset.kenBurnXTarget}-on/$d)*(iw-iw/zoom)'"
//             : (asset.kenBurnXTarget == 0
//                 ? "'on/$d*(iw-iw/zoom)'"
//                 : "'(iw-iw/zoom)/2'"));
//     String y = asset.kenBurnZSign != 0
//         ? "'${asset.kenBurnYTarget}*(ih-ih/zoom)'"
//         : (asset.kenBurnYTarget == 1
//             ? "'(${asset.kenBurnYTarget}-on/$d)*(ih-ih/zoom)'"
//             : (asset.kenBurnYTarget == 0
//                 ? "'on/$d*(ih-ih/zoom)'"
//                 : "'(ih-ih/zoom)/2'"));
//     return "zoompan=d=$d:s=$s:z=$z:x=$x:y=$y,";
//   }

//   String _commandConcatenateVideoStreamsWithoutAudio(
//       Layer layer, int startIndex, bool isAudio) {
//     String arguments = "";
//     // Concatenation
//     // - n: Set the number of segments. Default is 2.
//     // - v: Set the number of output video streams. Default is 1.
//     // - a: Set the number of output audio streams. Default is 0.
//     for (var i = startIndex; i < startIndex + layer.assets.length; i++) {
//       // arguments += '["v"$i][$i:"a"]';
//       arguments += '["v"$i]';
//     }
//     if (layer.assets.length > 0) {
//       arguments +=
//           // 'concat=n=${layer.assets.length}' + ':v=1:a=1' + '["vprev"] ["a"];';
//           'concat=n=${layer.assets.length}' + ':v=1:a=0' + '["vprev"];';
//     }
//     return arguments;
//   }

//   String _commandConcatenateVideoStreamsWithAudio(
//       Layer layer, int startIndex, bool isAudio) {
//     String arguments = "";
//     // Concatenation
//     // - n: Set the number of segments. Default is 2.
//     // - v: Set the number of output video streams. Default is 1.
//     // - a: Set the number of output audio streams. Default is 0.
//     for (var i = startIndex; i < startIndex + layer.assets.length; i++) {
//       arguments += '["v"$i][$i:"a"]';
//     }
//     if (layer.assets.length > 0) {
//       arguments +=
//           'concat=n=${layer.assets.length}' + ':v=1:a=1' + '["vprev"] ["a"];';
//     }
//     return arguments;
//   }

//   String _commandConcatenateStreams(Layer layer, int startIndex, bool isAudio) {
//     String arguments = "";
//     // Concatenation
//     // - n: Set the number of segments. Default is 2.
//     // - v: Set the number of output video streams. Default is 1.
//     // - a: Set the number of output audio streams. Default is 0.
//     for (var i = startIndex; i < startIndex + layer.assets.length; i++) {
//       arguments += '[${isAudio ? "au" : "v"}$i]';
//     }
//     if (layer.assets.length > 0) {
//       arguments += 'concat=n=${layer.assets.length}' +
//           ':v=${isAudio ? 0 : 1}:a=${isAudio ? 1 : 0}' +
//           '[${isAudio ? "au" : "vprev"}];';
//     }
//     return arguments;
//   }

//   _commandTextAssets(Layer layer, VideoResolution videoResolution) async {
//     // String arguments = '[0:v]';
//     String arguments = '[vprev]';
//     for (int i = 0; i < layer.assets.length; i++) {
//       if (layer.assets[i].title != '') {
//         arguments += await _commandDrawText(layer.assets[i], videoResolution);
//       }
//     }
//     arguments += 'copy[v];';
//     return arguments;
//   }

//   _commandDrawText(Asset asset, VideoResolution videoResolution) async {
//     String fontFile = await _getFontPath(asset.font);
//     String fontColor = '0x' + asset.fontColor.toRadixString(16).substring(2);
//     VideoResolutionSize size = _videoResolutionSize(videoResolution);

//     return "drawtext=" +
//         "enable='between(t,${asset.begin / 1000},${(asset.begin + asset.duration) / 1000})':" +
//         "x=${asset.x * size.width}:y=${asset.y * size.height}:" +
//         "fontfile=$fontFile:fontsize=${asset.fontSize * size.width}:" +
//         "fontcolor=$fontColor:alpha=${asset.alpha}:" +
//         "borderw=${asset.borderw}:bordercolor=${colorStr(asset.bordercolor)}:" +
//         "shadowcolor=${colorStr(asset.shadowcolor)}:shadowx=${asset.shadowx}:shadowy=${asset.shadowy}:" +
//         "box=${asset.box ? 1 : 1}:boxborderw=${asset.boxborderw}:boxcolor=${colorStr(asset.boxcolor)}:" +
//         "line_spacing=0:" +
//         "text='${asset.title}',";
//   }

//   colorStr(int colorInt) {
//     String colorStr = colorInt.toRadixString(16).padLeft(8, '0');
//     String newColorStr = colorStr.substring(2) + colorStr.substring(0, 2);
//     return '0x$newColorStr';
//   }

//   // Formats: https://ffmpeg.org/ffmpeg-formats.html
//   String _commandCodecsAndFormat(CodecsAndFormat codecsAndFormat) {
//     switch (codecsAndFormat) {
//       // libvpx-vp9 https://trac.ffmpeg.org/wiki/Encode/VP9 (LGPL)
//       // libvpx-vp9 has a lossless encoding mode that can be activated using -lossless 1
//       // Opus, for VP9 https://trac.ffmpeg.org/wiki/Encode/HighQualityAudio
//       case CodecsAndFormat.VP9OpusWebm:
//         return ' -c:v libvpx-vp9 -lossless 1 -c:a opus -f webm';
//       // libx264 https://trac.ffmpeg.org/wiki/Encode/H.264 (GPL, not included)
//       // Native encoder aac https://trac.ffmpeg.org/wiki/Encode/AAC
//       case CodecsAndFormat.H264AacMp4:
//         return ' -c:v libx264 -c:a aac -pix_fmt yuva420p -f mp4';
//       // libxvid https://trac.ffmpeg.org/wiki/Encode/MPEG-4 (GPL, not included)
//       case CodecsAndFormat.Xvid:
//         return ' -c:v libxvid -c:a aac -f avi';
//       // Native encoder mpeg4 https://trac.ffmpeg.org/wiki/Encode/MPEG-4 (LGPL)
//       // qscale: 1 highest quality/largest filesize, 31 lowest quality/smallest filesize
//       default:
//         return ' -c:v mpeg4 -qscale:v 1 -c:a aac -f mp4';
//     }
//   }

//   //String _commandFrameRate(int frameRate) => ' -r $frameRate';
//   String _commandOutputFile({String path, bool withAudio, bool overwrite}) =>
//       ' -map "[v]" ${withAudio ? "-map \"[au]\"" : "-map \"[a]\""} ${overwrite ? "-y" : ""} $path';

//   String dateTimeString(DateTime dateTime) {
//     return '${dateTime.year.toString().padLeft(4, "0")}' +
//         '${dateTime.month.toString().padLeft(2, "0")}' +
//         '${dateTime.day.toString().padLeft(2, "0")}' +
//         '_${dateTime.hour.toString().padLeft(2, "0")}' +
//         '${dateTime.minute.toString().padLeft(2, "0")}' +
//         '${dateTime.second.toString().padLeft(2, "0")}';
//   }

//   _getFontPath(String relativePath) async {
//     const String rootFontsPath = 'fonts';
//     final ByteData fontFile =
//         await rootBundle.load(p.join(rootFontsPath, relativePath));
//     final Directory appDocDir = await getApplicationDocumentsDirectory();
//     final String fontPath =
//         p.join(appDocDir.parent.path, rootFontsPath, relativePath);
//     File(fontPath)
//       ..createSync(recursive: true)
//       ..writeAsBytesSync(fontFile.buffer
//           .asUint8List(fontFile.offsetInBytes, fontFile.lengthInBytes));
//     return fontPath;
//   }
// }

// enum VideoResolution {
//   sd,
//   hd,
//   fullHd,
//   mini,
// }

// enum CodecsAndFormat {
//   Mpeg4,
//   Xvid,
//   H264AacMp4,
//   VP9OpusWebm,
// }

// class VideoResolutionSize {
//   int width;
//   int height;
//   VideoResolutionSize({@required this.width, @required this.height});
// }

// class FFmpegStat {
//   int time;
//   int size;
//   double bitrate;
//   double speed;
//   int videoFrameNumber;
//   double videoQuality;
//   double videoFps;
//   bool finished = false;
//   String outputPath;
//   bool error = false;
//   int timeElapsed;
//   int fileNum;
//   int totalFiles;

//   FFmpegStat({
//     this.time = 0,
//     this.size = 0,
//     this.bitrate = 0,
//     this.speed = 0,
//     this.videoFrameNumber = 0,
//     this.videoQuality = 0,
//     this.videoFps = 0,
//     this.outputPath,
//     this.timeElapsed = 0,
//     this.fileNum,
//     this.totalFiles,
//   });
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:open_director/Editor/ui/common/volume_variables.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:open_director/Editor/service_locator.dart';
import 'package:open_director/Editor/model/model.dart';

class Generator {
  final logger = locator.get<Logger>();
  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

  BehaviorSubject<FFmpegStat> _ffmepegStat =
      BehaviorSubject.seeded(FFmpegStat());
  Observable<FFmpegStat> get ffmepegStat$ => _ffmepegStat.stream;
  FFmpegStat get ffmepegStat => _ffmepegStat.value;

  getVideoDuration(String path) async {
    Map<dynamic, dynamic> info = await _flutterFFmpeg.getMediaInformation(path);
    return info['duration'];
  }

  generateVideoThumbnail(String srcPath, String thumbnailPath, int pos,
      VideoResolution videoResolution) async {
    VideoResolutionSize size = _videoResolutionSize(videoResolution);
    List pathList = thumbnailPath.split('.');
    pathList[pathList.length - 2] += '_${size.width}x${size.height}';
    String path = pathList.join('.');
    String arguments = '-loglevel error -y -i "$srcPath" ' +
        '-ss ${pos / 1000} -vframes 1 -vf scale=-2:${size.height} "$path"';
    await _flutterFFmpeg.execute(arguments);
    return path;
  }

  generateImageThumbnail(String srcPath, String thumbnailPath,
      VideoResolution videoResolution) async {
    VideoResolutionSize size = _videoResolutionSize(videoResolution);
    List pathList = thumbnailPath.split('.');
    pathList[pathList.length - 2] += '_${size.width}x${size.height}';
    String path = pathList.join('.');
    String arguments = '-loglevel error -y -r 1 -i "$srcPath" ' +
        '-ss 0 -vframes 1 -vf scale=-2:${size.height} "$path"';
    await _flutterFFmpeg.execute(arguments);
    return path;
  }

  generateVideoAll(List<Layer> layers, VideoResolution videoResolution,
      BuildContext context) async {
    imageCache.clear();

    bool onlyVideosAudio = false;
    bool onlyMusicAudio = false;
    bool bothAudios = true;

    final String galleryDirPath = '/storage/emulated/0/Movies/OpenDirector';
    await Permission.storage.request();
    await new Directory(galleryDirPath).create();

    String arguments = _commandLogLevel('error');

    arguments += _commandInputs(layers[0]);
    arguments +=
        " -f lavfi -t 0.1 -i anullsrc=channel_layout=stereo:sample_rate=44100";
    arguments += _commandInputs(layers[2]);

    arguments += ' -filter_complex "';
    arguments += _commandImageVideoFilters(layers[0], 0, videoResolution);

    if (bothAudios) {
      arguments += _commandAudioFilters(layers[2], layers[0].assets.length + 1);
      arguments += _commandConcatenateStreams(
          layers[2], layers[0].assets.length + 1, true);
      arguments += _commandConcatenateVideoStreamsWithAudio(
          layers[0], 0, false, context, layers[2]);
      arguments += await _commandTextAssets(layers[1], videoResolution);
      arguments = arguments.substring(0, arguments.length - 1);
      arguments += '"';
      arguments += _commandCodecsAndFormat(CodecsAndFormat.H264AacMp4);
      String dateSuffix = dateTimeString(DateTime.now());
      String outputPath =
          p.join(galleryDirPath, 'Open_Director_$dateSuffix.mp4');
      arguments += _commandOutputFileForBothAudios(path: outputPath);
      String out = await executeCommand(arguments,
          finished: true, outputPath: outputPath);
      return out;
    }

    if (onlyMusicAudio) {
      arguments += _commandAudioFilters(layers[2], layers[0].assets.length);
      arguments +=
          _commandConcatenateStreams(layers[2], layers[0].assets.length, true);
      arguments += _commandConcatenateVideoStreamsWithoutAudio(layers[0], 0);
      arguments += await _commandTextAssets(layers[1], videoResolution);
      arguments = arguments.substring(0, arguments.length - 1);
      arguments += '"';
      arguments += _commandCodecsAndFormat(CodecsAndFormat.H264AacMp4);
      String dateSuffix = dateTimeString(DateTime.now());
      String outputPath =
          p.join(galleryDirPath, 'Open_Director_$dateSuffix.mp4');
      arguments += _commandOutputFileForMusicAudio(path: outputPath);
      String out = await executeCommand(arguments,
          finished: true, outputPath: outputPath);
      return out;
    }
    if (onlyVideosAudio) {
      arguments += _commandConcatenateVideoStreamsWithItsAudio(layers[0], 0);
      arguments += await _commandTextAssets(layers[1], videoResolution);
      arguments = arguments.substring(0, arguments.length - 1);
      arguments += '"';
      arguments += _commandCodecsAndFormat(CodecsAndFormat.H264AacMp4);
      String dateSuffix = dateTimeString(DateTime.now());
      String outputPath =
          p.join(galleryDirPath, 'Open_Director_$dateSuffix.mp4');
      arguments += _commandOutputFileForVideoAudio(path: outputPath);
      String out = await executeCommand(arguments,
          finished: true, outputPath: outputPath);
      return out;
    }
  }

  generateVideoBySteps(
      List<Layer> layers, VideoResolution videoResolution) async {
    // To release memory
    imageCache.clear();

    int rc = await generateVideosForAssets(layers[0], videoResolution);
    if (rc != 0) return;

    rc = await concatVideos(layers, videoResolution);
    if (rc != 0) return;

    final String galleryDirPath = '/storage/emulated/0/Movies/OpenDirector';
    await Permission.storage.request();
    await new Directory(galleryDirPath).create();

    String arguments = _commandLogLevel('error');

    final Directory extStorDir = await getExternalStorageDirectory();
    String videoConcatenatedPath =
        p.join(extStorDir.path, 'temp', 'concanenated.mp4');
    arguments += _commandInput(videoConcatenatedPath);
    arguments += await _commandInputForAudios(layers[2]);

    arguments += ' -filter_complex "';
    arguments += _commandAudioFilters(layers[2], 1);
    arguments += _commandConcatenateStreams(layers[2], 1, true);
    arguments += await _commandTextAssets(layers[1], videoResolution);
    arguments = arguments.substring(0, arguments.length - 1);
    arguments += '"';

    arguments += _commandCodecsAndFormat(CodecsAndFormat.H264AacMp4);
    String dateSuffix = dateTimeString(DateTime.now());
    String outputPath = p.join(galleryDirPath, 'Open_Director_$dateSuffix.mp4');
    arguments += _commandOutputFile(
        path: outputPath,
        withAudio: layers[2].assets.isNotEmpty,
        overwrite: true);

    await executeCommand(arguments, finished: true, outputPath: outputPath);
    await _deleteTempDir();
  }

  generateVideosForAssets(Layer layer, VideoResolution videoResolution) async {
    final Directory extStorDir = await getExternalStorageDirectory();
    await Directory(p.join(extStorDir.path, 'temp')).create();
    int fileNum = 1;
    for (int i = 0; i < layer.assets.length; i++) {
      int rc = await generateVideoForAsset(
          i, fileNum, layer.assets.length, layer.assets[i], videoResolution);
      if (rc != 0) return rc;
      fileNum++;
    }
    return 0;
  }

  generateVideoForAsset(int index, int fileNum, int totalFiles, Asset asset,
      VideoResolution videoResolution) async {
    String arguments = _commandLogLevel('error');
    arguments += _commandInput(asset.srcPath);
    arguments += ' -filter_complex "';
    if (asset.type == AssetType.image) {
      arguments += _commandPadForAspectRatioFilter(videoResolution);
      arguments += _commandKenBurnsEffectFilter(videoResolution, asset);
    } else if (asset.type == AssetType.video) {
      arguments += _commandPadForAspectRatioFilter(videoResolution);
      arguments += _commandTrimFilter(asset, false);
    }
    arguments += _commandScaleFilter(videoResolution);
    arguments = arguments.substring(0, arguments.length - 1);
    arguments += '[v]"';
    arguments += _commandCodecsAndFormat(CodecsAndFormat.H264AacMp4);

    final Directory extStorDir = await getExternalStorageDirectory();
    String outputPath = p.join(extStorDir.path, 'temp', 'v$index.mp4');
    arguments +=
        _commandOutputFile(path: outputPath, withAudio: false, overwrite: true);

    return await executeCommand(arguments,
        fileNum: fileNum, totalFiles: totalFiles);
  }

  concatVideos(List<Layer> layers, VideoResolution videoResolution) async {
    String arguments = _commandLogLevel('error');
    String listPath = await _listForConcat(layers[0]);
    arguments += ' -f concat -safe 0 -i "$listPath" -c copy';

    final Directory extStorDir = await getExternalStorageDirectory();
    String outputPath = p.join(extStorDir.path, 'temp', 'concanenated.mp4');
    arguments += ' -y "$outputPath"';

    return await executeCommand(arguments);
  }

  _listForConcat(Layer layer) async {
    final Directory extStorDir = await getExternalStorageDirectory();
    String tempPath = p.join(extStorDir.path, 'temp');
    String list = '';
    for (int i = 0; i < layer.assets.length; i++) {
      list += "file '${p.join(tempPath, "v" + i.toString() + ".mp4")}'\n";
    }
    File file = await File(p.join(tempPath, 'list.txt')).writeAsString(list);
    return file.path;
  }

  _deleteTempDir() async {
    print('_deleteTempDir()');
    final Directory extStorDir = await getExternalStorageDirectory();
    String tempPath = p.join(extStorDir.path, 'temp');
    await Directory(tempPath).delete(recursive: true);
  }

  executeCommand(
    String arguments, {
    String outputPath,
    int fileNum,
    int totalFiles,
    bool finished = false,
  }) {
    final completer = new Completer<String>();
    DateTime initTime = DateTime.now();

    _flutterFFmpeg.enableStatisticsCallback((int time,
        int size,
        double bitrate,
        double speed,
        int videoFrameNumber,
        double videoQuality,
        double videoFps) {
      _ffmepegStat.add(FFmpegStat(
        time: time,
        size: size,
        bitrate: bitrate,
        speed: speed,
        videoFrameNumber: videoFrameNumber,
        videoQuality: videoQuality,
        videoFps: videoFps,
        timeElapsed: DateTime.now().difference(initTime).inMilliseconds,
        fileNum: fileNum,
        totalFiles: totalFiles,
      ));
    });

    _flutterFFmpeg.enableStatistics();

    _flutterFFmpeg.execute(arguments).then((int rc) async {
      if (rc == 0) {
        ffmepegStat.finished = finished;
        ffmepegStat.outputPath = outputPath;
        _ffmepegStat.add(ffmepegStat);
        Duration diffTime = DateTime.now().difference(initTime);
        logger.i('Generator.executeCommand() $diffTime)');
        completer.complete(outputPath);
      } else if (rc != 255) {
        ffmepegStat.error = true;
        _ffmepegStat.add(ffmepegStat);
        _flutterFFmpeg.getLastCommandOutput().then((output) async {
          logger.e('Generator.executeCommand() $output');
        });
        completer.complete(null);
      } else {
        completer.complete(null);
      }
      ffmepegStat.time = 0;
      _flutterFFmpeg.resetStatistics();
      _flutterFFmpeg.disableStatistics();
    });

    return completer.future;
  }

  finishVideoGeneration() async {
    _ffmepegStat.add(FFmpegStat());
    await _flutterFFmpeg.cancel();
  }

  String _commandLogLevel(String level) => '-loglevel $level ';

  String _commandInputs(Layer layer) {
    if (layer.assets.isEmpty) return "";
    return layer.assets
        .map((asset) => _commandInput(asset.srcPath))
        .reduce((a, b) => a + b);
  }

  _commandInputForAudios(Layer layer) async {
    String arguments = '';
    for (int i = 0; i < layer.assets.length; i++) {
      arguments += _commandInput(layer.assets[i].srcPath);
    }
    return arguments;
  }

  String _commandInput(path) => ' -i "$path"';

  String _commandImageVideoFilters(
      Layer layer, int startIndex, VideoResolution videoResolution) {
    String arguments = "";
    for (var i = 0; i < layer.assets.length; i++) {
      arguments += '[${startIndex + i}:v]';
      arguments += _commandPadForAspectRatioFilter(videoResolution);
      if (layer.assets[i].type == AssetType.image) {
        arguments +=
            _commandKenBurnsEffectFilter(videoResolution, layer.assets[i]);
      } else if (layer.assets[i].type == AssetType.video) {
        arguments += _commandTrimFilter(layer.assets[i], false);
      }
      arguments += _commandScaleFilter(videoResolution);
      arguments += 'copy[v${startIndex + i}];';
      if (layer.assets[i].type == AssetType.video) {
        arguments += _commandTrimFilter(layer.assets[i], true);
        arguments += 'acopy[adio${startIndex + i}];';
      }
    }
    return arguments;
  }

  String _commandAudioFilters(Layer layer, int startIndex) {
    String arguments = "";
    for (var i = 0; i < layer.assets.length; i++) {
      arguments += '[${startIndex + i}:a]' +
          _commandTrimFilter(layer.assets[i], true) +
          'acopy[au${startIndex + i}];';
    }
    return arguments;
  }

  String _commandAudioAmix(BuildContext context, bool isNoVideoSound) {
    // String arguments = "[au][a]amix=inputs=2[amx];";
    // double audioVolume = context.read<VoumeTracker>().audioVolume;
    // double videoVolume = context.read<VoumeTracker>().videoVolume;

    // String arguments = "[au][a]amix=inputs=2 :weights=0.25 1 [amx];";
    // String arguments =
    //     "[au][a]amix=inputs=2 :weights=$audioVolume $videoVolume:duration=first:dropout_transition=0 [amx];";
    if (isNoVideoSound) {
      String arguments =
          "[a] volume=${VolumeVariables.isMute ? 0.0 : VolumeVariables.videoVolume}[a]; [a]amix=inputs=1:dropout_transition=0 [amx];";
      return arguments;
    } else {
      String arguments =
          "[au] volume=${VolumeVariables.audioVolume}[au];[a]volume=${VolumeVariables.isMute ? 0.0 : VolumeVariables.videoVolume}[a]; [au][a]amix=inputs=2:duration=first:dropout_transition=0 [amx];";
      return arguments;
    }
  }

  String _commandTrimFilter(Asset asset, bool audio) =>
      '${audio ? "a" : ""}trim=${asset.cutFrom / 1000}' +
      ':${(asset.cutFrom + asset.duration) / 1000},' +
      '${audio ? "a" : ""}setpts=PTS-STARTPTS,';

  String _commandPadForAspectRatioFilter(VideoResolution videoResolution) {
    VideoResolutionSize size = _videoResolutionSize(videoResolution);
    return "pad=w='max(ceil(ceil(ih/2)*2/${size.height / size.width}/2)*2,ceil(iw/2)*2)':" +
        "h='max(ceil(ceil(iw/2)*2*${size.height / size.width}/2)*2,ceil(ih/2)*2)':" +
        "x=(ow-iw)/2:y=(oh-ih)/2,";
  }

  // String _commandScaleFilter(VideoResolution videoResolution) {
  //   VideoResolutionSize size = _videoResolutionSize(videoResolution);
  //   return 'scale=${size.width}:${size.height}:force_original_aspect_ratio=increase, crop=${size.width}:${size.height},setsar=1,';
  // }

  // String _commandPadForAspectRatioFilter(VideoResolution videoResolution) {
  //   VideoResolutionSize size = _videoResolutionSize(videoResolution);
  //   return "pad='max(iw,ih)':ow:'(ow-iw)/2':'(oh-ih)/2':color=black,";
  // }

  // String _commandScaleFilter(VideoResolution videoResolution) {
  //   VideoResolutionSize size = _videoResolutionSize(videoResolution);
  //   return "scale=${size.height}:${size.width}:force_original_aspect_ratio=increase,crop=${size.height}:${size.width},";
  // }

  String _commandScaleFilter(VideoResolution videoResolution) {
    VideoResolutionSize size = _videoResolutionSize(videoResolution);
    return "scale=${size.height}:${size.width}:force_original_aspect_ratio=increase,crop=${size.height}:${size.width},setsar=1,";
  }

  VideoResolutionSize _videoResolutionSize(VideoResolution videoResolution) {
    switch (videoResolution) {
      case VideoResolution.fullHd:
        return VideoResolutionSize(width: 1920, height: 1080);
      case VideoResolution.hd:
        return VideoResolutionSize(width: 1280, height: 720);
      case VideoResolution.mini:
        return VideoResolutionSize(width: 64, height: 36);
      default:
        return VideoResolutionSize(width: 640, height: 360);
    }
  }

  String videoResolutionString(VideoResolution videoResolution) {
    switch (videoResolution) {
      case VideoResolution.fullHd:
        return 'Full HD 1080px';
      case VideoResolution.hd:
        return 'HD 720px';
      case VideoResolution.mini:
        return 'Thumbnail 36px';
      default:
        return 'SD 360px';
    }
  }

  String _commandKenBurnsEffectFilter(
      VideoResolution videoResolution, Asset asset) {
    VideoResolutionSize size = _videoResolutionSize(videoResolution);
    // Default framerate 25 in zoompan
    double d = asset.duration / 1000 * 25;
    String s = "${size.width}x${size.height}";
    // Zoom 20%
    String x = asset.kenBurnZSign != 0
        ? "'${asset.kenBurnXTarget}*(iw-iw/zoom)'"
        : (asset.kenBurnXTarget == 1
            ? "'(${asset.kenBurnXTarget}-on/$d)*(iw-iw/zoom)'"
            : (asset.kenBurnXTarget == 0
                ? "'on/$d*(iw-iw/zoom)'"
                : "'(iw-iw/zoom)/2'"));
    String y = asset.kenBurnZSign != 0
        ? "'${asset.kenBurnYTarget}*(ih-ih/zoom)'"
        : (asset.kenBurnYTarget == 1
            ? "'(${asset.kenBurnYTarget}-on/$d)*(ih-ih/zoom)'"
            : (asset.kenBurnYTarget == 0
                ? "'on/$d*(ih-ih/zoom)'"
                : "'(ih-ih/zoom)/2'"));
    return "zoompan=d=$d:s=$s:x=$x:y=$y,";
  }

  // String _commandKenBurnsEffectFilter(
  //     VideoResolution videoResolution, Asset asset) {
  //   VideoResolutionSize size = _videoResolutionSize(videoResolution);
  //   // Default framerate 25 in zoompan
  //   double d = asset.duration / 1000 * 25;
  //   String s = "${size.width}x${size.height}";
  //   // Zoom 20%
  //   String z = asset.kenBurnZSign == 1
  //       ? "'zoom+${0.2 / d}'"
  //       : (asset.kenBurnZSign == -1
  //           ? "'if(eq(on,1),1.2,zoom-${0.2 / d})'"
  //           : "1.2");
  //   String x = asset.kenBurnZSign != 0
  //       ? "'${asset.kenBurnXTarget}*(iw-iw/zoom)'"
  //       : (asset.kenBurnXTarget == 1
  //           ? "'(${asset.kenBurnXTarget}-on/$d)*(iw-iw/zoom)'"
  //           : (asset.kenBurnXTarget == 0
  //               ? "'on/$d*(iw-iw/zoom)'"
  //               : "'(iw-iw/zoom)/2'"));
  //   String y = asset.kenBurnZSign != 0
  //       ? "'${asset.kenBurnYTarget}*(ih-ih/zoom)'"
  //       : (asset.kenBurnYTarget == 1
  //           ? "'(${asset.kenBurnYTarget}-on/$d)*(ih-ih/zoom)'"
  //           : (asset.kenBurnYTarget == 0
  //               ? "'on/$d*(ih-ih/zoom)'"
  //               : "'(ih-ih/zoom)/2'"));
  //   return "zoompan=d=$d:s=$s:z=$z:x=$x:y=$y,";
  // }

  String _commandConcatenateVideoStreamsWithoutAudio(
      Layer layer, int startIndex) {
    String arguments = "";
    // Concatenation
    // - n: Set the number of segments. Default is 2.
    // - v: Set the number of output video streams. Default is 1.
    // - a: Set the number of output audio streams. Default is 0.
    for (var i = startIndex; i < startIndex + layer.assets.length; i++) {
      // arguments += '["v"$i][$i:"a"]';
      arguments += '["v"$i]';
    }
    if (layer.assets.length > 0) {
      arguments +=
          // 'concat=n=${layer.assets.length}' + ':v=1:a=1' + '["vprev"] ["a"];';
          'concat=n=${layer.assets.length}' + ':v=1:a=0' + '["vprev"];';
    }
    return arguments;
  }

  // String _commandConcatenateVideoStreamsWithAudio(
  //     Layer layer, int startIndex, bool isAudio, BuildContext context) {
  //   String arguments = "";
  //   // Concatenation
  //   // - n: Set the number of segments. Default is 2.
  //   // - v: Set the number of output video streams. Default is 1.
  //   // - a: Set the number of output audio streams. Default is 0.
  //   for (var i = startIndex; i < startIndex + layer.assets.length; i++) {
  //     arguments += '["v"$i]';
  //     //Try taking the audios from the layer[0] separtely and then concat them

  //   }
  //   if (layer.assets.length > 0) {
  //     arguments +=
  //         'concat=n=${layer.assets.length}' + ':v=1:a=0' + '["vprev"];';
  //   }
  //   arguments +=
  //       _commandConcatenateAudioStreamsOnly(layer, startIndex, context);
  //   if (_commandConcatenateAudioStreamsOnly(layer, startIndex, context) != '') {
  //     arguments += _commandAudioAmix(context, false);
  //   } else {
  //     arguments += _commandAudioAmix(context, true);
  //   }

  //   return arguments;
  // }

  // String _commandConcatenateAudioStreamsOnly(
  //     Layer layer, int startIndex, BuildContext context) {
  //   String arguments = "";
  //   int vale = 0;
  //   for (var i = startIndex; i < startIndex + layer.assets.length; i++) {
  //     if (layer.assets[i].type == AssetType.video) {
  //       arguments += '[$i:"a"]';
  //       vale++;
  //     }

  //     //Try taking the audios from the layer[0] separtely and then concat them

  //   }
  //   if (vale > 0) {
  //     arguments += 'concat=n=$vale' + ':v=0:a=1' + '["a"];';
  //   }
  //   return arguments;
  // }

  String _commandConcatenateVideoStreamsWithAudio(Layer layer, int startIndex,
      bool isAudio, BuildContext context, Layer layers) {
    String arguments = "";
    // Concatenation
    // - n: Set the number of segments. Default is 2.
    // - v: Set the number of output video streams. Default is 1.
    // - a: Set the number of output audio streams. Default is 0.
    for (var i = startIndex; i < startIndex + layer.assets.length; i++) {
      if (layer.assets[i].type == AssetType.video) {
        arguments += '["v"$i][adio$i]';
      } else {
        arguments += '["v"$i][${layer.assets.length}:"a"]';
        //Try taking the audios from the layer[0] separtely and then concat them
      }
    }
    if (layer.assets.length > 0) {
      arguments +=
          'concat=n=${layer.assets.length}' + ':v=1:a=1' + '["vprev"] ["a"];';
    }
    if (layers.assets.length > 0) {
      arguments += _commandAudioAmix(context, false);
    } else {
      arguments += _commandAudioAmix(context, true);
    }

    return arguments;
  }

  String _commandConcatenateVideoStreamsWithItsAudio(
      Layer layer, int startIndex) {
    String arguments = "";
    // Concatenation
    // - n: Set the number of segments. Default is 2.
    // - v: Set the number of output video streams. Default is 1.
    // - a: Set the number of output audio streams. Default is 0.
    for (var i = startIndex; i < startIndex + layer.assets.length; i++) {
      arguments += '["v"$i][$i:"a"]';
    }
    if (layer.assets.length > 0) {
      arguments +=
          'concat=n=${layer.assets.length}' + ':v=1:a=1' + '["vprev"] ["a"];';
    }
    return arguments;
  }

  String _commandConcatenateStreams(Layer layer, int startIndex, bool isAudio) {
    String arguments = "";
    // Concatenation
    // - n: Set the number of segments. Default is 2.
    // - v: Set the number of output video streams. Default is 1.
    // - a: Set the number of output audio streams. Default is 0.
    for (var i = startIndex; i < startIndex + layer.assets.length; i++) {
      arguments += '[${isAudio ? "au" : "v"}$i]';
    }
    if (layer.assets.length > 0) {
      arguments += 'concat=n=${layer.assets.length}' +
          ':v=${isAudio ? 0 : 1}:a=${isAudio ? 1 : 0}' +
          '[${isAudio ? "au" : "vprev"}];';
    }
    return arguments;
  }

  _commandTextAssets(Layer layer, VideoResolution videoResolution) async {
    // String arguments = '[0:v]';
    String arguments = '[vprev]';
    for (int i = 0; i < layer.assets.length; i++) {
      if (layer.assets[i].title != '') {
        arguments += await _commandDrawText(layer.assets[i], videoResolution);
      }
    }
    arguments += 'copy[v];';
    return arguments;
  }

  // _commandDrawText(Asset asset, VideoResolution videoResolution) async {
  //   String fontFile = await _getFontPath(asset.font);
  //   String fontColor = '0x' + asset.fontColor.toRadixString(16).substring(2);
  //   VideoResolutionSize size = _videoResolutionSize(videoResolution);

  //   return "drawtext=" +
  //       "enable='between(t,${asset.begin / 1000},${(asset.begin + asset.duration) / 1000})':" +
  //       "x=${asset.x * size.width}:y=${asset.y * size.height}:" +
  //       "fontfile=$fontFile:fontsize=${asset.fontSize * size.width}:" +
  //       "fontcolor=$fontColor:alpha=${asset.alpha}:" +
  //       "borderw=${asset.borderw}:bordercolor=${colorStr(asset.bordercolor)}:" +
  //       "shadowcolor=${colorStr(asset.shadowcolor)}:shadowx=${asset.shadowx}:shadowy=${asset.shadowy}:" +
  //       "box=${asset.box ? 1 : 1}:boxborderw=${asset.boxborderw}:boxcolor=${colorStr(asset.boxcolor)}:" +
  //       "line_spacing=0:" +
  //       "text='${asset.title}',";
  // }

  _commandDrawText(Asset asset, VideoResolution videoResolution) async {
    String fontFile = await _getFontPath(asset.font);
    String fontColor = '0x' + asset.fontColor.toRadixString(16).substring(2);
    double fadeInStartTime = asset.begin / 1000;
    double fadeInDuration = 1 / 3;
    double textDuration = asset.duration / 1000;
    double fadeOutDuration = 2;

    return "drawtext=" +
        "text_shaping=1:" +
        "enable='between(t,${asset.begin / 1000},${(asset.begin + asset.duration) / 1000})':" +
        // "enable='if(lt(t,${asset.begin / 1000}),0,if(lt(t,${2 + (asset.begin / 1000)}),(t-1)/${((asset.duration) / 1000)},if(lt(t,${2 + (asset.begin / 1000) + ((asset.duration) / 1000)}),1,if(lt(t,${4 + (asset.begin / 1000) + ((asset.duration) / 1000)}),(1-(t-${2 + (asset.begin / 1000) + ((asset.duration) / 1000)}))/1,0))))':" +
        //"x='(w-text_w)/2':y='if(lt(t\,3)\,(-h+((3*h-200)*t/6))\,(h-200)/2)':" +
        "x='(${asset.x}*w)':y='(${asset.y}*h)':" +
        // "x=${asset.x * size.width}:y=${asset.y * size.height}:" +

        "fontfile=$fontFile:fontsize='(${asset.fontSize}*w)':" +
        // "fontfile=$fontFile:fontsize=${asset.fontSize * size.width}:" +
        "fontcolor=$fontColor:alpha='if(lt(t,$fadeInStartTime),0,if(lt(t,${fadeInStartTime + fadeInDuration}),(t-$fadeInStartTime)/$fadeInDuration,if(lt(t,${fadeInStartTime + fadeInDuration + textDuration}),1,if(lt(t,${fadeInStartTime + fadeInDuration + fadeOutDuration + textDuration}),($fadeOutDuration-(t-${fadeInStartTime + fadeInDuration + fadeOutDuration + textDuration}))/$fadeOutDuration,0))))':" +
        // "fontcolor=$fontColor:alpha=${asset.alpha}:" +
        "borderw=${asset.borderw}:bordercolor=${colorStr(asset.bordercolor)}:" +
        "shadowcolor=${colorStr(asset.shadowcolor)}:shadowx=${asset.shadowx}:shadowy=${asset.shadowy}:" +
        "box=${asset.box ? 1 : 1}:boxborderw=${asset.boxborderw}:boxcolor=${colorStr(asset.boxcolor)}:" +
        "line_spacing=0:" +
        "text='${asset.title}',";
  }

  colorStr(int colorInt) {
    String colorStr = colorInt.toRadixString(16).padLeft(8, '0');
    String newColorStr = colorStr.substring(2) + colorStr.substring(0, 2);
    return '0x$newColorStr';
  }

  // Formats: https://ffmpeg.org/ffmpeg-formats.html
  String _commandCodecsAndFormat(CodecsAndFormat codecsAndFormat) {
    switch (codecsAndFormat) {
      // libvpx-vp9 https://trac.ffmpeg.org/wiki/Encode/VP9 (LGPL)
      // libvpx-vp9 has a lossless encoding mode that can be activated using -lossless 1
      // Opus, for VP9 https://trac.ffmpeg.org/wiki/Encode/HighQualityAudio
      case CodecsAndFormat.VP9OpusWebm:
        return ' -c:v libvpx-vp9 -lossless 1 -c:a opus -f webm';
      // libx264 https://trac.ffmpeg.org/wiki/Encode/H.264 (GPL, not included)
      // Native encoder aac https://trac.ffmpeg.org/wiki/Encode/AAC
      case CodecsAndFormat.H264AacMp4:
        return ' -c:v libx264 -c:a aac -pix_fmt yuva420p -f mp4';
      // libxvid https://trac.ffmpeg.org/wiki/Encode/MPEG-4 (GPL, not included)
      case CodecsAndFormat.Xvid:
        return ' -c:v libxvid -c:a aac -f avi';
      // Native encoder mpeg4 https://trac.ffmpeg.org/wiki/Encode/MPEG-4 (LGPL)
      // qscale: 1 highest quality/largest filesize, 31 lowest quality/smallest filesize
      default:
        return ' -c:v mpeg4 -qscale:v 1 -c:a aac -f mp4';
    }
  }

  //String _commandFrameRate(int frameRate) => ' -r $frameRate';
  String _commandOutputFile({String path, bool withAudio, bool overwrite}) =>
      ' -map "[v]" ${withAudio ? "-map \"[amx]\"" : "-map \"[a]\""} ${overwrite ? "-y" : ""} $path';

  String _commandOutputFileForBothAudios({String path}) =>
      ' -map "[v]" ${"-map \"[amx]\""} "-y"  $path';
  String _commandOutputFileForMusicAudio({String path}) =>
      ' -map "[v]" ${"-map \"[au]\""} "-y" $path';
  String _commandOutputFileForVideoAudio({String path}) =>
      ' -map "[v]" ${"-map \"[a]\""} "-y" $path';

  String dateTimeString(DateTime dateTime) {
    return '${dateTime.year.toString().padLeft(4, "0")}' +
        '${dateTime.month.toString().padLeft(2, "0")}' +
        '${dateTime.day.toString().padLeft(2, "0")}' +
        '_${dateTime.hour.toString().padLeft(2, "0")}' +
        '${dateTime.minute.toString().padLeft(2, "0")}' +
        '${dateTime.second.toString().padLeft(2, "0")}';
  }

  _getFontPath(String relativePath) async {
    const String rootFontsPath = 'packages/open_director/fonts';
    final ByteData fontFile =
        await rootBundle.load(p.join(rootFontsPath, relativePath));
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String fontPath =
        p.join(appDocDir.parent.path, rootFontsPath, relativePath);
    File(fontPath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fontFile.buffer
          .asUint8List(fontFile.offsetInBytes, fontFile.lengthInBytes));
    return fontPath;
  }
}

enum VideoResolution {
  sd,
  hd,
  fullHd,
  mini,
}

enum CodecsAndFormat {
  Mpeg4,
  Xvid,
  H264AacMp4,
  VP9OpusWebm,
}

class VideoResolutionSize {
  int width;
  int height;
  VideoResolutionSize({@required this.width, @required this.height});
}

class FFmpegStat {
  int time;
  int size;
  double bitrate;
  double speed;
  int videoFrameNumber;
  double videoQuality;
  double videoFps;
  bool finished = false;
  String outputPath;
  bool error = false;
  int timeElapsed;
  int fileNum;
  int totalFiles;

  FFmpegStat({
    this.time = 0,
    this.size = 0,
    this.bitrate = 0,
    this.speed = 0,
    this.videoFrameNumber = 0,
    this.videoQuality = 0,
    this.videoFps = 0,
    this.outputPath,
    this.timeElapsed = 0,
    this.fileNum,
    this.totalFiles,
  });
}
