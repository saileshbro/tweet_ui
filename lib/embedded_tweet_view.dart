import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tweet_ui/default_text_styles.dart';
import 'package:tweet_ui/models/api/tweet.dart';
import 'package:tweet_ui/models/viewmodels/tweet_vm.dart';
import 'package:tweet_ui/on_tap_image.dart';
import 'package:tweet_ui/src/byline.dart';
import 'package:tweet_ui/src/media_container.dart';
import 'package:tweet_ui/src/profile_image_embedded.dart';
import 'package:tweet_ui/src/quote_tweet_view_embedded.dart';
import 'package:tweet_ui/src/retweet.dart';
import 'package:tweet_ui/src/tweet_text.dart';
import 'package:tweet_ui/src/twitter_logo.dart';
import 'package:tweet_ui/src/view_mode.dart';

class EmbeddedTweetView extends StatelessWidget {
  /// Business logic class created from [TweetVM.fromApiModel]
  final TweetVM _tweetVM;

  /// Background color for the container
  final Color backgroundColor;

  /// If set to true the the text and icons will be light
  final bool darkMode;

  /// If set to true a chewie/video_player will be used in a Tweet containing a video.
  /// If set to false a image placeholder will he shown and a video will be played in a new page.
  final bool useVideoPlayer;

  /// If the Tweet contains a video then an initial volume can be specified with a value between 0.0 and 1.0.
  final double videoPlayerInitialVolume;

  /// Function used when you want a custom image tapped callback
  final OnTapImage onTapImage;

  /// Date format when the tweet was created. When null it defaults to DateFormat("HH:mm • MM.dd.yyyy", 'en_US')
  final DateFormat createdDateDisplayFormat;
  final Function(String tweeetId) onTweetPressed;
  final Function(String username) onUsernamePressed;
  final Function(String hashtag) onHashtagPressed;
  final Function(String url) onUrlPressed;
  final Function(String symbol) onSymbolPressed;
  final TextStyle tweetTextStyle;
  final TextStyle clickableTextStyle;
  final bool showOtherTweetsBanner;
  final TextStyle userNameStyle;
  final TextStyle userScreenNameStyle;
  final TextStyle retweetInformationStyle;

  /// If true, it will show the likes, retweets and time it was created
  final bool showTweetInteractions;
  const EmbeddedTweetView(
    this._tweetVM, {
    this.backgroundColor,
    this.darkMode,
    this.useVideoPlayer,
    @required this.onTweetPressed,
    this.videoPlayerInitialVolume,
    this.onTapImage,
    this.createdDateDisplayFormat,
    @required this.onUsernamePressed,
    @required this.onHashtagPressed,
    @required this.onUrlPressed,
    @required this.onSymbolPressed,
    this.tweetTextStyle,
    this.showOtherTweetsBanner = false,
    this.showTweetInteractions = false,
    this.userNameStyle,
    this.userScreenNameStyle,
    this.clickableTextStyle,
    this.retweetInformationStyle,
  }); //  TweetView(this.tweetVM);

