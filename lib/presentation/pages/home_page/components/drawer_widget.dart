import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:launch_review_latest/launch_review_latest.dart';
import '../../../../navigator/navigate_effect.dart';
import '../../../../outside_functions.dart';
import '../../about_app_page/about_app_page.dart';
import '../../dictionaries_page/dictionaries_page.dart';
import '../../gratitudes_page/gratitudes_page.dart';
import '../../settings_page/settings_page.dart';
import '../home_page.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      width: 280,
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            color: const Color.fromARGB(255, 9, 65, 114),
            child: Image.asset(
              'assets/1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          ListTile(
            dense: true,
            horizontalTitleGap: 10,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            leading: Icon(Icons.book_outlined, color: theme.textTheme.bodyMedium!.color),
            title: Text(tr('dictionaries'),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500
                )),
                
                
            onTap: () {
              Navigator.of(context).push(NavigateEffects.fadeTransitionToPage(const DictionariesPage()));
            },
          ),
          Container(width: double.infinity, height: 1, color: Colors.black12,),
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            horizontalTitleGap: 10,
            title: Text(tr('gratitudes'),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                )),
            leading: Icon(Icons.star_outline, color: theme.textTheme.bodyMedium!.color),
            onTap: () {
              Navigator.of(context).push(NavigateEffects.fadeTransitionToPage(const GratitudesPage()));
            },
          ),
          Container(width: double.infinity, height: 1, color: Colors.black12,),
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            horizontalTitleGap: 10,
            title: Text(tr('settings'),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                )),
            leading: Icon(Icons.settings, color: theme.textTheme.bodyMedium!.color),
            onTap: () {
              homePageKey.currentState?.closeDrawer();
              Navigator.of(context).push(NavigateEffects.fadeTransitionToPage(const SettingsPage()));
            },
          ),
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            horizontalTitleGap: 10,
            title: Text(tr('about_app'),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                )),
            leading: Icon(Icons.info_outline, color: theme.textTheme.bodyMedium!.color),
            onTap: () {
              Navigator.of(context).push(NavigateEffects.fadeTransitionToPage(const AboutAppPage()));
            },
          ),
          Container(width: double.infinity, height: 1, color: Colors.black12,),
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            horizontalTitleGap: 10,
            title: Text(tr('write_to_support'),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                )),
            leading: Icon(Icons.mail_outlined, color: theme.textTheme.bodyMedium!.color),
            onTap: () {
              homePageKey.currentState?.closeDrawer();
              OutsideFunctions.sendMail(context);
            },
          ),
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            horizontalTitleGap: 10,
            title: Text(tr('rate_app'),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                )),
            leading: Icon(Icons.star_half, color: theme.textTheme.bodyMedium!.color),
            onTap: () {
              homePageKey.currentState?.closeDrawer();
              LaunchReviewLatest.launch();
            },
          ),
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            horizontalTitleGap: 10,
            title: Text(tr('share'),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                )),
            leading: Icon(Icons.share_outlined, color: theme.textTheme.bodyMedium!.color),
            onTap: () {
              homePageKey.currentState?.closeDrawer();
              OutsideFunctions.share(Platform.isIOS);
            },
          ),
        ],
      ),
    );
  }
}
