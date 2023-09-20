import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie/components/list_loader.dart';
import 'package:movie/model/results.dart';
import 'package:movie/components/movie_list.dart';
import '../network/api.dart';

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  final _auth = FirebaseAuth.instance;

  List<Result> popularList = [];
  List<Result> nowPlayingList = [];
  List<Result> topRatedList = [];
  List<Result> upcomingList = [];

  bool isVerify = true;

  @override
  void initState() {
    getMovies();
    isVerify = isEmailVerify();
    super.initState();
  }

  void getMovies() async {
    popularList = await getMovieList("popular");
    setState(() {});
    nowPlayingList = await getMovieList("now_playing");
    setState(() {});
    topRatedList = await getMovieList("top_rated");
    setState(() {});
    upcomingList = await getMovieList("upcoming");
    setState(() {});
  }

  bool isEmailVerify() {
    return _auth.currentUser!.emailVerified;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            isVerify
                ? Container()
                : Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    decoration: BoxDecoration(
                        color: Colors.amber[300],
                        borderRadius: BorderRadius.circular(3)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "You have not yet verify your account.",
                          style: TextStyle(color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isVerify = true;
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 15,
                          ),
                        )
                      ],
                    ),
                  ),
            nowPlayingList.isNotEmpty
                ? MovieList(
                    movieList: nowPlayingList,
                    listName: "Now Playing Movies",
                  )
                : const HoriListLoader(),
            const Divider(),
            popularList.isNotEmpty
                ? MovieList(
                    movieList: popularList,
                    listName: "Popular Movies",
                  )
                : const HoriListLoader(),
            const Divider(),
            topRatedList.isNotEmpty
                ? MovieList(
                    movieList: topRatedList,
                    listName: "Top Rated Movies",
                  )
                : const HoriListLoader(),
            const Divider(),
            upcomingList.isNotEmpty
                ? MovieList(
                    movieList: upcomingList,
                    listName: "Upcoming Movies",
                  )
                : const HoriListLoader(),
            const Divider(),
          ],
        ),
      ),
    );
    // );
  }
}
