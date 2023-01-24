import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stories_editor/src/domain/models/painting_model.dart';
import 'package:stories_editor/src/presentation/utils/constants/app_enums.dart';

class PaintingNotifier extends ChangeNotifier {
  /// here all line Paths will be save
  List<PaintingModel> _lines = <PaintingModel>[];

  /// color index
  int _lineColor = 0;

  String _fullImageViewUrl = '';

  int _fullImageViewIndex = -1;

  String _fullImageViewDownloadLink = '';

  /// line width
  double _lineWidth = 10;

  // image opacity
  double _imageOpacity = 100;

  /// tool index
  int _selectedToolIndex = 0;

  bool _dowloadTaskStatus = false;

  /// painter type
  PaintingType _paintingType = PaintingType.pen;

  /// listen all draw lines
  StreamController<List<PaintingModel>> _linesStreamController =
      StreamController<List<PaintingModel>>.broadcast();

  /// listen pan gesture events
  StreamController<PaintingModel> _currentLineStreamController =
      StreamController<PaintingModel>.broadcast();

  List<PaintingModel> get lines => _lines;
  int get lineColor => _lineColor;

  double get lineWidth => _lineWidth;
  double get imageOpacity => _imageOpacity;
  String get fullImageViewUrl => _fullImageViewUrl;
  int get fullImageViewIndex => _fullImageViewIndex;
  String get fullImageViewDownloadLink => _fullImageViewDownloadLink;
  bool get dowloadTaskStatus => _dowloadTaskStatus;
  int get selectedToolIndex => _selectedToolIndex;
  StreamController<List<PaintingModel>> get linesStreamController =>
      _linesStreamController;
  StreamController<PaintingModel> get currentLineStreamController =>
      _currentLineStreamController;
  PaintingType get paintingType => _paintingType;

  set lines(List<PaintingModel> line) {
    _lines = line;
    notifyListeners();
  }

  set itemLine(List<Widget> item) {
    notifyListeners();
  }

  set lineColor(int color) {
    _lineColor = color;
    notifyListeners();
  }

  set imageOpacity(double opacity) {
    _imageOpacity = opacity;
    notifyListeners();
  }

  set lineWidth(double width) {
    _lineWidth = width;
    notifyListeners();
  }

  set fullImageViewUrl(String url) {
    _fullImageViewUrl = url;
    notifyListeners();
  }

  set fullImageViewDownloadLink(String url) {
    _fullImageViewDownloadLink = url;
    notifyListeners();
  }

  set fullImageViewIndex(int ind) {
    _fullImageViewIndex = ind;
    notifyListeners();
  }

  set dowloadTaskStatus(bool stat) {
    _dowloadTaskStatus = stat;
    notifyListeners();
  }

  set selectedToolIndex(int index) {
    _selectedToolIndex = index;
    notifyListeners();
  }

  set linesStreamController(StreamController<List<PaintingModel>> _stream) {
    _linesStreamController = _stream;
    notifyListeners();
  }

  set currentLineStreamController(StreamController<PaintingModel> _stream) {
    _currentLineStreamController = _stream;
    notifyListeners();
  }

  set paintingType(PaintingType type) {
    _paintingType = type;
    notifyListeners();
  }

  clearAll() {
    _lines = [];
    notifyListeners();
  }

  removeLast() {
    if (_lines.isNotEmpty) {
      _lines.removeLast();
      notifyListeners();
    } else {
      _lines = [];
      notifyListeners();
    }
  }

  resetDefaults() {
    _lineWidth = 10;
    _lineColor = 0;
    _paintingType = PaintingType.pen;
    notifyListeners();
  }

  closeConnection() {
    _currentLineStreamController.close();
    _linesStreamController.close();
  }
}
