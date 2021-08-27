import 'dart:async';

import 'package:dicoding_restaurant/data/api/api_service.dart';
import 'package:dicoding_restaurant/data/model/restaurant.dart';
import 'package:dicoding_restaurant/provider/database_provider.dart';
import 'package:dicoding_restaurant/provider/preferences_provider.dart';
import 'package:dicoding_restaurant/utils/result_state.dart';
import 'package:dicoding_restaurant/widget/custom_list.dart';
import 'package:dicoding_restaurant/widget/custom_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  static String favoriteTitle = 'Favorites';

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<SearchResult> restaurantSearch;
  String query = '';
  Timer? debouncer;

  @override
  void dispose() {
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  void searchRestaurant(String query) async => debounce(() async {
        restaurantSearch = ApiService().search(query);

        if (!mounted) return;
        setState(() {
          this.query = query;
        });
      });

  Widget buildSearch() => SearchWidget(
        hintText: 'Search name or city',
        text: query,
        onChanged: searchRestaurant,
      );

  Widget _buildRestaurantItem() {
    return Consumer<DatabaseProvider>(builder: (context, provider, child) {
      if (provider.state == ResultState.HasData) {
        return Expanded(
          child: ListView.builder(
            itemCount: provider.favorites.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              var restaurant = provider.favorites[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: CustomListItem(restaurant: restaurant),
              );
            },
          ),
        );
      } else {
        return Center(child: Text(provider.message));
      }
    });
  }

  Widget _buildQueryItem() {
    return FutureBuilder(
      future: restaurantSearch,
      builder: (context, AsyncSnapshot<SearchResult> snapshot) {
        var state = snapshot.connectionState;
        if (state == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (state == ConnectionState.done) {}
        if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.restaurants.length,
              itemBuilder: (context, index) {
                var restaurant = snapshot.data!.restaurants[index];
                return CustomListItem(restaurant: restaurant);
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  size: 30,
                  color: Color(0xFFBDBDBD),
                ),
                Text(
                  'Something Went wrong',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          );
        }
        return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.error,
              size: 30,
              color: Color(0xFFBDBDBD),
            ),
            Text(
              'Something Went wrong',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Text('FAVORITES',
                style: GoogleFonts.poppins(
                  color: Color(0xFFFF4747),
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildSearch(),
                Consumer<PreferencesProvider>(
                  builder: (context, state, child) => SvgPicture.asset(
                    'assets/icon/${state.isDarkTheme ? 'filter_dark' : 'filter'}.svg',
                    width: 50,
                  ),
                ),
              ],
            ),
          ),
          query == "" ? _buildRestaurantItem() : _buildQueryItem(),
        ],
      ),
    );
  }
}
