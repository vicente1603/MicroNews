import 'package:micro_news/models/dicas_data.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/widgets/page_transformer.dart';

class DicasTile extends StatelessWidget {
  final String type;
  final DicasData dicas;
  final PageVisibility pageVisibility;

  DicasTile(this.type, this.dicas, this.pageVisibility);

  Widget _applyTextEffects({
    @required double translationFactor,
    @required Widget child,
  }) {
    final double xTranslation = pageVisibility.pagePosition * translationFactor;

    return Opacity(
      opacity: pageVisibility.visibleFraction,
      child: Transform(
        alignment: FractionalOffset.topLeft,
        transform: Matrix4.translationValues(
          xTranslation,
          0.0,
          0.0,
        ),
        child: child,
      ),
    );
  }

  _buildTextContainer(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var titleText = _applyTextEffects(
      translationFactor: 300.0,
      child: Text(
        dicas.title,
        style: textTheme.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          fontSize: 25.0,
        ),
        textAlign: TextAlign.center,
      ),
    );

    var contentText = _applyTextEffects(
      translationFactor: 200.0,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          children: <Widget>[
            Text(
              dicas.description,
              style: textTheme.title
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
//            IconButton(
//              icon: Icon(Icons.star_border, color: Colors.white, size: 40,
//              ),
//            )
          ],
        ),
      ),
    );

    return Positioned(
      bottom: 56.0,
      left: 32.0,
      right: 32.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          titleText,
          contentText,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
//    var image = Image.asset(
//      'assets/images/mae_bebe2.png',
//      fit: BoxFit.cover,
//      alignment: FractionalOffset(
//        0.5 + (pageVisibility.pagePosition / 3),
//        0.5,
//      ),
//    );

    var image = ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Image.asset(
        'assets/images/mae_bebe2.png',
        height: 150.0,
        width: 100.0,
        fit: BoxFit.cover,
        alignment: FractionalOffset(
          0.5 + (pageVisibility.pagePosition / 3),
          0.5,
        ),
      ),
    );

    var imageOverlayGradient = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black,
            Colors.black45,
          ],
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            image,
            imageOverlayGradient,
            _buildTextContainer(context),
          ],
        ),
      ),
    );
  }
}
