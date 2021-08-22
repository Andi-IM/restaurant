import 'package:dicoding_restaurant/data/api/api_service.dart';
import 'package:dicoding_restaurant/data/model/detail.dart';
import 'package:dicoding_restaurant/provider/restaurant_provider.dart';
import 'package:dicoding_restaurant/widget/item_chip_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const String routeName = '/restaurant_detail_page';

  final String id;

  const RestaurantDetailPage({required this.id});

  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  static const _url = 'https://restaurant-api.dicoding.dev/images/small';
  var idSelected = 0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantProvider>(
      create: (_) =>
          RestaurantProvider(widget.id, null, apiService: ApiService()),
      child: _renderView(),
    );
  }

  Widget currentTab() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: chipBarList[idSelected].bodyWidget,
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
                selected: idSelected == item.id,
                onSelected: (_) => setState(() => idSelected = item.id),
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
    return Consumer<RestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return Scaffold(
            appBar: AppBar(title: Text('Loading..')),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state.state == ResultState.HasData) {
          return Scaffold(body: _detailView(state.detail.detail));
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
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
            ),
          );
        }
      },
    );
  }

  Widget _detailView(Detail restaurant) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                Hero(
                  tag: restaurant.pictureId,
                  child: Image.network(
                    '$_url/${restaurant.pictureId}',
                    width: double.infinity,
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
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
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
                          restaurant.name,
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
                            Text(restaurant.city,
                                style: Theme.of(context).textTheme.bodyText2),
                          ],
                        ),
                        Text(
                          restaurant.address,
                          style: Theme.of(context).textTheme.caption,
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
                          '${restaurant.rating}',
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
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    '''${restaurant.description}''',
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Menu',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: listChip(restaurant.menus),
            ),
            currentTab(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Review',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: restaurant.customerReviews.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(
                        '${restaurant.customerReviews[index].name} pada ${restaurant.customerReviews[index].date}',
                      ),
                      subtitle: Text(restaurant.customerReviews[index].review),
                    ),
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
