import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ArcImage extends StatelessWidget {
  final String imageUrl;
  const ArcImage({Key key, @required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return ClipPath(
      clipper: ArcClipper(),
      child: CachedNetworkImage(
      imageUrl: imageUrl,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
                              Padding(
                                    padding: const EdgeInsets.all(40.0),
                                    child: Center( child: CircularProgressIndicator()),
                              ),
      errorWidget: (context, url, error) => Image.asset("assets/no-image.jpg", width: screenWidth, height: 230.0, fit: BoxFit.cover, color: Colors.red[600]),        
      width: screenWidth,
      height: 230.0,
      fit: BoxFit.cover,
        ),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}