import 'package:flutter/material.dart';
import 'package:twitter_klone_clone/features/user_profile/views/user_profile_view.dart';
import 'package:twitter_klone_clone/models/models.dart';
import 'package:twitter_klone_clone/theme/theme.dart';

class SearchTile extends StatelessWidget {
  final UserModel userModel;

  const SearchTile({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          UserProfileView.route(userModel),
        );
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          userModel.profilePic,
        ),
        radius: 33,
      ),
      title: Text(
        userModel.name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${userModel.name}',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),

          ///Bio
          Text(
            userModel.bio,
            style: const TextStyle(fontSize: 16, color: Pallete.whiteColor),
          ),
        ],
      ),
    );
  }
}
