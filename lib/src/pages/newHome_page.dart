import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/pelicula_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/landscapeS_widget.dart';
import 'package:peliculas/src/widgets/posterH_widget.dart';

class NewHomePage extends StatefulWidget {
  NewHomePage({Key key}) : super(key: key);

  @override
  NewHomePageState createState() => NewHomePageState();
}

class NewHomePageState extends State<NewHomePage> {
  // Popular
  Stream<List<Result>> popularStream;
  List<Result> popularData = new List();
  ScrollController popularController = new ScrollController();
  PeliculaProvider popularProvider = new PeliculaProvider();
  String popularTitulo = "Populares";

  // Upcoming
  Stream<List<Result>> upcomingStream;
  List<Result> upcomingData = new List();
  ScrollController upcomingController = new ScrollController();
  PeliculaProvider upcomingProvider = new PeliculaProvider();
  String upcomingTitulo = "Por salir";

  // Landscape Swiper
  List<Result> landscapeData = new List();
  PeliculaProvider landscapeProvider = new PeliculaProvider();

  NewHomePageState();

  @override
  void initState() {
    super.initState();

    // POPULAR PROVIDER
    popularStream = popularProvider.popularStream;
    popularProvider.getPopular();
    popularController.addListener(() {
      if (popularController.offset >=
          popularController.position.maxScrollExtent) {
        popularProvider.getPopular();
      }
    });

    // UPCOMING PROVIDER
    upcomingStream = upcomingProvider.upcomingStream;
    upcomingProvider.getUpcoming();
    upcomingController.addListener(() {
      if (upcomingController.offset >=
          upcomingController.position.maxScrollExtent) {
        upcomingProvider.getUpcoming();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    popularController.dispose();
    upcomingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Películas",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          flexibleSpace: SafeArea(
              child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.menu, color: Colors.black),
                  onPressed: () {}),
              IconButton(
                icon: Icon(Icons.search, color: Colors.black),
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                },
              )
            ],
          ))),
      body: SingleChildScrollView(
          child: Column(
          children: <Widget>[
            LandscapeSwiper(peliculasData: landscapeData, peliculasProvider: landscapeProvider),
            SizedBox(height: 10.0),
            new PosterHorizontal(
              titulo: popularTitulo,
              peliculasData: popularData,
              providerPeliculas: popularProvider,
              controllerScroll: popularController,
              streamPeliculas: popularStream,
            ),
            new PosterHorizontal(
                titulo: upcomingTitulo,
                controllerScroll: upcomingController,
                peliculasData: upcomingData,
                providerPeliculas: upcomingProvider,
                streamPeliculas: upcomingStream)
          ],
        ),
      ),
    );
  }
}
