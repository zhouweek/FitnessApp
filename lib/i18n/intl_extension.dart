import 'package:flutter/material.dart';
import 'localization.dart';

extension IntlExtension on String {
  String intl(BuildContext context) {
    return Localization.of(context).translate(this);
  }
}
