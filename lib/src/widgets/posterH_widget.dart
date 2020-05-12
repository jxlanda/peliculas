import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/pelicula_provider.dart';

class PosterHorizontal extends StatelessWidget {
  final List<Result> peliculasData;
  final ScrollController controllerScroll;
  final PeliculaProvider providerPeliculas;
  final Stream<List<Result>> streamPeliculas;
  final String titulo;

  const PosterHorizontal({
    Key key, 
    @required this.titulo,
    @required this.controllerScroll,
    @required this.peliculasData,
    @required this.providerPeliculas,
    @required this.streamPeliculas
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "$titulo",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.arrow_forward)
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: 200.0,
              child: StreamBuilder(
                stream: streamPeliculas,
                builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapShot) {
                  if (snapShot.hasData){
                    return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  controller: controllerScroll,
                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                                  itemBuilder: (BuildContext context, int index) {
                                    snapShot.data[index].uniqueId = "${snapShot.data[index].id}-$titulo";
                                    return GestureDetector(
                                        onTap: (){
                                          Navigator.pushNamed(context, "detalle", arguments: snapShot.data[index]);
                                        },
                                        child: Padding(
                                        padding: const EdgeInsets.only(right: 10.0),
                                        child: Hero(
                                          tag: snapShot.data[index].uniqueId,
                                                child: Card(
                                                elevation: 2,
                                                clipBehavior: Clip.antiAlias,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                                child: CachedNetworkImage(
                                                  imageUrl: providerPeliculas.getPeliculaImage(snapShot.data[index].posterPath),
                                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                      Padding(
                                                        padding: const EdgeInsets.all(40.0),
                                                        child: Center( child: CircularProgressIndicator()),
                                                      ),
                                                  errorWidget: (context, url, error) => Image.asset("assets/no-image.jpg"),
                                                  fit: BoxFit.fill,
                                                )
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: snapShot.data.length,
                    );
                  }
                  else
                    return Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                },
              )
              ),
        ],
      ),
    );
  }
}


