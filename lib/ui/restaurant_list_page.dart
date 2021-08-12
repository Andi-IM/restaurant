import 'dart:async';

import 'package:dicoding_restaurant/data/model/restaurant.dart';
import 'package:dicoding_restaurant/ui/detail_page.dart';
import 'package:dicoding_restaurant/widget/custom_list.dart';
import 'package:dicoding_restaurant/widget/custom_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RestaurantListPage extends StatefulWidget {
  static String routeName = '/list_page';

  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  List<Restaurant> restaurants = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();

    init();
  }

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

  Future init() async {
    final restaurants = await DataApi.getRestaurants(query);
    setState(() => this.restaurants = restaurants);
  }

  Future searchRestaurant(String query) async => debounce(() async {
        final restaurants = await DataApi.getRestaurants(query);

        if (!mounted) return;

        setState(() {
          this.query = query;
          this.restaurants = restaurants;
        });
      });

  Widget buildSearch() => SearchWidget(
        hintText: 'Search name or city',
        text: query,
        onChanged: searchRestaurant,
      );

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    return CustomListItem(
      imageUrl: restaurant.pictureId,
      name: restaurant.name,
      location: restaurant.city,
      stars: restaurant.rating,
      onTap: () {
        Navigator.pushNamed(context, RestaurantDetailPage.routeName,
            arguments: restaurant);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.only(top: 10)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icon/pin.svg',
                      width: 20,
                    ),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 2)),
                    Text('Choose location'),
                  ],
                ),
                SvgPicture.asset(
                  'assets/icon/user.svg',
                  width: 40,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('RESTAURANT',
                    style: GoogleFonts.poppins(
                      color: Color(0xFFFF4747),
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    )),
                Text(
                  'Recommendation restaurant for you!',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: buildSearch(),
              ),
              Flexible(
                child: SvgPicture.asset(
                  'assets/icon/filter.svg',
                  width: 50,
                ),
              ),
            ],
          ),
          Flexible(
            child: ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return _buildRestaurantItem(context, restaurant);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/**
    ListView.builder(
    itemCount: restaurants.length,
    itemBuilder: (context, index) {
    final restaurant = restaurants[index];
    return _buildRestaurantItem(context, restaurant);
    },
    ),
 **/
