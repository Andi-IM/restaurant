import 'dart:io';

import 'package:dicoding_restaurant/provider/preferences_provider.dart';
import 'package:dicoding_restaurant/provider/scheduling_provider.dart';
import 'package:dicoding_restaurant/widget/custom_dialog.dart';
import 'package:dicoding_restaurant/widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  static const String settingsTitle = 'Settings';

  Widget _androidBuilder(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(settingsTitle),
        ),
        body: _buildList(context),
      );

  Widget _iosBuilder(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(settingsTitle),
        ),
        child: _buildList(context),
      );

  _buildList(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (_, provider, child) {
        return ListView(
          children: [
            Material(
              child: ListTile(
                title: Text('Dark Theme'),
                trailing: Switch.adaptive(
                  value: provider.isDarkTheme,
                  onChanged: (value) {
                    provider.enableDarkTheme(value);
                  },
                ),
              ),
            ),
            Material(
              child: ListTile(
                title: Text('Scheduling Reminder'),
                subtitle: Text('Every 11.00 AM'),
                trailing: Consumer<SchedulingProvider>(
                  builder: (context, scheduled, _) {
                    return Switch(
                      value: provider.isDailyReminderActive,
                      onChanged: (value) async {
                        if (Platform.isIOS) {
                          customDialog(context);
                        } else {
                          scheduled.shceduledNews(value);
                          provider.enableDailyReminderActive(value);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }
}
