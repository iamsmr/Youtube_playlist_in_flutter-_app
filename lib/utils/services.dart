import 'dart:io';

import 'package:YoutuebPlayer/models/channel_info.dart';
import 'package:YoutuebPlayer/models/videos_list.dart';
import 'package:YoutuebPlayer/utils/const.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Services {
  static const String CHANNEL_ID = "UCuViWv2p29IcS4EPMoDz6ew";
  static const _base_url = "youtube.googleapis.com";

  // curl \
  // 'https://youtube.googleapis.com/youtube/v3/channels?part=snippet%2CcontentDetails%2Cstatistics&id=UCuViWv2p29IcS4EPMoDz6ew&access_token=AIzaSyA17i_qkHvXdAe7uL4BNrFoVZ3X9-xLXYM&key=[YOUR_API_KEY]' \
  // --header 'Authorization: Bearer [YOUR_ACCESS_TOKEN]' \
  // --header 'Accept: application/json' \
  // --compressed

  static Future<ChannelInfo> getChannelInfo() async {
    Map<String, String> paramaters = {
      'part': "snippet,contentDetails,statistics",
      'id': CHANNEL_ID,
      'key': Const.key,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    Uri uri = Uri.https(_base_url, "/youtube/v3/channels", paramaters);
    Response response = await http.get(uri, headers: headers);
    print(response.body);
    ChannelInfo channelInfo = channelInfoFromJson(response.body);
    return channelInfo;
  }

  static Future<VideosList> getVideosList(
      String playListId, String pageToken) async {
    Map<String, String> paramaters = {
      'part': "snippet,contentDetails",
      "playlistId": playListId,
      'maxResults': "8",
      'pageToken': pageToken,
      'key':Const.key
    };
     Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    Uri uri = Uri.https(_base_url, "youtube/v3/playlistItems", paramaters);
    Response response = await http.get(uri, headers: headers);
    print(response.body);
    VideosList videosList = videosListFromJson(response.body);
    return videosList;
  }
}
