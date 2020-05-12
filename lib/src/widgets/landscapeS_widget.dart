import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/pelicula_provider.dart';

class LandscapeSwiper extends StatelessWidget {
  final PeliculaProvider peliculasProvider;
  final List<Result> peliculasData;

  const LandscapeSwiper(
      {Key key, @required this.peliculasData, @required this.peliculasProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determinar el tamano de la pantalla
    final _screenSize = MediaQuery.of(context).size;
    print("Landscape Swiper...");
    return FutureBuilder(
        future: peliculasProvider.getNowPlaying(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapShot) {
          if (snapShot.hasData)
            return Container(
                padding: EdgeInsets.only(top: 10.0),
                width: _screenSize.width,
                height: _screenSize.height * 0.25,
                child: new Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return ImageSwiper(
                          peliculas: snapShot.data,
                          index: index,
                          peliculaProvider: peliculasProvider);
                    },
                    itemCount: snapShot.data.length,
                    viewportFraction: 0.9,
                    scale: 1));
          else
            return Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Center(child: CircularProgressIndicator()),
            );
        });
  }
}

class ImageSwiper extends StatelessWidget {
  final PeliculaProvider peliculaProvider;
  final int index;
  final List<Result> peliculas;
  const ImageSwiper(
      {Key key,
      @required this.peliculas,
      @required this.index,
      @required this.peliculaProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Para el hero animation
    peliculas[index].uniqueId = "${peliculas[index].id}-landscapeS";
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "detalle", arguments: peliculas[index]);
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                  imageUrl: peliculaProvider
                      .getPeliculaImage(peliculas[index].backdropPath),
                  progressIndicatorBuilder:
                      (context, url, downloadProgress) => Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) =>
                      Image.asset("assets/no-image.jpg"),
                  fit: BoxFit.fill,
                    )),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.15,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: Colors.black45,
            ),
            child: Text(
              "${peliculas[index].title}",
              style: TextStyle(color: Colors.white, fontSize: 23),
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    );
  }
}
