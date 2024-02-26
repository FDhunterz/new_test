import 'package:flutter/material.dart';

currencyFormat({required String data, required TextEditingController controller}) {
  int getLength = data.replaceAll('.', '').length;
  data = data.replaceAll('.', '');
  int tousand = 0;
  String build = '';

  while (getLength > 3) {
    getLength -= 3;
    ++tousand;
    if (tousand == 1) {
      build = data.substring(getLength, getLength + 3) + build;
    } else {
      build = data.substring(getLength, getLength + 3) + '.' + build;
    }
  }
  if (data.length < 4) {
    build = data;
  } else {
    build = data.substring(0, getLength) + '.' + build;
  }
  controller.text = build;
  controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
}

String intToCurrency(int data) {
  int getLength = data.toString().length;
  String parseData = data.toString();
  int tousand = 0;
  String build = '';

  while (getLength > 3) {
    getLength -= 3;
    ++tousand;
    if (tousand == 1) {
      build = parseData.substring(getLength, getLength + 3) + build;
    } else {
      build = parseData.substring(getLength, getLength + 3) + '.' + build;
    }
  }
  if (parseData.length < 4) {
    build = parseData;
  } else {
    build = parseData.substring(0, getLength) + '.' + build;
  }
  return build;
}
