import 'package:dicoding_restaurant/commons/theme.dart';
import 'package:dicoding_restaurant/data/model/restaurant.dart';
import 'package:dicoding_restaurant/ui/detail_page.dart';
import 'package:dicoding_restaurant/ui/restaurant_list_page.dart';
import 'package:dicoding_restaurant/ui/test_ui.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant',
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: TestUi.routeName,
      routes: {
        TestUi.routeName: (context) => TestUi(),
        RestaurantListPage.routeName: (context) => RestaurantListPage(),
        RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
            restaurant:
                ModalRoute.of(context)?.settings.arguments as Restaurant),
      },
    );
  }
}
