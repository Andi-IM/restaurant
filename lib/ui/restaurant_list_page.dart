import 'dart:async';

import 'package:dicoding_restaurant/data/api/api_service.dart';
import 'package:dicoding_restaurant/data/model/restaurant.dart';
import 'package:dicoding_restaurant/provider/restaurant_provider.dart';
import 'package:dicoding_restaurant/widget/custom_list.dart';
import 'package:dicoding_restaurant/widget/custom_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RestaurantListPage extends StatefulWidget {
  static String routeName = '/list_page';

  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  List<Restaurant> restaurants = [];
  String query = '';
  Timer? debouncer;

  String url = 'assets/local_restaurant.json';

  @override
  void initState() {
    super.initState();
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

  void searchRestaurant(String query) => debounce(() async {
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
        var restaurantss = state.result.restaurants;

        return ListView.builder(
          shrinkWrap: true,
          itemCount: restaurantss.length,
          itemBuilder: (context, index) {
            var restaurant = restaurantss[index];
            return CustomListItem(restaurant: restaurant);
          },
        );
      } else if (state.state == ResultState.NoData) {
        return Center(child: Text(state.message));
      } else {
        return Center(child: Text(state.message));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2)),
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
              child: ChangeNotifierProvider<RestaurantProvider>(
                create: (_) => RestaurantProvider(null, apiService: ApiService()),
                child: _buildRestaurantItem(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
