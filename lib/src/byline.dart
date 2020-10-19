import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tweet_ui/models/viewmodels/tweet_vm.dart';
import 'package:tweet_ui/src/twitter_logo.dart';
// import 'package:tweet_ui/src/url_launcher.dart';
import 'package:tweet_ui/src/verified_user_badge.dart';
import 'package:tweet_ui/src/view_mode.dart';

/// Widget that displays user name, user screen name (the @ name), if the user is verified
class Byline extends StatelessWidget {
  const Byline(
    this.tweetVM,
    this.viewMode, {
    Key key,
    this.showDate,
    this.userNameStyle,
    this.userScreenNameStyle,
    @required this.onUsernamePressed,
  }) : super(key: key);

  final TweetVM tweetVM;
  final bool showDate;
  final TextStyle userNameStyle;
  final TextStyle userScreenNameStyle;
  final ViewMode viewMode;
  final Function(String) onUsernamePressed;

  @override
  Widget build(BuildContext context) {
    switch (viewMode) {
      case ViewMode.standard:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: AutoSizeText(
                    tweetVM.getDisplayTweet().userName,
                    textAlign: TextAlign.start,
                    style: userNameStyle,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    minFontSize: userNameStyle.fontSize,
                    stepGranularity: userNameStyle.fontSize,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0, right: 20),
                  child: VerifiedUsedBadge(tweetVM.getDisplayTweet(), viewMode),
                ),
              ],
            ),
            if (showDate == null || showDate == true)
              AutoSizeText(
                "@${tweetVM.getDisplayTweet().userScreenName} • ${tweetVM.getDisplayTweet().createdAt}",
                textAlign: TextAlign.start,
                style: userScreenNameStyle,
                minFontSize: userScreenNameStyle.fontSize,
                stepGranularity: userScreenNameStyle.fontSize,
                maxLines: 1,
              )
            else
              AutoSizeText(
                "@${tweetVM.getDisplayTweet().userScreenName}",
                textAlign: TextAlign.start,
                style: userScreenNameStyle,
                minFontSize: userScreenNameStyle.fontSize,
                stepGranularity: userScreenNameStyle.fontSize,
                maxLines: 1,
              ),
          ],
        );
        break;
      case ViewMode.compact:
      case ViewMode.quote:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () =>
                    onUsernamePressed(tweetVM.getDisplayTweet().userScreenName),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AutoSizeText(
                      tweetVM.getDisplayTweet().userName,
                      style: userNameStyle,
                      textAlign: TextAlign.start,
                      minFontSize: userNameStyle.fontSize,
                      stepGranularity: userNameStyle.fontSize,
                      maxLines: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: VerifiedUsedBadge(
                          tweetVM.getDisplayTweet(), viewMode),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: AutoSizeText(
                          "@${tweetVM.getDisplayTweet().userScreenName}",
                          style: userScreenNameStyle,
                          minFontSize: userScreenNameStyle.fontSize,
                          stepGranularity: userScreenNameStyle.fontSize,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    if (showDate == null || showDate == true)
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: AutoSizeText(
                            "• ${tweetVM.getDisplayTweet().createdAt}",
                            style: userScreenNameStyle,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            minFontSize: userScreenNameStyle.fontSize,
                            stepGranularity: userScreenNameStyle.fontSize,
                            softWrap: false,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      )
                    else
                      Container(),
                  ],
                ),
              ),
            ),
            const TwitterLogo(),
          ],
        );
      default:

        /// should never happen
        return Container();
    }
  }
}
