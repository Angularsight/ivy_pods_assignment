import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:ivy_pods_assignment/dataset_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ivy Pods Internship',
      theme: ThemeData(
        canvasColor: Colors.black,
        primarySwatch: Colors.blue,
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late ScrollController _scrollController;
  ScrollDirection _scrollDirection = ScrollDirection.idle;
  // ScrollDirection _currentScrollDirection = ScrollDirection.idle;
  late VideoPlayerController _videoPlayer;
  VideoProgressIndicator? a;

  double _videoPlayerDecider = 0;
  int _videoPlayerIndex = 0;
  bool _scrollingStopped = true;
  var somethingElse = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController = ScrollController();
    _initVideoController(_videoPlayerIndex);

    WidgetsBinding.instance!.addPersistentFrameCallback((timeStamp) {
      _scrollController.addListener(() {
        /// Here the user is scrolling
        _scrollingStopped = false;
        _videoPlayer.pause();
      });
      _scrollController.position.isScrollingNotifier.addListener(() {
        if (!_scrollController.position.isScrollingNotifier.value) {
          setState(() {
            //Getting the scrollDirection
            _scrollDirectionList
                .add(_scrollController.position.userScrollDirection);

            /// This means the user is not scrolling
            _scrollingStopped = true;
            _videoPlayerDecider = _scrollController.position.pixels;

            /// Integer division = a ~/b
            if (_scrollController.position.pixels <= 2500) {

              _videoPlayerIndex = _videoPlayerDecider ~/ 250;
              _updateVideoController1(_videoPlayerIndex);
            }
          });
        } else {
          /// Here the user starts scrolling
        }
      });
    });
  }

  void _initVideoController(int index) {
    _videoPlayer = VideoPlayerController.network(
        DatasetProvider.datasetProvider[index]['videoUrl'],
        formatHint: VideoFormat.hls)
      ..initialize().then((value) {
        setState(() {});
      });

    _videoPlayer.play();
    if (_mute == true) {
      _videoPlayer.setVolume(0.0);
    } else {
      _videoPlayer.setVolume(10.0);
    }
  }

  _updateVideoController1(int index) {
    final oldController = _videoPlayer;
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await oldController.dispose();
      _initVideoController(index);
    });
  }

  _updateVideoController2(int index) {
    final oldController = _videoPlayer;
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await oldController.dispose();
      _initVideoController(index);
    });
  }

  bool _mute = true;
  bool _captions = false;
  bool _reverseScroll = false;
  var _scrollDirectionList = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoPlayer.dispose();
  }

  List<String> bottomSheetList = [
    'All',
    'Mixes',
    'Music',
    'Tennis',
    'International',
    'Sports',
    'Bollywood',
    'Sandalwood'
  ];
  int _bottomSheetIndex = 0;
  int _bottomNavigationBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    const t = TextStyle(fontSize: 18, color: Colors.white);
    var delay = 500;

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          setState(() {
            print('Notification Listenerrrrrrrrrrrrrrrr:${notification.direction}');
            if(notification.direction == ScrollDirection.reverse){
              _reverseScroll = false;
            }else if(notification.direction == ScrollDirection.forward){
              _reverseScroll = true;
            }
          });
          return true;
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: false,
              elevation: 8,
              backgroundColor: Colors.black87,
              leadingWidth: 300,
              leading: SizedBox(
                  height: 70,
                  width: 70,
                  child: Image.asset(
                    'images/yt_logo_dark_mode.png',
                    fit: BoxFit.cover,
                  )),
              actions: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.cast,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.account_circle_outlined,
                    color: Colors.white,
                  ),
                )
              ],
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 50),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 38,
                        width: w * 0.24,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(
                              Icons.explore_outlined,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              "Explore",
                              style: t.copyWith(fontSize: 14),
                            ),
                            const SizedBox(
                              width: 2,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 2,
                        height: 40,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                          width: w * 0.6,
                          height: 30,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _bottomSheetIndex = index;
                                    });
                                  },
                                  child: index == _bottomSheetIndex
                                      ? Container(
                                          width: w * 0.1,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                              child: Text(
                                            bottomSheetList[index],
                                            style: t.copyWith(
                                                fontSize: 12,
                                                color: Colors.black),
                                          )),
                                        )
                                      : Container(
                                          width: w * 0.2,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade700,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                              child: Text(
                                            bottomSheetList[index],
                                            style: t.copyWith(fontSize: 12),
                                          )),
                                        ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    width: 10,
                                  ),
                              itemCount: bottomSheetList.length))
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, index) {
                final dataset = DatasetProvider.datasetProvider;
                return VisibilityDetector(
                  key: Key(index.toString()),
                  onVisibilityChanged: (VisibilityInfo info) {
                    if (info.visibleFraction == 1) {
                      if (_scrollController.position.pixels > 2500 && _reverseScroll ==false) {
                        setState(() {
                          int doubleIndex = int.parse(
                              info.key.toString().substring(3, 5));
                          _videoPlayerIndex = doubleIndex - 1;
                          Future.delayed(Duration(milliseconds: delay), () {
                            setState(() {
                              _updateVideoController2(_videoPlayerIndex);
                            });
                          });
                        });
                      } else if (_scrollController.position.pixels > 2500 && _reverseScroll == true) {
                        setState(() {
                          print('Entered Hereeeeeeeeeee');
                          int doubleIndex = int.parse(
                              info.key.toString().substring(3, 5));
                          _videoPlayerIndex = doubleIndex;
                          Future.delayed(Duration(milliseconds: delay), () {
                            setState(() {
                              _updateVideoController2(_videoPlayerIndex);
                            });
                          });
                        });
                      }
                    }
                  },
                  child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        height: h * 0.35,
                        decoration:
                        const BoxDecoration(color: Colors.transparent),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (_scrollController.position.pixels > 2 && _scrollingStopped && (_videoPlayerIndex == index))
                              playVideo(w, h)
                            else
                              showThumbnail(w, h, dataset, index),
                            Row(
                              children: [
                                ClipOval(
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundImage: NetworkImage(
                                        dataset[index]['coverPicture']),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dataset[index]['title'],
                                      style: t.copyWith(
                                          fontWeight: FontWeight.w300),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Ivy Pods',
                                          style: t.copyWith(
                                              fontSize: 12,
                                              color: Colors.grey
                                                  .withOpacity(0.8)),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "1.5 crore views",
                                          style: t.copyWith(
                                              fontSize: 12,
                                              color: Colors.grey
                                                  .withOpacity(0.8)),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "2 months ago",
                                          style: t.copyWith(
                                              fontSize: 12,
                                              color: Colors.grey
                                                  .withOpacity(0.8)),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                );
              },
              childCount: DatasetProvider.datasetProvider.length,
            )),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) {
            setState(() {
              _bottomNavigationBarIndex = index;
            });
          },
          currentIndex: _bottomNavigationBarIndex,
          elevation: 0,
          selectedLabelStyle: t.copyWith(fontSize: 10, color: Colors.white),
          unselectedLabelStyle: t.copyWith(fontSize: 10, color: Colors.white),
          items: const [
            BottomNavigationBarItem(
                label: 'Home',
                activeIcon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                icon: Icon(
                  Icons.home_outlined,
                  color: Colors.white,
                )),
            BottomNavigationBarItem(
                label: 'shorts',
                activeIcon: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
                icon: Icon(
                  Icons.play_arrow_outlined,
                  color: Colors.white,
                )),
            BottomNavigationBarItem(
                label: 'post',
                activeIcon: Icon(
                  Icons.add_circle,
                  color: Colors.white,
                ),
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                )),
            BottomNavigationBarItem(
                label: 'subscriptions',
                activeIcon: Icon(
                  Icons.subscriptions,
                  color: Colors.white,
                ),
                icon: Icon(
                  Icons.subscriptions_outlined,
                  color: Colors.white,
                )),
            BottomNavigationBarItem(
                label: 'library',
                activeIcon: Icon(
                  Icons.video_library,
                  color: Colors.white,
                ),
                icon: Icon(
                  Icons.video_library_outlined,
                  color: Colors.white,
                ))
          ]),
    );
  }

  SizedBox showThumbnail(
      double w, double h, List<Map<String, dynamic>> dataset, int index) {
    return SizedBox(
      width: w,
      height: h * 0.25,
      child: Image.network(
        dataset[index]['coverPicture'],
        fit: BoxFit.cover,
      ),
    );
  }

  Stack playVideo(double w, double h) {
    return Stack(
      children: [
        SizedBox(
            width: w,
            height: h * 0.25,
            child: AspectRatio(
              aspectRatio: _videoPlayer.value.aspectRatio,
              child: GestureDetector(
                  onTap: () {
                    return;
                  },
                  child: VideoPlayer(_videoPlayer)),
            )),
        Positioned(
          right: 10,
          top: 10,
          child: Container(
            width: w * 0.2,
            height: 30,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _mute = !_mute;
                      if (_mute == true) {
                        _videoPlayer.setVolume(0.0);
                      } else {
                        _videoPlayer.setVolume(10.0);
                      }
                    });
                  },
                  child: _mute
                      ? const Icon(
                          Icons.volume_off,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.volume_up,
                          color: Colors.white,
                        ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _captions = !_captions;
                    });
                  },
                  child: _captions
                      ? const Icon(
                          Icons.closed_caption,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.closed_caption_off,
                          color: Colors.white,
                        ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: Container(
              width: w * 0.1,
              height: 30,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                  child: ValueListenableBuilder(
                builder: (BuildContext context, value, Widget? child) {
                  /// ValueListenableBuilder helps in updating the progress bar in REAL TIME
                  return Text(
                    (_videoPlayer.value.duration - _videoPlayer.value.position)
                        .toString()
                        .substring(2, 7),
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  );
                },
                valueListenable: _videoPlayer,
              ))),
        ),
        Positioned(
          bottom: 0,
          child: SizedBox(
              width: w,
              height: 12,

              /// ValueListenableBuilder helps in updating the progress bar in REAL TIME
              child: ValueListenableBuilder(
                  valueListenable: _videoPlayer,
                  builder: (context, value, child) {
                    return VideoProgressIndicator(_videoPlayer,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                            playedColor: Colors.redAccent,
                            bufferedColor: Colors.grey));
                  })),
        )
      ],
    );
  }
}
