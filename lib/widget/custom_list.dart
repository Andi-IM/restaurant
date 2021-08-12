import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.stars,
    required this.onTap,
  });

  final String imageUrl;
  final String name;
  final String location;
  final double stars;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Hero(
                tag: imageUrl,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(imageUrl),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: _VideoDescription(
                title: name,
                location: location,
                stars: stars,
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

class _VideoDescription extends StatelessWidget {
  const _VideoDescription({
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
