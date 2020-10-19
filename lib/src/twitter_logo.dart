import 'package:flutter/material.dart';

class TwitterLogo extends StatelessWidget {
  const TwitterLogo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/tw__ic_logo_blue.png",
      fit: BoxFit.fitWidth,
      package: 'tweet_ui',
      height: MediaQuery.of(context).size.width * 0.045,
      width: MediaQuery.of(context).size.width * 0.045,
    );
  }
}
