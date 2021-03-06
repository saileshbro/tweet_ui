import 'dart:convert';

import 'package:tweet_ui/models/api/entities/entity.dart';

/// Represents other Twitter users mentioned in the text of the Tweet.
class MentionEntity extends Entity {
  /// Screen name of the referenced user.
  String screenName;

  MentionEntity({
    this.screenName,
    indices,
  }) : super(indices: indices);

  factory MentionEntity.fromRawJson(String str) =>
      MentionEntity.fromJson(json.decode(str));

  factory MentionEntity.fromJson(Map<String, dynamic> json) => MentionEntity(
        screenName: json["screen_name"],
        indices: json["indices"] == null
            ? null
            : List<int>.from(json["indices"].map((x) => x)),
      );
}
