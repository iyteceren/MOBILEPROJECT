import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'di.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const BudgetBuildApp());
}
