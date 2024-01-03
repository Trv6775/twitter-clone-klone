import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_klone_clone/common/common.dart';
import 'package:twitter_klone_clone/features/explore/controller/explore_controller.dart';
import 'package:twitter_klone_clone/features/explore/widgets/search_tile.dart';
import 'package:twitter_klone_clone/theme/theme.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTextFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(33),
      borderSide: const BorderSide(
        color: Pallete.searchBarColor,
      ),
    );
    bool isShowUsers = false;
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            onSubmitted: (value) {
              setState(() {
                isShowUsers = true;
              });
            },
            controller: searchController,
            decoration: InputDecoration(
              fillColor: Pallete.searchBarColor,
              filled: true,
              focusedBorder: appBarTextFieldBorder,
              enabledBorder: appBarTextFieldBorder,
              hintText: 'Search Twitter',
              contentPadding: const EdgeInsets.all(10).copyWith(left: 20),
            ),
          ),
        ),
      ),
      body: isShowUsers
          ? ref.watch(searchUserProvider(searchController.text)).when(
                data: (users) {
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return SearchTile(userModel: user);
                    },
                  );
                },
                error: (error, stackTrace) {
                  return ErrorText(error: error.toString());
                },
                loading: () => const Loader(),
              )
          : const SizedBox(),
    );
  }
}
