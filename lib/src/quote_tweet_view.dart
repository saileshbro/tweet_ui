import 'package:flutter/material.dart';
import 'package:tweet_ui/models/viewmodels/tweet_vm.dart';
import 'package:tweet_ui/on_tap_image.dart';
import 'package:tweet_ui/src/byline.dart';
import 'package:tweet_ui/src/media_container.dart';
import 'package:tweet_ui/src/tweet_text.dart';
import 'package:tweet_ui/src/view_mode.dart';

typedef onTapImage = void Function(
    List<String> allPhotos, int photoIndex, String hashcode);

class QuoteTweetView extends StatelessWidget {
  final TweetVM tweetVM;
  final TextStyle userNameStyle;
  final TextStyle userScreenNameStyle;
  final TextStyle textStyle;
  final TextStyle clickableTextStyle;
  final Color borderColor;
  final Color backgroundColor;
  final OnTapImage onTapImage;
  final Function(String username) onUsernamePressed;
  final Function(String hashtag) onHashtagPressed;
  final Function(String url) onUrlPressed;
  final Function(String symbol) onSymbolPressed;
  const QuoteTweetView(
    this.tweetVM, {
    this.userNameStyle,
    this.userScreenNameStyle,
    this.textStyle,
    this.clickableTextStyle,
    this.borderColor,
    this.backgroundColor,
    this.onTapImage,
    @required this.onUsernamePressed,
    @required this.onHashtagPressed,
    @required this.onUrlPressed,
    @required this.onSymbolPressed,
  }); //  TweetView(this.tweetVM);

  const QuoteTweetView.fromTweet(
    this.tweetVM, {
    this.userNameStyle,
    this.userScreenNameStyle,
    this.textStyle,
    this.clickableTextStyle,
    this.borderColor,
    this.backgroundColor,
    this.onTapImage,
    @required this.onUsernamePressed,
    @required this.onHashtagPressed,
    @required this.onUrlPressed,
    @required this.onSymbolPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onUrlPressed(tweetVM.tweetLink);
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Byline(
                      tweetVM,
                      ViewMode.quote,
                      userNameStyle: userNameStyle,
                      userScreenNameStyle: userScreenNameStyle,
                      onUsernamePressed: onUsernamePressed,
                    ),
                    TweetText(
                      tweetVM,
                      textStyle: textStyle,
                      clickableTextStyle: clickableTextStyle,
                      onUsernamePressed: onUsernamePressed,
                      onHashtagPressed: onHashtagPressed,
                      onUrlPressed: onUrlPressed,
                      onSymbolPressed: onSymbolPressed,
                    ),
                  ],
                ),
              ),
              MediaContainer(
                tweetVM,
                ViewMode.quote,
                useVideoPlayer: false,
                onTapImage: onTapImage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
