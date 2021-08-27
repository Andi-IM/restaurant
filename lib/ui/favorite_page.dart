import 'package:dicoding_restaurant/widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  static String favoriteTitle = 'Favorites';

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Under Construction'),
      ),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Text('Under Construction'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
        androidBuilder: _androidBuilder, iosBuilder: _iosBuilder);
  }
}
