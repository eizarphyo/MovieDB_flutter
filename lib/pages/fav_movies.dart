import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/providers/details_provider.dart';
import 'package:movie/providers/fav_movie_provider.dart';
import 'package:provider/provider.dart';

import '../model/details.dart';
import '../network/api.dart';
import 'movie_details.dart';

class FavMoviesPage extends StatefulWidget {
  const FavMoviesPage({super.key});

  @override
  State<FavMoviesPage> createState() => _FavMoviesPageState();
}

class _FavMoviesPageState extends State<FavMoviesPage> {
  List<String> favMovies = [];
  List<Details>? movieList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FavProvider favProvider =
          Provider.of<FavProvider>(context, listen: false);
      favProvider.updateFavMovieList();

      favMovies = favProvider.favMovies;

      if (favMovies.isNotEmpty) {
        favMovies.forEach((id) async {
          Details details = await getMovieDetailsWithId(int.parse(id));
          movieList!.add(details);
          setState(() {});
        });
      } else {
        movieList = null;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    FavProvider favProvider = Provider.of<FavProvider>(context);
    DetailsProvider detailsProvider = Provider.of<DetailsProvider>(context);

    // return LoadingComponent();
    return movieList == null
        ? const Center(
            child: Text("You haven't added any movies yet.."),
          )
        : movieList!.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Text(
                        "Your Favorite Movies",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          // mainAxisSpacing: 10,
                          crossAxisSpacing:
                              MediaQuery.of(context).size.width * 0.001,
                          childAspectRatio: 0.58,
                        ),
                        scrollDirection: Axis.vertical,
                        itemCount: movieList!.length,
                        itemBuilder: (context, index) {
                          // POSTER & TITLE
                          return Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  detailsProvider
                                      .callDetailApi(movieList![index].id);
                                  Get.to(MovieDetails());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    children: [
                                      movieList![index].posterPath == null
                                          ? Image(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.43,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.64,
                                              image: const AssetImage(
                                                  'images/loading_img.png'),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.43,
                                                image: NetworkImage(
                                                    "http://image.tmdb.org/t/p/w500/${movieList![index].posterPath}"),
                                              ),
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 3),
                                        child: Text(
                                          movieList![index].title,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -10,
                                right: 5,
                                child: IconButton(
                                  onPressed: () {
                                    favProvider
                                        .addOrRemoveMovie(movieList![index].id);
                                    movieList!.removeAt(index);
                                    if (movieList!.isEmpty) {
                                      movieList = null;
                                    }
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.bookmark_remove,
                                    size: 30,
                                    color: Color(0xB8FFFFFF),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
  }
}
