import 'package:agos/utils/colors.dart';
import 'package:agos/widgets/text_widget.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget AppbarWidget(String title) {
  return AppBar(
    centerTitle: true,
    foregroundColor: primary,
    backgroundColor: Colors.white,
    title: TextRegular(text: title, fontSize: 24, color: primary),
  );
}
