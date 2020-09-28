import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/climate/presentaion/bloc/climate_bloc.dart';
import 'features/climate/presentaion/pages/home_page.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //Because i run await in main function
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climate',
      theme: ThemeData(
        primaryColor: Colors.teal.shade800,
        accentColor: Colors.teal.shade400,
      ),
      home: HomePage(),
    );
  }
}
