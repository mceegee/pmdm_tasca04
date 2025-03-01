import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/providers/ui_provider.dart';
import 'package:qr_scan/screens/home_screen.dart';
import 'package:qr_scan/screens/mapa_screen.dart';

// MARTA CARBONELL GIMENEZ 
void main() {
  // https://stackoverflow.com/questions/53903928/disable-flutters-red-screen-of-death
  // Fondo per mostrar mentre es carrega la informació
  ErrorWidget.builder = (FlutterErrorDetails details) => Container(
    color: const Color.fromARGB(255, 197, 195, 195),
    child: Center(
    child: Icon(Icons.emoji_emotions_outlined, size: 50.0)),
  );
  return runApp(MultiProvider(
  providers: [
    ChangeNotifierProvider(create: ( _ ) => UiProvider()),
    ChangeNotifierProvider(create: ( _ ) => ScanListProvider())
  ],
  child: MyApp()));
}

// class AppState extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(providers: [
//     ChangeNotifierProvider(create: (_) => UiProvider()),
//   ],
//     child: MyApp());
//   }
  
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Reader',
      initialRoute: 'home',
      routes: {
        'home': (_) => HomeScreen(),
        'mapa': (_) => MapaScreen(),
      },
      theme: ThemeData(
        // No es pot emprar colorPrimary des de l'actualització de Flutter
        colorScheme: ColorScheme.light().copyWith(
          primary: Colors.deepPurple,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
        ),
      ),
    );
  }
}
