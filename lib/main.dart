import 'package:flutter/material.dart';
import 'package:peliculas/src/pages/newHome_page.dart';
import 'package:peliculas/src/pages/peliculaD_page.dart';
// importm te importa material.dart
// mateapp te crea el main 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Películas",
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => NewHomePage(),
        "detalle": (BuildContext context) => PeliculaDetallePage()
      },
    );
  }
}