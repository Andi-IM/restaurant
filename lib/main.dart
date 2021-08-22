import 'package:dicoding_restaurant/commons/theme.dart';
import 'package:dicoding_restaurant/ui/restaurant_detail_page.dart';
import 'package:dicoding_restaurant/ui/restaurant_list_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant',
      theme: lightTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: RestaurantListPage.routeName,
      routes: {
        RestaurantListPage.routeName: (context) => RestaurantListPage(),
        RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
            id: ModalRoute.of(context)?.settings.arguments as String),
      },
    );
  }
}
