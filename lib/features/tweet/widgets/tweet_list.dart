import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_klone_clone/common/common.dart';
import 'package:twitter_klone_clone/constants/constants.dart';
import 'package:twitter_klone_clone/core/core.dart';
import 'package:twitter_klone_clone/features/tweet/tweet_controller.dart';
import 'package:twitter_klone_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_klone_clone/models/models.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
          data: (tweets) {
            return ref.watch(getLatestTweetProvider).when(
                  data: (data) {
                    if (data.events.contains(
                        'databases.*.collections.${AppwriteConstants.tweetCollectionId}.documents.*.create')) {
                      tweets.insert(0, TweetModel.fromMap(data.payload));
                    } else if (data.events.contains(
                        'databases.*.collections.${AppwriteConstants.tweetCollectionId}.documents.*.update')) {
                      ///get id of the tweet
                      final startingPoint=data.events[0].lastIndexOf('documents.');
                      final endPoint=data.events[0].lastIndexOf('.update');
                      final tweetId= data.events[0].substring(startingPoint+10,endPoint);
                      var tweet = tweets
                          .where((element) => element.id == tweetId)
                          .first;
                      final tweetIndex = tweets.indexOf(tweet);
                      tweets.removeWhere((element) => element.id == tweet.id);
                      tweet=TweetModel.fromMap(data.payload);
                      tweets.insert(tweetIndex, tweet);
                    }
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (context, index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      },
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () {
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (context, index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      },
                    );
                  },
                );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
