import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_klone_clone/constants/asset_constants.dart';
import 'package:twitter_klone_clone/features/tweet/widgets/tweet_list.dart';
import 'package:twitter_klone_clone/theme/pallete.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetConstants.twitterLogo,
        color: Pallete.blueColor,
        height: 30,
      ),
      centerTitle: true,
    );
  }

  static const List<Widget> bottomTabBarPages = [
    TweetList(),
    Text('Search Screen'),
    Text('Notification Screen'),
  ];
}
