import 'dart:async';

import 'package:restaurant/data/api/api_service.dart';
import 'package:restaurant/data/model/restaurant.dart';
import 'package:restaurant/provider/preferences_provider.dart';
import 'package:restaurant/provider/restaurant_provider.dart';
import 'package:restaurant/utils/result_state.dart';
import 'package:restaurant/widget/custom_list.dart';
import 'package:restaurant/widget/custom_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' show Client;
import 'package:provider/provider.dart';

class RestaurantListPage extends StatefulWidget {
  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  late RestaurantProvider restaurantProvider;
  late Future<SearchResult> restaurantSearch;
  List<Restaurant> restaurants = [];
  String query = '';
  Timer? deBouncer;

  @override
  void dispose() {
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (deBouncer != null) {
      deBouncer!.cancel();
    }
    deBouncer = Timer(duration, callback);
  }

  void searchRestaurant(String query) async => debounce(() async {
        var client = Client();
        restaurantSearch = ApiService(client).search(query);

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

  toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget _buildRestaurantItem() {
    return Consumer<RestaurantProvider>(builder: (context, state, _) {
      if (state.state == ResultState.Loading) {
        restaurantProvider = state;
        return Expanded(child: Center(child: CircularProgressIndicator()));
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
        toast('No Connection!');
        return Expanded(
          child: Center(
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
          ),
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
          return Expanded(child: Center(child: CircularProgressIndicator()));
        } else if (state == ConnectionState.done) {
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
            toast('No Connection!');
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
        }
        return Expanded(
          child: Center(
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final client = Client();
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
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 5,
                  child: buildSearch(),
                ),
                Consumer<PreferencesProvider>(
                  builder: (context, state, child) => Expanded(
                    flex: 1,
                    child: SvgPicture.asset(
                      'assets/icon/${state.isDarkTheme ? 'filter_dark' : 'filter'}.svg',
                      height: 45,
                    ),
                  ),
                ),
              ],
            ),
          ),
          query == ""
              ? ChangeNotifierProvider<RestaurantProvider>(
                  create: (_) =>
                      RestaurantProvider(apiService: ApiService(client)),
                  child: _buildRestaurantItem())
              : _buildQueryItem(),
        ],
      ),
    );
  }
}
