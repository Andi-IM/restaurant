import 'dart:async';

import 'package:dicoding_restaurant/data/api/api_service.dart';
import 'package:dicoding_restaurant/data/model/restaurant.dart';
import 'package:dicoding_restaurant/provider/preferences_provider.dart';
import 'package:dicoding_restaurant/provider/restaurant_provider.dart';
import 'package:dicoding_restaurant/utils/result_state.dart';
import 'package:dicoding_restaurant/widget/custom_list.dart';
import 'package:dicoding_restaurant/widget/custom_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RestaurantListPage extends StatefulWidget {
  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
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
    return Consumer<RestaurantProvider>(builder: (context, state, _) {
      if (state.state == ResultState.Loading) {
        return Center(child: CircularProgressIndicator());
      } else if (state.state == ResultState.HasData) {
        var restaurants = state.result.restaurants;
        return Expanded(
          child: ListView.builder(
            itemCount: state.count,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              var restaurant = restaurants[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: CustomListItem(restaurant: restaurant),
              );
            },
          ),
        );
      } else if (state.state == ResultState.NoData) {
        return Center(child: Text(state.message));
      } else {
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
            child: Text('RESTAURANT',
                style: GoogleFonts.poppins(
                  color: Color(0xFFFF4747),
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Recommendation restaurant for you!',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
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
          query == ""
              ? ChangeNotifierProvider<RestaurantProvider>(
                  create: (_) => RestaurantProvider(apiService: ApiService()),
                  child: _buildRestaurantItem(),
                )
              : _buildQueryItem(),
        ],
      ),
    );
  }
}
