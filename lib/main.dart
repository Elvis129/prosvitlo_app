import 'package:flutter/material.dart';
import 'core/bootstrap.dart';
import 'app.dart';

void main() async {
  final firebaseStatus = await bootstrap();
  runApp(LightOutageApp(firebaseStatus: firebaseStatus));
}
