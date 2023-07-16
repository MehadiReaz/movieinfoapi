import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../style/style.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedIndex = 0;
  int badge = 0;
  final padding = EdgeInsets.symmetric(horizontal: 18, vertical: 12);
  double gap = 10;

  PageController controller = PageController();

  @override
  void initState() {
    loadMovies();
    super.initState();
  }

  late List genreList = [];
  late List trendMovies = [];
  late List allMovies = [];
  late List allSeries = [];
  String apiKey = '8daad3a6eb9e40a3e0042ed2649696fe';
  String readAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZGFhZDNhNmViOWU0MGEzZTAwNDJlZDI2NDk2OTZmZSIsInN1YiI6IjY0YjI3ODFkMjNkMjc4MDBhZGM4OTBmMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.7xPVJOGDZqwoqVv3t00cSNYb7WiNc3xVFkFhcHh9SsM';
  loadMovies() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apiKey, readAccessToken),
      logConfig: const ConfigLogger(
        showErrorLogs: true,
        showLogs: true,
      ),
    );
    Map trendingResult = await tmdbWithCustomLogs.v3.trending.getTrending();
    Map genreListResult = await tmdbWithCustomLogs.v3.genres.getMovieList();
    Map allMoviResult = await tmdbWithCustomLogs.v3.movies.getPopular();
    Map allSeriesResult = await tmdbWithCustomLogs.v3.tv.getPopular();
    //print(trendingResult);
    setState(() {
      trendMovies = trendingResult['results'];
      genreList = genreListResult['genres'];
      allMovies = allMoviResult['results'];
      allSeries = allSeriesResult['results'];
      badge = badge + 1;
    });
    print(trendMovies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBody: true,
      backgroundColor: Color(0xFF15141F),
      appBar: AppBar(
        title: Center(
          child: Text(
            'Movie Verse',
            style: textStyle(30, FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.black12,
        elevation: 0,
      ),
      body: PageView.builder(
          onPageChanged: (page) {
            setState(() {
              selectedIndex = page;
              badge = badge + 1;
            });
          },
          controller: controller,
          itemBuilder: (context, position) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Trending',
                      style: textStyle(20, FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 200,
                    child: GestureDetector(
                      onTap: () {},
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: trendMovies.length,
                          itemBuilder: (context, int index) {
                            return Column(children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                height: 200,
                                width: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/w500' +
                                        trendMovies[index]['poster_path'],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              // Container(
                              //   padding: EdgeInsets.all(5),
                              //   height: 70,
                              //   width: 150,
                              //   child: trendMovies[index]['title'] != null
                              //       ?
                              //       // ? (trendMovies[index]['title'].length >= 20
                              //       //     ? Marquee(
                              //       //         text: trendMovies[index]['title'] + '   ')
                              //       //     : Text(trendMovies[index]['title']))
                              //       Text(
                              //           trendMovies[index]['title'],
                              //           style: textStyle(15, FontWeight.normal),
                              //         )
                              //       : Center(
                              //           child: CircularProgressIndicator(),
                              //         ),
                              // ),
                            ]);
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Categories',
                      style: textStyle(20, FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 70,
                    child: ListView.builder(
                        itemCount: genreList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              TextButton(
                                child: Text(genreList[index]['name']),
                                onPressed: () {},
                              ),
                            ],
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Moive',
                      style: textStyle(20, FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 270,
                    child: GestureDetector(
                      onTap: () {},
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: allMovies.length,
                          itemBuilder: (context, int index) {
                            return Column(children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                height: 200,
                                width: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: trendMovies[index]['poster_path'] !=
                                          null
                                      ? Image.network(
                                          'https://image.tmdb.org/t/p/w500' +
                                              allMovies[index]['poster_path'],
                                          fit: BoxFit.cover,
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                height: 70,
                                width: 150,
                                child: allMovies[index]['title'] != null
                                    ?
                                    // ? (trendMovies[index]['title'].length >= 20
                                    //     ? Marquee(
                                    //         text: trendMovies[index]['title'] + '   ')
                                    //     : Text(trendMovies[index]['title']))
                                    Text(
                                        allMovies[index]['title'],
                                        style: textStyle(15, FontWeight.normal),
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(),
                                      ),
                              ),
                            ]);
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tv Series',
                      style: textStyle(20, FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 270,
                    child: GestureDetector(
                      onTap: () {},
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: allSeries.length,
                          itemBuilder: (context, int index) {
                            return Column(children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                height: 200,
                                width: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: allSeries[index]['poster_path'] != null
                                      ? Image.network(
                                          'https://image.tmdb.org/t/p/w500' +
                                              allSeries[index]['poster_path'],
                                          fit: BoxFit.cover,
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                height: 70,
                                width: 150,
                                child: allSeries[index]['name'] != null
                                    ?
                                    // ? (trendMovies[index]['title'].length >= 20
                                    //     ? Marquee(
                                    //         text: trendMovies[index]['title'] + '   ')
                                    //     : Text(trendMovies[index]['title']))
                                    Text(
                                        allSeries[index]['name'],
                                        style: textStyle(15, FontWeight.normal),
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(),
                                      ),
                              ),
                            ]);
                          }),
                    ),
                  ),
                ],
              ),
            );
          }),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 1),
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.all(Radius.circular(100)),
            boxShadow: [
              BoxShadow(
                spreadRadius: -10,
                blurRadius: 60,
                color: Colors.black.withOpacity(.4),
                offset: Offset(0, 25),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3),
            child: GNav(
              tabs: [
                GButton(
                  gap: gap,
                  iconActiveColor: Colors.white,
                  iconColor: Colors.black,
                  textColor: Colors.white,
                  backgroundColor: Colors.purple.withOpacity(.2),
                  iconSize: 24,
                  padding: padding,
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                // GButton(
                //   gap: gap,
                //   iconActiveColor: Colors.pink,
                //   iconColor: Colors.black,
                //   textColor: Colors.pink,
                //   backgroundColor: Colors.pink.withOpacity(.2),
                //   iconSize: 24,
                //   padding: padding,
                //   icon: LineIcons.heart,
                //   leading: selectedIndex == 1 || badge == 0
                //       ? null
                //       : badges.Badge(
                //           badgeStyle: badges.BadgeStyle(
                //             badgeColor: Colors.red.shade100,
                //           ),
                //           position: BadgePosition.topEnd(top: -12, end: -12),
                //           badgeContent: Text(
                //             badge.toString(),
                //             style: TextStyle(color: Colors.red.shade900),
                //           ),
                //           child: Icon(
                //             LineIcons.heart,
                //             color:
                //                 selectedIndex == 1 ? Colors.pink : Colors.black,
                //           ),
                //         ),
                // ),
                GButton(
                  gap: gap,
                  iconActiveColor: Colors.white,
                  iconColor: Colors.black,
                  textColor: Colors.white,
                  backgroundColor: Colors.amber[600]!.withOpacity(.2),
                  iconSize: 24,
                  padding: padding,
                  icon: LineIcons.search,
                  text: 'Search',
                ),
                GButton(
                  gap: gap,
                  iconActiveColor: Colors.white,
                  iconColor: Colors.black,
                  textColor: Colors.white,
                  backgroundColor: Colors.teal.withOpacity(.2),
                  iconSize: 24,
                  padding: padding,
                  icon: LineIcons.user,
                  // leading: CircleAvatar(
                  //   radius: 12,
                  //   backgroundImage: NetworkImage(
                  //     'https://sooxt98.space/content/images/size/w100/2019/01/profile.png',
                  //   ),
                  // ),
                  text: 'Sheldon',
                )
              ],
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                setState(() {
                  selectedIndex = index;
                });
                controller.jumpToPage(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
