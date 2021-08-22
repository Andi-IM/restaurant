import 'package:dicoding_restaurant/data/model/restaurant.dart';
import 'package:dicoding_restaurant/ui/restaurant_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
        arguments: restaurant.id,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Hero(
                tag: restaurant.pictureId,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    '$_url/${restaurant.pictureId}',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).accentColor,
                            value: loadingProgress.expectedTotalBytes != null
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
            Flexible(
              child: OutlinedBookmarkButton(),
            ),
          ],
        ),
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
  @override
  _OutlinedBookmarkButtonState createState() => _OutlinedBookmarkButtonState();
}

class _OutlinedBookmarkButtonState extends State<OutlinedBookmarkButton> {
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
              : 'assets/icon/bookmark_unselected_outlined.svg',
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
