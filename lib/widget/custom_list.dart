import 'package:dicoding_restaurant/data/model/restaurant.dart';
import 'package:dicoding_restaurant/provider/database_provider.dart';
import 'package:dicoding_restaurant/provider/preferences_provider.dart';
import 'package:dicoding_restaurant/ui/restaurant_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomListItem extends StatelessWidget {
  const CustomListItem({required this.restaurant});

  final Restaurant restaurant;

  static const _url = 'https://restaurant-api.dicoding.dev/images/small';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        RestaurantDetailPage.routeName,
        arguments: restaurant,
      ),
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) => Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: provider.isDarkTheme ? Color(0xFF1b1b1b) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: provider.isDarkTheme
                      ? Color(0xFAFAFA)
                      : Color(0xFFBABABA),
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                  offset: Offset(0.0, 2.0),
                )
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Hero(
                    tag: restaurant.pictureId,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(
                        '$_url/${restaurant.pictureId}',
                        fit: BoxFit.cover,
                        width: 200,
                        height: 100,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                                color: Theme.of(context).accentColor,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null),
                          );
                        },
                        errorBuilder: (context, e, _) => Center(
                          child: Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _Description(
                    title: restaurant.name,
                    location: restaurant.city,
                    stars: restaurant.rating,
                  ),
                ),
                OutlinedBookmarkButton(restaurant: restaurant),
              ],
            )),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({
    Key? key,
    required this.title,
    required this.location,
    required this.stars,
  }) : super(key: key);

  final String title;
  final String location;
  final double stars;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFFFF4747),
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SvgPicture.asset('assets/icon/pin_grey.svg'),
              Text(
                location,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Color(0xFFBABABA),
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.star, color: Color(0xFFFFD700)),
              Text(
                '$stars',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OutlinedBookmarkButton extends StatefulWidget {
  final Restaurant restaurant;

  OutlinedBookmarkButton({required this.restaurant});

  @override
  _OutlinedBookmarkButtonState createState() => _OutlinedBookmarkButtonState();
}

class _OutlinedBookmarkButtonState extends State<OutlinedBookmarkButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(builder: (context, state, child) {
      return Consumer<DatabaseProvider>(
        builder: (context, provider, child) => FutureBuilder<bool>(
            future: provider.isFavorite(widget.restaurant.id),
            builder: (context, snapshot) {
              var isFavorite = snapshot.data ?? false;
              return GestureDetector(
                onTap: () => setState(() {
                  isFavorite = !isFavorite;
                  if (isFavorite) {
                    provider.addFavorite(widget.restaurant);
                  } else {
                    provider.removeFavorite(widget.restaurant.id);
                  }
                }),
                child: Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: SvgPicture.asset(
                    isFavorite
                        ? 'assets/icon/${state.isDarkTheme ? 'bookmark_selected_dark' : 'bookmark_selected'}.svg'
                        : 'assets/icon/${state.isDarkTheme ? 'bookmark_unselected_dark' : 'bookmark_unselected_outlined'}.svg',
                    width: 40,
                    height: 40,
                  ),
                ),
              );
            }),
      );
    });
  }
}
