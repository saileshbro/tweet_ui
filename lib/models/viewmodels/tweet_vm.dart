import 'package:intl/intl.dart';
import 'package:tweet_ui/models/api/entities/entity.dart';
import 'package:tweet_ui/models/api/entities/media_entity.dart';
import 'package:tweet_ui/models/api/entities/tweet_entities.dart';
import 'package:tweet_ui/models/api/tweet.dart';

class TweetVM {
  static const String _kPhotoType = "photo";
  static const String _kVideoType = "video";
  static const String _kGifType = "animated_gif";
  static const String _kTwitterUrl = "https://twitter.com/";
  static const String _kUnknownScreenName = "twitter_unknown";

  final String createdAt;
  final bool hasSupportedVideo;
  final List<Entity> allEntities;
  final bool hasPhoto;
  final bool hasGif;
  final String tweetLink;
  // final String userLink;
  final String text;
  final Runes textRunes;
  final String profileUrl;
  final List<String> allPhotos;
  final String userName;
  final String userScreenName;
  final TweetVM quotedTweet;
  final TweetVM retweetedTweet;
  final bool userVerified;
  final String videoPlaceholderUrl;
  final String videoUrl;
  final double videoAspectRatio;
  final int favoriteCount;
  final int retweetsCount;
  final int startDisplayText;
  final int endDisplayText;

  TweetVM({
    this.createdAt,
    this.hasSupportedVideo,
    this.allEntities,
    this.hasPhoto,
    this.hasGif,
    this.tweetLink,
    // this.userLink,
    this.text,
    this.textRunes,
    this.profileUrl,
    this.allPhotos,
    this.userName,
    this.userScreenName,
    this.quotedTweet,
    this.retweetedTweet,
    this.userVerified,
    this.videoPlaceholderUrl,
    this.videoUrl,
    this.videoAspectRatio,
    this.favoriteCount,
    this.startDisplayText,
    this.endDisplayText,
    this.retweetsCount,
  });
  factory TweetVM._quotedTweet(
      Tweet tweet, DateFormat createdDateDisplayFormat) {
    if (tweet != null) {
      return TweetVM.fromApiModel(tweet, createdDateDisplayFormat);
    } else {
      return null;
    }
  }
  factory TweetVM.fromApiModel(
          Tweet tweet, DateFormat createdDateDisplayFormat) =>
      TweetVM(
        createdAt: _createdAt(tweet, createdDateDisplayFormat),
        hasSupportedVideo: _hasSupportedVideo(tweet),
        allEntities: _allEntities(tweet),
        hasPhoto: _hasPhoto(tweet),
        hasGif: _hasGif(tweet),
        tweetLink: _tweetLink(tweet),
        // userLink: _userLink(tweet),
        text: _text(tweet),
        textRunes: _runes(tweet),
        profileUrl: _profileURL(tweet),
        allPhotos: _allPhotos(tweet),
        userName: _userName(tweet),
        userScreenName: _userScreenName(tweet),
        quotedTweet:
            TweetVM._quotedTweet(tweet.quotedStatus, createdDateDisplayFormat),
        retweetedTweet: TweetVM._retweetedTweet(
            tweet.retweetedStatus, createdDateDisplayFormat),
        userVerified: _userVerified(tweet),
        videoPlaceholderUrl: _videoPlaceholderUrl(tweet),
        videoUrl: _videoUrl(tweet),
        videoAspectRatio: _videoAspectRatio(tweet),
        favoriteCount: _favoriteCount(tweet),
        retweetsCount: _retweetsCount(tweet),
        startDisplayText: _startDisplayText(tweet),
        endDisplayText: _endDisplayText(tweet),
      );

  static String _createdAt(Tweet tweet, DateFormat displayFormat) {
    final dateTime = DateTime.parse(tweet.createdAt).toLocal();
    return (displayFormat ?? DateFormat("EEE MMM dd, yyyy h:mm a"))
        .format(dateTime);
  }

  static bool _isPhotoType(MediaEntity mediaEntity) {
    return _kPhotoType == mediaEntity.type;
  }

  static bool _isVideoType(MediaEntity mediaEntity) {
    return _kVideoType == mediaEntity.type || _kGifType == mediaEntity.type;
  }

  static bool _isGifType(MediaEntity mediaEntity) {
    return _kGifType == mediaEntity.type;
  }

  static bool _hasSupportedVideo(Tweet tweet) {
    final MediaEntity entity = _videoEntity(tweet);
    return entity != null;
  }

  static MediaEntity _videoEntity(Tweet tweet) {
    try {
      return _allMediaEntities(tweet).firstWhere(
        (MediaEntity mediaEntity) =>
            mediaEntity.type != null && _isVideoType(mediaEntity),
      );
    } catch (e) {
      return null;
    }
  }

