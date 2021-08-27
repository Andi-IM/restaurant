import 'package:dicoding_restaurant/data/api/api_service.dart';
import 'package:dicoding_restaurant/data/model/detail.dart';
import 'package:dicoding_restaurant/data/model/restaurant.dart';
import 'package:dicoding_restaurant/provider/preferences_provider.dart';
import 'package:dicoding_restaurant/provider/restaurant_provider.dart';
import 'package:dicoding_restaurant/utils/result_state.dart';
import 'package:dicoding_restaurant/widget/custom_bottom_modal.dart';
import 'package:dicoding_restaurant/widget/item_chip_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const String routeName = '/restaurant_detail_page';

  final Restaurant restaurant;

  const RestaurantDetailPage({required this.restaurant});

  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  static const _url = 'https://restaurant-api.dicoding.dev/images/small';
  var _idSelected = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantProvider>(
      create: (_) => RestaurantProvider(
        id: widget.restaurant.id,
        apiService: ApiService(),
      ),
      child: Scaffold(
        body: _renderView(),
      ),
    );
  }

  Widget currentTab() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: chipBarList[_idSelected].bodyWidget,
    );
  }

  Row listChip(Menus menu) {
    foods.addAll(menu.foods);
    drinks.addAll(menu.drinks);

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: chipBarList
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text(item.title),
                selected: _idSelected == item.id,
                onSelected: (_) => setState(() => _idSelected = item.id),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _actionButton(BuildContext context, Function() onTap) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 20),
      child: GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(
          'assets/icon/left_chevron.svg',
          width: 40,
          height: 40,
        ),
      ),
    );
  }

  Widget _renderView() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                Hero(
                  tag: widget.restaurant.pictureId,
                  child: Image.network(
                    '$_url/${widget.restaurant.pictureId}',
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: _actionButton(
                    context,
                    () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: BookmarkButton(),
                ),
                Consumer<PreferencesProvider>(
                  builder: (context, provider, child) => Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: provider.isDarkTheme
                          ? Color(0xFF333333)
                          : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.restaurant.name,
                          style: GoogleFonts.poppins(
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.25,
                            color: Color(0xFFFF4747),
                          ),
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            SvgPicture.asset('assets/icon/pin_grey.svg'),
                            Text(widget.restaurant.city,
                                style: Theme.of(context).textTheme.bodyText2),
                          ],
                        ),
                        Consumer<RestaurantProvider>(
                          builder: (context, provider, _) => Text(
                            provider.state == ResultState.HasData
                                ? provider.detail.detail.address
                                : "Loading..",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          size: 42,
                          color: Color(0xFFFFD700),
                        ),
                        Text(
                          '${widget.restaurant.rating}',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    '''${widget.restaurant.description}''',
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Menu',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Consumer<RestaurantProvider>(
                    builder: (context, provider, _) {
                      if (provider.state == ResultState.Loading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (provider.state == ResultState.HasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: listChip(provider.detail.detail.menus),
                            ),
                            currentTab(),
                          ],
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error,
                                size: 50,
                              ),
                              Text(
                                'Something went wrong :(',
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Review',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  ElevatedButton(
                    child: Text('Add Your Review'),
                    onPressed: () => showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16.0)),
                      ),
                      backgroundColor: Colors.white,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) =>
                          CustomBottomModal(context, id: widget.restaurant.id),
                    ),
                  ),
                  Consumer<RestaurantProvider>(
                    builder: (context, provider, _) {
                      if (provider.state == ResultState.Loading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (provider.state == ResultState.HasData) {
                        var item = provider.detail.detail.customerReviews;
                        return Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: item.length,
                            itemBuilder: (context, index) => ListTile(
                              title: Text(
                                '${item[index].name} pada ${item[index].date}',
                              ),
                              subtitle: Text(item[index].review),
                            ),
                          ),
                        );
                      } else
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error,
                                size: 50,
                              ),
                              Text(
                                'Something went wrong :(',
                              ),
                            ],
                          ),
                        );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookmarkButton extends StatefulWidget {
  @override
  _BookmarkButtonState createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        isBookmarked = !isBookmarked;
      }),
      child: Padding(
        padding: EdgeInsets.only(top: 20, right: 20),
        child: SvgPicture.asset(
          isBookmarked
              ? 'assets/icon/bookmark_selected.svg'
              : 'assets/icon/bookmark_unselected.svg',
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
