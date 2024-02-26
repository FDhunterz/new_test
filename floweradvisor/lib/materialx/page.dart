import 'package:flutter/material.dart';
import 'package:request_api_helper/global_env.dart';

class CurrentPage {
  static List<Widget?> page = [];
  static List<Function> activeController = [];

  static disposeAll() {
    activeController.map((e) => e());
  }

  static removeLastActive() {
    activeController.removeLast();
  }

  static add(Widget? widget) {
    if (widget != null) {
      if (page.isEmpty) {
        page.add(widget);
      } else if (page.last != widget) {
        page.add(widget);
      }
    }
  }

  static back() {
    try {
      page.removeLast();
    } catch (_) {}
    Navigator.pop(ENV.navigatorKey.currentContext!);
  }
}