  EmbeddedTweetView.fromTweet(
    Tweet tweet, {
    this.backgroundColor = Colors.white,
    this.darkMode = false,
    this.useVideoPlayer = true,
    this.videoPlayerInitialVolume = 0.0,
    this.onTapImage,
    @required this.onTweetPressed,
    this.createdDateDisplayFormat,
    @required this.onUsernamePressed,
    @required this.onHashtagPressed,
    @required this.onUrlPressed,
    @required this.onSymbolPressed,
    this.tweetTextStyle,
    this.showOtherTweetsBanner = false,
    this.showTweetInteractions = false,
    this.userNameStyle,
    this.userScreenNameStyle,
    this.clickableTextStyle,
    this.retweetInformationStyle,
  }) : _tweetVM = TweetVM.fromApiModel(tweet, createdDateDisplayFormat);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () => onTweetPressed(_tweetVM.tweetLink),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => onUsernamePressed(
                      _tweetVM.getDisplayTweet().userScreenName),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          RetweetInformation(
                            _tweetVM,
                            retweetInformationStyle:
                                defaultEmbeddedRetweetInformationStyle
                                    .merge(retweetInformationStyle),
                            onUsernamePressed: onUsernamePressed,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: <Widget>[
                              ProfileImage(tweetVM: _tweetVM),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Byline(
                                  _tweetVM,
                                  ViewMode.standard,
                                  onUsernamePressed: onUsernamePressed,
                                  userNameStyle:
                                      defaultUserNameStyle.merge(userNameStyle),
                                  showDate: false,
                                  userScreenNameStyle:
                                      defaultEmbeddedUserNameStyle
                                          .merge(userScreenNameStyle),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Align(
                        alignment: Alignment.topRight,
                        child: TwitterLogo(),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    onTweetPressed(_tweetVM.tweetLink);
                  },
                  child: TweetText(
                    _tweetVM,
                    textStyle: darkMode
                        ? defaultEmbeddedDarkTextStyle.merge(tweetTextStyle)
                        : defaultEmbeddedTextStyle.merge(tweetTextStyle),
                    clickableTextStyle: defaultEmbeddedClickableTextStyle
                        .merge(clickableTextStyle),
                    onHashtagPressed: onHashtagPressed,
                    onUrlPressed: onUrlPressed,
                    onUsernamePressed: onUsernamePressed,
                    onSymbolPressed: onSymbolPressed,
                  ),
                ),
                if (_tweetVM.quotedTweet != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0)
                        .copyWith(top: 4),
                    child: QuoteTweetViewEmbed.fromTweet(
                      _tweetVM.quotedTweet,
                      textStyle: darkMode
                          ? defaultEmbeddedDarkTextStyle.merge(tweetTextStyle)
                          : defaultEmbeddedTextStyle.merge(tweetTextStyle),
                      onUsernamePressed: onUsernamePressed,
                      onTweetPressed: onTweetPressed,
                      clickableTextStyle: defaultQuoteClickableTextStyle
                          .merge(clickableTextStyle),
                      userNameStyle: darkMode
                          ? defaultEmbeddedDarkQuoteUserNameStyle
                              .merge(userNameStyle)
                          : defaultQuoteUserNameStyle.merge(userNameStyle),
                      userScreenNameStyle: defaultQuoteUserScreenNameStyle
                          .merge(userScreenNameStyle),
                      onTapImage: onTapImage,
                      onHashtagPressed: onHashtagPressed,
                      onUrlPressed: onUrlPressed,
                      onSymbolPressed: onSymbolPressed,
                    ),
                  ),
              ],
            ),
          ),
          MediaContainer(
            _tweetVM,
            ViewMode.standard,
            useVideoPlayer: useVideoPlayer,
            videoPlayerInitialVolume: videoPlayerInitialVolume,
            onTapImage: onTapImage,
          ),
          if (showTweetInteractions)
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                children: <Widget>[
                  Icon(Icons.favorite_border,
                      color: darkMode ? Colors.grey[400] : Colors.grey[600],
                      size: 0.045 * MediaQuery.of(context).size.width),
                  Container(
                    margin: const EdgeInsets.only(left: 6),
                    child: Text(
                      _tweetVM.favoriteCount.toString(),
                      style: TextStyle(
                        color: darkMode ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 0.035 * MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    "assets/tw__ic_retweet_light.png",
                    fit: BoxFit.fitWidth,
                    package: 'tweet_ui',
                    width: 0.043 * MediaQuery.of(context).size.width,
                    color: darkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 6),
                    child: Text(
                      _tweetVM.retweetsCount.toString(),
                      style: TextStyle(
                        color: darkMode ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 0.035 * MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16),
                    child: Text(
                      _tweetVM.createdAt,
                      style: TextStyle(
                        fontSize: 0.035 * MediaQuery.of(context).size.width,
                        color: darkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  )
                ],
              ),
            ),
          if (showOtherTweetsBanner) ...[
            Divider(
              color: Colors.grey[400],
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 15, top: 5),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => onUsernamePressed(_tweetVM.userScreenName),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: darkMode ? Colors.blue[100] : Colors.blue[700],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "${_tweetVM.userName}'s other tweets",
                          style: TextStyle(
                              color: darkMode
                                  ? Colors.blue[100]
                                  : Colors.blue[800],
                              fontWeight: FontWeight.w400),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}
