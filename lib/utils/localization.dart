import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moa_app/generated/l10n.dart' show S;

S localization(BuildContext context) => S.of(context);

String t(String messageText) => Intl.message(messageText).toString();
