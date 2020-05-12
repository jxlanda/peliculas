import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/pelicula_provider.dart';

class DataSearch extends SearchDelegate{

  String seleccion = "";
  List<String> peliculasRecientes = ["apple", "2", "3"];
  List<String> peliculas = ["apple","apple2","apple3"];

  final PeliculaProvider providerPeliculas = new PeliculaProvider();
  
  @override
  String get searchFieldLabel => 'Buscar';

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty? IconButton(
        tooltip: "Busqueda por voz", 
        icon: Icon(Icons.mic), 
        onPressed: (){}
      )
      :
      IconButton(
        tooltip: "Borrar busqueda", 
        icon: const Icon(Icons.clear), 
        onPressed: (){ 
          query = ""; 
        showSuggestions(context);
      }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: "Regresar",
      icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: (){
        this.close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(seleccion),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if(query.isEmpty) return SizedBox();
    else
    return FutureBuilder(
      future: providerPeliculas.getMovieById(query),
      builder: (BuildContext context, AsyncSnapshot<List<Result>> snapshot) {
        if(snapshot.hasData) {
          final peliculas = snapshot.data;
            return ListView(
              children: peliculas.map((pelicula){ 
                pelicula.uniqueId = "${pelicula.id}-search";
                  return ListTile(
                    leading: Hero(
                      tag: pelicula.uniqueId,
                        child: CachedNetworkImage(
                        imageUrl: providerPeliculas.getPeliculaImage(pelicula.posterPath),
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image.asset("assets/no-image.jpg"),
                        fit: BoxFit.fill
                      ),
                    ),
                    title: Text(pelicula.title),
                    subtitle: Text(pelicula.overview, overflow: TextOverflow.ellipsis),
                    onTap: (){
                      Navigator.pushNamed(context, "detalle", arguments: pelicula);
                    },
                  );
                }).toList()
            );
        }
        else return Center(child: CircularProgressIndicator());
      },
    );

    // NORMAL

    // final listaSugerida = (query.isEmpty) ? 
    //                       peliculasRecientes : 
    //                       peliculas.where((element) => 
    //                           element.toLowerCase().startsWith(query.toLowerCase())
    //                       ).toList();

    // return ListView.builder(
    // itemCount: listaSugerida.length,
    // itemBuilder: (context, i){
    //   return ListTile(
    //     leading: Icon(Icons.history),
    //     title: Text(listaSugerida[i]),
    //     onTap: (){
    //       seleccion = listaSugerida[i];
    //       showResults(context);
    //     },
    //   );
    //});
  }
  

}