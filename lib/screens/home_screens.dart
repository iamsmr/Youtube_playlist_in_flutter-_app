import 'package:YoutuebPlayer/models/channel_info.dart';
import 'package:YoutuebPlayer/models/videos_list.dart';
import 'package:YoutuebPlayer/screens/video_player_screens.dart';
import 'package:YoutuebPlayer/utils/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ChannelInfo _channelInfo;
  VideosList _videosList;
  String _nextPageToken;
  Item _item;
  bool _loading = true;
  String _playlistId;

  @override
  void initState() {
    _getChannelInfo();
    super.initState();
  }

  _getChannelInfo() async {
    _channelInfo = await Services.getChannelInfo();
    _videosList = VideosList();
    _videosList.videos = List();
    _nextPageToken = '';
    _item = _channelInfo.items[0];
    _playlistId = _item.contentDetails.relatedPlaylists.uploads;
    print("playllist id $_playlistId");
    await _loadVideo();
    setState(() {
      _loading = false;
    });
  }

  _loadVideo() async {
    VideosList tempVideoList = await Services.getVideosList(
      _playlistId,
      _nextPageToken,
    );
    _nextPageToken = tempVideoList.nextPageToken;
    _videosList.videos.addAll(tempVideoList.videos);
    print("vidoes ${_videosList.videos.length}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Youtube"),
      ),
      body: Column(
        children: [
          _buildInfoView(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              itemCount: _videosList.videos.length,
              itemBuilder: (context, index) {
                VideoItem videoItem = _videosList.videos[index];
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoPlayer(
                        videoItem: videoItem,
                      ),
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              videoItem.video.thumbnails.thumbnailsDefault.url,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            // color: Colors.pink,
                            child: Column(
                              children: [
                                Text(
                                  videoItem.video.title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  videoItem.video.description,
                                  style: TextStyle(color: Colors.grey),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  // maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  _buildInfoView() {
    return _loading
        ? Center(
            child: LinearProgressIndicator(),
          )
        : Container(
            padding: EdgeInsets.all(20),
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    _item.snippet.thumbnails.medium.url,
                  ),
                ),
                title: Text(_item.snippet.title),
              ),
            ),
          );
  }
}
