import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:this_is_a_to_do_app/pages/authentication/sign_in_widget.dart';
import 'model/events/event_provider.dart';
import 'model/tasks/task_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Orientation Lock
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'this is a to do app',
        home: SignInWidget(),
      ),
    );
  }
}