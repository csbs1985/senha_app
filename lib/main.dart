import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:senha_app/firebase_options.dart';
import 'package:senha_app/page/inicio_page.dart';
import 'package:senha_app/theme/ui_tema.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    UiTema.definirTema();
    super.initState();
  }

  @override
  void didChangePlatformBrightness() {
    UiTema.definirTema();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentTema,
      builder: (BuildContext context, Brightness tema, _) {
        bool isEscuro = tema == Brightness.dark;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const InicioPage(),
          theme: isEscuro ? UiTema.temaEscuro : UiTema.tema,
        );
      },
    );
  }
}
