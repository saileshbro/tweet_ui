import 'package:flutter/material.dart';
import 'package:tweet_ui/models/viewmodels/tweet_vm.dart';

/// Widget that displays user name that retweeted a Tweet
class RetweetInformation extends StatelessWidget {
  const RetweetInformation(
    this.tweetVM, {
    Key key,
    this.retweetInformationStyle,
    @required this.onUsernamePressed,
  }) : super(key: key);

  final TweetVM tweetVM;
  final TextStyle retweetInformationStyle;
  final Function(String) onUsernamePressed;

  @override
  Widget build(BuildContext context) {
    if (tweetVM.retweetedTweet != null) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        // onTap: () {
        //   openUrl(tweetVM.userLink);
        // },
        onTap: () => onUsernamePressed(tweetVM.userScreenName),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      "assets/tw__ic_retweet_light.png",
                      fit: BoxFit.fitWidth,
                      package: 'tweet_ui',
                      color: retweetInformationStyle.color,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Text(
                        "Retweeted by ${tweetVM.userName}",
                        style: retweetInformationStyle,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
