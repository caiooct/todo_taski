import 'package:flutter/material.dart';

class HomeViewModel extends ValueNotifier<int> {
  HomeViewModel() : super(0);

  void goToTab(int index) => value = index;
}
