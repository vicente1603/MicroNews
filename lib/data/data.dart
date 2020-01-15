import 'package:flutter/material.dart';

class Doodle {
  final Color iconBackground;
  final Icon icon;

  const Doodle({this.icon, this.iconBackground});
}

const List<Doodle> doodles = [
  Doodle(
      icon: Icon(Icons.star, color: Colors.white), iconBackground: Colors.cyan),
  Doodle(
      icon:  Icon(Icons.star, color: Colors.white),
      iconBackground: Colors.cyan),
  Doodle(
      icon: Icon(
        Icons.visibility,
        color: Colors.white,
        size: 32.0,
      ),
      iconBackground: Colors.cyan),
  Doodle(
      icon: Icon(
        Icons.account_balance,
        color: Colors.white,
      ),
      iconBackground: Colors.cyan),
  Doodle(
      icon: Icon(
        Icons.healing,
        color: Colors.white,
      ),
      iconBackground: Colors.cyan),
  Doodle(
      icon: Icon(
        Icons.blur_circular,
        color: Colors.white,
      ),
      iconBackground: Colors.cyan),
  Doodle(
      icon: Icon(
        Icons.category,
        color: Colors.white,
      ),
      iconBackground: Colors.cyan),
  Doodle(
      icon: Icon(
        Icons.navigation,
        color: Colors.white,
        size: 32.0,
      ),
      iconBackground: Colors.cyan),
  Doodle(
      icon: Icon(
        Icons.supervised_user_circle,
        color: Colors.white,
      ),
      iconBackground: Colors.cyan),
  Doodle(
      icon: Icon(
        Icons.map,
        color: Colors.white,
        size: 32.0,
      ),
      iconBackground: Colors.cyan),
];
