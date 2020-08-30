import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:tweet_ui/models/api/entities/hashtag_entity.dart';
import 'package:tweet_ui/models/api/entities/mention_entity.dart';
import 'package:tweet_ui/models/api/entities/symbol_entity.dart';
import 'package:tweet_ui/models/api/entities/url_entity.dart';
import 'package:tweet_ui/models/viewmodels/tweet_vm.dart';

class TweetText extends StatelessWidget {
  final TweetVM tweetVM;
  final TextStyle textStyle;
  final TextStyle clickableTextStyle;
  final EdgeInsetsGeometry padding;
  final Function(String username) onUsernamePressed;
  final Function(String hashtag) onHashtagPressed;
  final Function(String url) onUrlPressed;
  final Function(String symbol) onSymbolPressed;

  const TweetText(
    this.tweetVM, {
    Key key,
    this.textStyle,
    this.clickableTextStyle,
    this.padding,
    @required this.onUsernamePressed,
    @required this.onHashtagPressed,
    @required this.onUrlPressed,
    @required this.onSymbolPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spans = _getSpans(context);
    if (spans.isNotEmpty) {
      return Padding(
        padding: padding,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: RichText(
            text: TextSpan(children: spans),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  List<TextSpan> _getSpans(BuildContext context) {
    final List<TextSpan> spans = [];
    int boundary = tweetVM.startDisplayText;
    final unescape = HtmlUnescape();

    if (tweetVM.startDisplayText == 0 && tweetVM.endDisplayText == 0) return [];

    if (tweetVM.allEntities.isEmpty) {
      spans.add(TextSpan(
        text: unescape.convert(tweetVM.text),
        style: textStyle,
      ));
    } else {
      tweetVM.allEntities.asMap().forEach((index, entity) {
        // look for the next match
        final startIndex = entity.start;

        // respect the `display_text_range` from JSON.
        if (startIndex > tweetVM.endDisplayText) return;

        // add any plain text before the next entity
        if (startIndex > boundary) {
          spans.add(TextSpan(
            text: unescape.convert(String.fromCharCodes(tweetVM.textRunes,
                boundary, min(startIndex, tweetVM.endDisplayText))),
            style: textStyle,
          ));
        }

        if (entity.runtimeType == UrlEntity) {
          final UrlEntity urlEntity = entity as UrlEntity;
          final spanText = unescape.convert(urlEntity.displayUrl);
          spans.add(
            TextSpan(
              text: spanText,
              style: clickableTextStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () => onUrlPressed(urlEntity.expandedUrl),
            ),
          );
        } else {
          final spanText = unescape.convert(
            String.fromCharCodes(tweetVM.textRunes, startIndex,
                min(entity.end, tweetVM.endDisplayText)),
          );
          spans.add(TextSpan(
            text: spanText,
            style: clickableTextStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                if (entity.runtimeType == MentionEntity) {
                  final MentionEntity mentionEntity = entity as MentionEntity;
                  onUsernamePressed(mentionEntity.screenName);
                } else if (entity.runtimeType == SymbolEntity) {
                  final SymbolEntity symbolEntity = entity as SymbolEntity;
                  onSymbolPressed(symbolEntity.text);
                } else if (entity.runtimeType == HashtagEntity) {
                  final HashtagEntity hashtagEntity = entity as HashtagEntity;
                  onHashtagPressed(hashtagEntity.text);
                }
              },
          ));
        }

        // update the boundary to know from where to start the next iteration
        boundary = entity.end;
      });

      spans.add(TextSpan(
        text: unescape.convert(String.fromCharCodes(tweetVM.textRunes, boundary,
            min(tweetVM.textRunes.length, tweetVM.endDisplayText))),
        style: textStyle,
      ));
    }

    return spans;
  }
}
