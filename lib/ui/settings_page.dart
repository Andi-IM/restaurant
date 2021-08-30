import 'dart:io';

import 'package:dicoding_restaurant/commons/theme.dart';
import 'package:dicoding_restaurant/provider/preferences_provider.dart';
import 'package:dicoding_restaurant/provider/scheduling_provider.dart';
import 'package:dicoding_restaurant/widget/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  static const String settingsTitle = 'Settings';

  _buildList(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.only(
            top: 40,
            left: 20,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(settingsTitle,
                  style: GoogleFonts.poppins(
                    color: Color(0xFFFF4747),
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  )),
              ListTile(
                title: Text('Dark Theme'),
                trailing: CupertinoSwitch(
                  activeColor: secondaryColor,
                  value: provider.isDarkTheme,
                  onChanged: (value) {
                    provider.enableDarkTheme(value);
                  },
                ),
              ),
              ListTile(
                title: Text('Scheduling Reminder'),
                subtitle: Text('Every 11.00 AM'),
                trailing: Consumer<SchedulingProvider>(
                  builder: (context, scheduled, _) {
                    return CupertinoSwitch(
                      activeColor: secondaryColor,
                      value: provider.isDailyReminderActive,
                      onChanged: (value) async {
                        if (Platform.isIOS) {
                          customDialog(context);
                        } else {
                          scheduled.shceduledNews(value);
                          provider.enableDailyReminderActive(value);

                          value
                              ? toast('Reminder Activated every 11.00 AM')
                              : toast('Reminder Canceled!');
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  toast(String message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildList(context),
    );
  }
}