  static List<MediaEntity> _allMediaEntities(Tweet tweet) {
    final List<MediaEntity> allEntities = [];
    final TweetEntities entities = tweet.entities;
    final TweetEntities extendedEntities = tweet.extendedEntities;
    if (entities != null && entities.media != null) {
      allEntities.addAll(entities.media);
    }
    if (extendedEntities != null && extendedEntities.media != null) {
      allEntities.addAll(extendedEntities.media);
    }
    return allEntities;
  }

  static List<Entity> _allEntities(Tweet tweet) {
    final List<Entity> allEntities = [];
    final TweetEntities entities = tweet.entities;

    if (entities != null) {
      if (entities.media != null) {
        allEntities.addAll(entities.media);
      }
      if (entities.hashtags != null) {
        allEntities.addAll(entities.hashtags);
      }
      if (entities.symbols != null) {
        allEntities.addAll(entities.symbols);
      }
      if (entities.urls != null) {
        allEntities.addAll(entities.urls);
      }
      if (entities.userMentions != null) {
        allEntities.addAll(entities.userMentions);
      }
    }
    allEntities.sort((a, b) => a.start.compareTo(b.start));
    return allEntities;
  }

  //
  static MediaEntity _photoEntity(Tweet tweet) {
    final List<MediaEntity> mediaEntityList = _allMediaEntities(tweet);
    for (int i = mediaEntityList.length - 1; i >= 0; i--) {
      final MediaEntity entity = mediaEntityList[i];
      if (entity.type != null && _isPhotoType(entity)) {
        return entity;
      }
    }
    return null;
  }

  static MediaEntity _gifEntity(Tweet tweet) {
    final List<MediaEntity> mediaEntityList = _allMediaEntities(tweet);
    for (int i = mediaEntityList.length - 1; i >= 0; i--) {
      final MediaEntity entity = mediaEntityList[i];
      if (entity.type != null && _isGifType(entity)) {
        return entity;
      }
    }
    return null;
  }

  static bool _hasPhoto(Tweet tweet) {
    return _photoEntity(tweet) != null;
  }

  static bool _hasGif(Tweet tweet) {
    return _gifEntity(tweet) != null;
  }

  static String _tweetLink(Tweet tweet) {
    if (tweet.id <= 0) {
      return null;
    }
    if (tweet.user.screenName.isEmpty) {
      return "$_kTwitterUrl$_kUnknownScreenName/status/${tweet.idStr}";
    } else {
      return "$_kTwitterUrl${tweet.user.screenName}/status/${tweet.idStr}";
    }
  }

  static String _text(Tweet tweet) {
    return tweet.text;
  }

  static Runes _runes(Tweet tweet) {
    return tweet.text.runes;
  }

  static String _profileURL(Tweet tweet) {
    return tweet.user.profileImageUrlHttps;
  }

  static List<String> _allPhotos(Tweet tweet) {
    return tweet.extendedEntities?.media?.where((MediaEntity mediaEntity) {
      return _isPhotoType(mediaEntity);
    })?.map((MediaEntity mediaEntity) {
      return mediaEntity.mediaUrlHttps;
    })?.toList(growable: false);
  }

  static String _userName(Tweet tweet) {
    return tweet.user.name;
  }

  static String _userScreenName(Tweet tweet) {
    return tweet.user.screenName;
  }

  factory TweetVM._retweetedTweet(
      Tweet tweet, DateFormat createdDateDisplayFormat) {
    if (tweet != null) {
      return TweetVM.fromApiModel(tweet, createdDateDisplayFormat);
    } else {
      return null;
    }
  }

  static bool _userVerified(Tweet tweet) {
    return tweet.user.verified;
  }

  static String _videoPlaceholderUrl(Tweet tweet) {
    return _videoEntity(tweet)?.mediaUrlHttps;
  }

  static String _videoUrl(Tweet tweet) {
    return _videoEntity(tweet)?.videoInfo?.variants?.first?.url;
  }

  static double _videoAspectRatio(Tweet tweet) {
    final VideoInfo videoInfo = _videoEntity(tweet)?.videoInfo;
    if (videoInfo != null) {
      return videoInfo?.aspectRatio[0] / videoInfo?.aspectRatio[1];
    } else {
      return null;
    }
  }

  static int _favoriteCount(Tweet tweet) {
    return tweet.favoriteCount;
  }

  static int _retweetsCount(Tweet tweet) {
    return tweet.retweetCount;
  }

  static int _startDisplayText(Tweet tweet) {
    return tweet.displayTextRange != null ? tweet.displayTextRange[0] : 0;
  }

  static int _endDisplayText(Tweet tweet) {
    return tweet.displayTextRange != null
        ? tweet.displayTextRange[1]
        : _runes(tweet).length;
  }
}

extension ExtendedText on TweetVM {
  TweetVM getDisplayTweet() {
    if (retweetedTweet != null) {
      return retweetedTweet;
    } else {
      return this;
    }
  }
}
