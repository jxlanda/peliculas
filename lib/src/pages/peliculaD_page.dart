import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/pelicula_provider.dart';
import 'package:peliculas/src/widgets/arcImage_widget.dart';
import 'package:peliculas/src/widgets/raiting_widget.dart';

class PeliculaDetallePage extends StatelessWidget {

  static final PeliculaProvider providerPeliculas = new PeliculaProvider();
  static const POSTER_RATIO = 0.7;
  

  const PeliculaDetallePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Result pelicula = ModalRoute.of(context).settings.arguments;
    var width = POSTER_RATIO * 180.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 140.0),
                  child: ArcImage( imageUrl: providerPeliculas.getPeliculaImage(pelicula.backdropPath)),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 16.0,
                  right: 16.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Hero(
                        tag: pelicula.uniqueId,
                        child: Card(
                          elevation: 0,
                          clipBehavior: Clip.antiAlias,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                  imageUrl: providerPeliculas.getPeliculaImage(pelicula.posterPath),
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  Padding(
                                        padding: const EdgeInsets.all(40.0),
                                        child: Center( child: CircularProgressIndicator()),
                                  ),
                                  errorWidget: (context, url, error) => Image.asset("assets/no-image.jpg", width: width, height: 180.0),
                                  fit: BoxFit.fill,
                                  width: width,
                                  height: 180.0,
                              )
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 18.0),
                      Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    pelicula.title,
                                    style: (pelicula.title.length > 30)? TextStyle(fontSize: 21, fontWeight: FontWeight.bold): TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                  SizedBox(height: 10.0),
                                  RaitingInformation(pelicula: pelicula),
                                  SizedBox(height: 8.0)
                                ],
                      )
                      )
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: _Overview(storyline: pelicula.overview),
            ),
            FutureBuilder(
              future: providerPeliculas.getActores(pelicula.id.toString()),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot.data == null) return Center(child: CircularProgressIndicator());
                else return _Actores(actores: snapshot.data, providerPeliculas: providerPeliculas);
              },
            ),
          ],
        ),
      ),
    );
  }
}


class _Overview extends StatelessWidget {
  final String storyline;
  const _Overview({Key key, @required this.storyline}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumen',
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(height: 8.0),
        Text(
          storyline,
          textAlign: TextAlign.justify,
          style: textTheme.bodyText1.copyWith(
            color: Colors.black45,
            fontSize: 16.0,
          ),
        )
      ],
    );
  }
}

class _Actores extends StatelessWidget {

  final List<Cast> actores;
  final PeliculaProvider providerPeliculas;

  const _Actores({Key key, @required this.actores, @required this.providerPeliculas}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Actores',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        SizedBox.fromSize(
          size: const Size.fromHeight(120.0),
          child: ListView.builder(
            itemCount: actores.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 12.0, left: 20.0),
            itemBuilder: _buildActor,
          ),
        ),
        SizedBox(height: 10.0)
      ],
    );
  }

  Widget _buildActor(BuildContext ctx, int index) {
    var actor = actores[index];
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(providerPeliculas.getPeliculaImage(actor.profilePath)),
            radius: 40.0,
            onBackgroundImageError: (exception, stackTrace) => print("Error"),
            backgroundColor: Colors.red[600],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(actor.name, style: TextStyle(color: Colors.black87),),
          ),
        ],
      ),
    );
  }
}