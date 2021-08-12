import 'package:dicoding_restaurant/data/model/restaurant.dart';
import 'package:dicoding_restaurant/widget/choice_chip_widget.dart';
import 'package:dicoding_restaurant/widget/item_chip_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'detail_page.dart';

class TestUi extends StatefulWidget {
  static final String routeName = '/test_ui';

  @override
  _TestUiState createState() => _TestUiState();
}

class _TestUiState extends State<TestUi> {
  var idSelected = 0;

  @override
  Widget build(BuildContext context) {
    final drink = <Item>[
      Item(name: 'Udin'),
      Item(name: 'Udin'),
      Item(name: 'Udin')
    ];

    final List<Item> food = <Item>[
      Item(name: 'Paijo'),
      Item(name: 'Paijo'),
      Item(name: 'Paijo'),
    ];

    Menus menus = Menus(
      drinks: drink,
      foods: food,
    );

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
                    tag: 'test',
                    child: Image.network(
                      'https://restaurant-api.dicoding.dev/images/medium/14',
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey,
                        );
                      },
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
                            'Tank Kelek',
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
                                'Padang',
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
                            'hello',
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
                      'hello',
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
                child: listChip(menus),
              ),
              currentTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget currentTab() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: chipBarList[idSelected].bodyWidget,
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
}
