import 'dart:io';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:dicoding_restaurant/data/api/api_service.dart';
import 'package:dicoding_restaurant/data/db/database_helper.dart';
import 'package:dicoding_restaurant/data/model/restaurant.dart';
import 'package:dicoding_restaurant/data/preferences/preferences_helper.dart';
import 'package:dicoding_restaurant/provider/database_provider.dart';
import 'package:dicoding_restaurant/provider/preferences_provider.dart';
import 'package:dicoding_restaurant/provider/restaurant_provider.dart';
import 'package:dicoding_restaurant/provider/scheduling_provider.dart';
import 'package:dicoding_restaurant/ui/home_page.dart';
import 'package:dicoding_restaurant/ui/restaurant_detail_page.dart';
import 'package:dicoding_restaurant/utils/background_service.dart';
import 'package:dicoding_restaurant/utils/notification_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'commons/navigation.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider(create: (_) => SchedulingProvider()),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(
            databaseHelper: DatabaseHelper(),
          ),
        ),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) => MaterialApp(
          title: 'Restaurant',
          theme: provider.themeData,
          builder: (context, child) => CupertinoTheme(
            data: CupertinoThemeData(
              brightness:
                  provider.isDarkTheme ? Brightness.dark : Brightness.light,
            ),
            child: Material(
              child: child,
            ),
          ),
          navigatorKey: navigatorKey,
          initialRoute: HomePage.routeName,
          routes: {
            HomePage.routeName: (context) => HomePage(),
            RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
                restaurant:
                    ModalRoute.of(context)?.settings.arguments as Restaurant),
          },
        ),
      ),
    );
  }
}
