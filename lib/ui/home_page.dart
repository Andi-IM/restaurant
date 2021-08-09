import 'package:dicoding_restaurant/widget/custom_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 100,
              flexibleSpace: FlexibleSpaceBar(),
              title: Text(
                'Mau Makan di Mana?',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ];
        },
        body: ListView(
          padding: const EdgeInsets.all(8.0),
          itemExtent: 106.0,
          children: <CustomListItem>[
            CustomListItem(
              location: 'Flutter',
              stars: 4.3,
              thumbnail:  ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                    'https://media-cdn.tripadvisor.com/media/photo-s/0d/7c/59/70/farmhouse-lembang.jpg'),
              ),
              title: 'The Flutter YouTube Channel',
            ),
            CustomListItem(
              location: 'Dash',
              stars: 2.5,
              thumbnail: Container(
                decoration: const BoxDecoration(color: Colors.yellow),
              ),
              title: 'Announcing Flutter 1.0',
            ),
          ],
        ),
      ),
    );
  }
}
