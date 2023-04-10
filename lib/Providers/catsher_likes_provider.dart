import 'package:flutter/material.dart';

class CatSherLikesProvider extends ChangeNotifier {
  final Map _likes = {};

  get likes => _likes;

  void add(Map like) {
    _likes.addAll(like);
    notifyListeners();
  }

  void remove(Map like) {
    _likes.remove(like.keys.first);
    notifyListeners();
  }
}
