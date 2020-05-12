import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class RaitingInformation extends StatelessWidget {

  final Result pelicula;
  const RaitingInformation({Key key, this.pelicula}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var ratingCaptionStyle = textTheme.caption.copyWith(color: Colors.grey[600]);
    var numericRating = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          pelicula.voteAverage.toString(),
          style: textTheme.subtitle1.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          )
        ),
        SizedBox(height: 4.0),
        Text(
          'Promedio',
          style: ratingCaptionStyle,
        ),
      ],
    );
    var starRating = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRatingBar(theme),
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 4.0),
          child: Text(
            'Estrellas',
            style: ratingCaptionStyle,
          ),
        ),
      ],
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        numericRating,
        SizedBox(width: 16.0),
        starRating,
      ],
    );
  }

  Widget _buildRatingBar(ThemeData theme) {
    var stars = <Widget>[];

    for (var i = 1; i <= 5; i++) {
      var color = i <= pelicula.voteAverage/2 ? theme.accentColor : Colors.black12;
      var star = Icon(
        Icons.star,
        color: color,
      );

      stars.add(star);
    }

    return Row(children: stars);
  }
}