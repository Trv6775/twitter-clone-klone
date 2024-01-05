import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_klone_clone/common/common.dart';
import 'package:twitter_klone_clone/constants/constants.dart';
import 'package:twitter_klone_clone/core/enums/enums.dart';
import 'package:twitter_klone_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_klone_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_klone_clone/features/tweet/views/twitter_reply_view.dart';
import 'package:twitter_klone_clone/features/tweet/widgets/carousel_image.dart';
import 'package:twitter_klone_clone/features/tweet/widgets/hashtag_text.dart';
import 'package:twitter_klone_clone/features/tweet/widgets/tweet_icon_button.dart';
import 'package:twitter_klone_clone/models/models.dart';
import 'package:twitter_klone_clone/theme/theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetCard extends ConsumerWidget {
  final TweetModel tweet;

  const TweetCard({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const SizedBox()
        : ref.watch(userDetailsProvider(tweet.uid)).when(
              data: (user) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      TwitterReplyView.route(tweet),
                    );
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(
                              9,
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(user.profilePic),
                              radius: 33,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //retweeted
                                if (tweet.retweetedBy.isNotEmpty)
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AssetConstants.retweetIcon,
                                        color: Pallete.greyColor,
                                        height: 20,
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        '${tweet.retweetedBy} retweeted',
                                        style: const TextStyle(
                                          color: Pallete.greyColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6.0),
                                      child: SizedBox(
                                        child: Text(
                                          user.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "@${user.name} . ${timeago.format(
                                        tweet.tweetedAt,
                                        locale: 'en_short',
                                      )}",
                                      style: const TextStyle(
                                        color: Pallete.greyColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),

                                ///replied to
                                if (tweet.repliedTo.isNotEmpty)
                                  ref
                                      .watch(
                                          getTweetByIdProvider(tweet.repliedTo))
                                      .when(
                                        data: (repliedToTweet) {
                                          final replyingToUser = ref
                                              .watch(
                                                userDetailsProvider(
                                                    repliedToTweet.uid),
                                              )
                                              .value;
                                          return RichText(
                                            text: TextSpan(
                                              text: 'Replying to ',
                                              style: const TextStyle(
                                                  color: Pallete.greyColor,
                                                  fontSize: 16),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '@${replyingToUser?.name}',
                                                  style: const TextStyle(
                                                    color: Pallete.blueColor,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        error: (error, stackTrace) => ErrorText(
                                          error: error.toString(),
                                        ),
                                        loading: () => const SizedBox(),
                                      ),

                                HashtagText(text: tweet.text),
                                if (tweet.tweetType == TweetType.image)
                                  CarouselImage(
                                    imageLinks: tweet.imageLinks,
                                  ),
                                if (tweet.link.isNotEmpty) ...[
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  AnyLinkPreview(
                                    link: 'https://${tweet.link}',
                                    displayDirection:
                                        UIDirection.uiDirectionHorizontal,
                                  ),
                                ],
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10.0,
                                    right: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TweetIconButton(
                                        pathName: AssetConstants.viewsIcon,
                                        text: (tweet.commentIds.length +
                                                tweet.reshareCount +
                                                tweet.likes.length)
                                            .toString(),
                                        onTap: () {},
                                      ),
                                      TweetIconButton(
                                        pathName: AssetConstants.commentIcon,
                                        text: (tweet.commentIds.length)
                                            .toString(),
                                        onTap: () {},
                                      ),
                                      TweetIconButton(
                                        pathName: AssetConstants.retweetIcon,
                                        text: (tweet.reshareCount).toString(),
                                        onTap: () {
                                          ref
                                              .read(tweetControllerProvider
                                                  .notifier)
                                              .reshareTweet(
                                                tweet,
                                                currentUser,
                                                context,
                                              );
                                        },
                                      ),
                                      LikeButton(
                                        size: 25,
                                        isLiked: tweet.likes
                                            .contains(currentUser.uid),
                                        onTap: (isLiked) async {
                                          ref
                                              .read(tweetControllerProvider
                                                  .notifier)
                                              .likeTweet(tweet, currentUser);
                                          return !isLiked;
                                        },
                                        likeBuilder: (isLiked) {
                                          return isLiked
                                              ? SvgPicture.asset(
                                                  AssetConstants.likeFilledIcon,
                                                  color: Pallete.redColor,
                                                )
                                              : SvgPicture.asset(
                                                  AssetConstants
                                                      .likeOutlinedIcon,
                                                  color: Pallete.greyColor,
                                                );
                                        },
                                        likeCount: tweet.likes.length,
                                        countBuilder:
                                            (likeCount, isLiked, text) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              left: 2.0,
                                            ),
                                            child: Text(
                                              text,
                                              style: TextStyle(
                                                ///I'll check here since the original doesn't equate isLiked to true
                                                color: isLiked == true
                                                    ? Pallete.redColor
                                                    : Pallete.whiteColor,
                                                fontSize: 16,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.share_outlined,
                                          size: 25,
                                          color: Pallete.greyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Pallete.greyColor,
                      )
                    ],
                  ),
                );
              },
              error: (error, stackTrace) {
                return ErrorText(
                  error: error.toString(),
                );
              },
              loading: () => const Loader(),
            );
  }
}
