import 'package:dicoding_restaurant/data/model/restaurant.dart';
import 'package:dicoding_restaurant/widget/choice_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RestaurantDetailPage extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantDetailPage({required this.restaurant});

  static const String routeName = '/restaurant_detail_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                      restaurant.pictureId,
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
                              Text(
                                restaurant.city,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
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
                      '${restaurant.description}',
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
              /*Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                height: 40,
                child: ChipsFilter(
                  selected: 0, // select the first fpuilter
                  filters: [
                    Filter(label: "Food"),
                    Filter(label: "Drink"),
                  ], onTap: () {  },
                ),
              ),*/
            ],
          ),
        ),
      ),
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
