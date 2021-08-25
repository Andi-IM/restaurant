import 'package:dicoding_restaurant/commons/theme.dart';
import 'package:dicoding_restaurant/data/api/api_service.dart';
import 'package:dicoding_restaurant/data/model/restaurant.dart';
import 'package:dicoding_restaurant/provider/restaurant_provider.dart';
import 'package:dicoding_restaurant/ui/restaurant_detail_page.dart';
import 'package:dicoding_restaurant/ui/restaurant_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          RestaurantProvider(null, null, apiService: ApiService()),
      child: MaterialApp(
        title: 'Restaurant',
        theme: lightTheme,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        initialRoute: RestaurantListPage.routeName,
        routes: {
          RestaurantListPage.routeName: (context) => RestaurantListPage(),
          RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
              restaurant:
                  ModalRoute.of(context)?.settings.arguments as Restaurant),
        },
      ),
    );
  }
}
