import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/model/results.dart';
import 'package:movie/pages/movie_details.dart';
import 'package:movie/providers/details_provider.dart';
import 'package:movie/providers/fav_movie_provider.dart';
import 'package:provider/provider.dart';

class MovieList extends StatefulWidget {
  MovieList({super.key, required this.movieList, required this.listName});

  final String listName;

  List<Result> movieList = [];

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  updateFavMovie(FavProvider provider) {
    provider.updateFavMovieList();
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavProvider>(context);
    final detailsProvider = Provider.of<DetailsProvider>(context);

    updateFavMovie(favProvider);

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              border: Border(
                left:
                    BorderSide(color: Theme.of(context).primaryColor, width: 3),
              ),
            ),
            child: Text(
              widget.listName,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.328,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.movieList.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      debugPrint("---------------");
                      debugPrint("Tapped >>> ${widget.movieList[index].id}");
                      detailsProvider.callDetailApi(widget.movieList[index].id);
                      Get.to(const MovieDetails());
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) {
                      //     return const MovieDetails();
                      //   }),
                      // );
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.38,
                        decoration: BoxDecoration(
                            // color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: widget.movieList[index].posterPath == null
                                  ? Image.asset(
                                      "images/404.png",
                                      color: Colors.grey,
                                    )
                                  : Image.network(
                                      "http://image.tmdb.org/t/p/w500/${widget.movieList[index].posterPath}",
                                      // width: MediaQuery.of(context).size.width * 0.33,
                                    ),
                            ),
                            Text(
                              widget.movieList[index].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -3,
                    right: 3,
                    child: IconButton(
                      onPressed: () {
                        favProvider
                            .addOrRemoveMovie(widget.movieList[index].id);
                      },
                      icon: Icon(
                        favProvider.isFav(widget.movieList[index].id)
                            ? Icons.bookmark
                            : Icons.bookmark_add_outlined,
                        size: 30,
                        color: const Color(0xB8FFFFFF),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
