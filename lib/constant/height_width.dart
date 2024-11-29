import 'package:flutter/material.dart';

double height(BuildContext context, double height) {
  return MediaQuery.of(context).size.height * height;
}

double width(BuildContext context, double width) {
  return MediaQuery.of(context).size.height * width;
}
