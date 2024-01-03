import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_klone_clone/apis/apis..dart';

import 'package:twitter_klone_clone/core/core.dart';
import 'package:twitter_klone_clone/core/enums/enums.dart';
import 'package:twitter_klone_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_klone_clone/models/models.dart';

final tweetControllerProvider =
StateNotifierProvider<TweetController, bool>((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  final storageAPI = ref.watch(storageAPIProvider);
  return TweetController(ref: ref, tweetAPI: tweetAPI, storageAPI: storageAPI);
});
final getTweetsProvider = FutureProvider((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});
final getLatestTweetProvider = StreamProvider((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  return tweetAPI.getLatestTweet();
});
final getRepliesToTweetProvider =
FutureProvider.family((ref, TweetModel tweet) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getRepliesToTweet(tweet);
});
final getTweetByIdProvider = FutureProvider.family((ref, String id) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetById(id);
});

class TweetController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final Ref _ref;
  final StorageAPI _storageAPI;

  TweetController({required Ref ref,
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI})
      : _ref = ref,
        _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        super(false);

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter text!');
      return;
    }
    if (images.isNotEmpty) {
      _shareImageTweet(
        images: images,
        text: text,
        context: context,
        repliedTo: repliedTo,
      );
    } else {
      _shareTextTweet(
        text: text,
        context: context,
        repliedTo: repliedTo,
      );
    }
  }

  void _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    final link = _getLinkFromText(text);
    final user = _ref
        .read(currentUserDetailsProvider)
        .value!;
    final imageLinks = await _storageAPI.uploadImage(images);
    TweetModel tweet = TweetModel(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: imageLinks,
      uid: user.uid,
      tweetType: TweetType.image,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );
    final res = await _tweetAPI.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  void _shareTextTweet({
    required String text,
    required BuildContext context,
    required String repliedTo,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref
        .read(currentUserDetailsProvider)
        .value!;
    TweetModel tweet = TweetModel(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      uid: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );
    final res = await _tweetAPI.shareTweet(tweet);
    state = false;
    res.fold((l) {
      return showSnackBar(context, l.message);
    }, (r) => null);
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split('');
    for (String word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split('');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }

  Future<List<TweetModel>> getTweets() async {
    final tweetList = await _tweetAPI.getTweets();
    return tweetList
        .map(
          (tweet) => TweetModel.fromMap(tweet.data),
    )
        .toList();
  }

  void likeTweet(TweetModel tweet, UserModel user) async {
    List<String> likes = tweet.likes;
    if (tweet.likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }
    tweet = tweet.copyWith(likes: likes);
    final res = await _tweetAPI.likeTweet(tweet);
    res.fold((l) => null, (r) => null);
  }

  void reshareTweet(TweetModel tweet, UserModel currentUser,
      BuildContext context) async {
    tweet = tweet.copyWith(
        retweetedBy: currentUser.name,
        likes: [],
        commentIds: [],
        reshareCount: tweet.reshareCount + 1);
    final res = await _tweetAPI.updateReshareCount(tweet);
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      tweet = tweet.copyWith(
        id: ID.unique(),
        reshareCount: 0,
        tweetedAt: DateTime.now(),
      );
      final res2 = await _tweetAPI.shareTweet(tweet);
      res2.fold(
            (l) => showSnackBar(context, l.message),
            (r) => showSnackBar(context, 'Retweeted!'),
      );
    });
  }

  Future<List<TweetModel>> getRepliesToTweet(TweetModel tweet) async {
    final document = await _tweetAPI.getRepliesToTweet(tweet);
    return document.map((tweet) => TweetModel.fromMap(tweet.data)).toList();
  }

  Future<TweetModel> getTweetById(String id) async {
    final tweet = await _tweetAPI.getTweetById(id);
    return TweetModel.fromMap(tweet.data);
  }
}
