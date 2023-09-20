import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie/components/backdrop_list.dart';
import 'package:movie/components/cast_list.dart';
import 'package:movie/components/genres_grid.dart';
import 'package:movie/components/video_player.dart';
import 'package:movie/providers/fav_movie_provider.dart';
import 'package:provider/provider.dart';
import '../components/movie_list.dart';
import '../providers/details_provider.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({super.key});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late DetailsProvider detailsProvider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FavProvider favProvider =
          Provider.of<FavProvider>(context, listen: false);
      favProvider.updateFavMovieList();
    });
  }

  _onFavTap(FavProvider provider, int id) {
    provider.addOrRemoveMovie(id);
  }

  @override
  Widget build(BuildContext context) {
    FavProvider favProvider = Provider.of<FavProvider>(context);
    detailsProvider = Provider.of<DetailsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.share,
                size: 20,
              ))
        ],
      ),
      body: Center(
        child: detailsProvider.loading
            ? CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    // TRAILER VIDEO
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: MyVideoPlayer(id: detailsProvider.details.id),
                    ),
                    // TITLE
                    Text(
                      detailsProvider.details.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    // STATUS | RELEASED DATE | RUN TIME
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 20),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: detailsProvider.details.status,
                                style: TextStyle(
                                    color: Theme.of(context).hintColor)),
                            TextSpan(
                                text: "   |   ",
                                style: TextStyle(
                                    color: Theme.of(context).hintColor)),
                            // DATE
                            TextSpan(
                                text: DateFormat('yMMMd').format(
                                    detailsProvider.details.releaseDate),
                                style: TextStyle(
                                    color: Theme.of(context).hintColor)),
                            TextSpan(
                                text: "   |   ",
                                style: TextStyle(
                                    color: Theme.of(context).hintColor)),
                            // RUN TIME
                            TextSpan(
                                text: detailsProvider.getDuration(),
                                style: TextStyle(
                                    color: Theme.of(context).hintColor)),
                          ],
                        ),
                      ),
                    ),
                    // POSTER | GENRES | TAG LINE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // POSTER
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: detailsProvider.details.posterPath == null
                              ? Image.asset(
                                  "images/404.png",
                                  color: Colors.grey,
                                  width: detailsProvider.details.genres == [] ||
                                          detailsProvider.details.tagline == ''
                                      ? MediaQuery.of(context).size.width * 0.8
                                      : MediaQuery.of(context).size.width *
                                          0.25,
                                )
                              : Image.network(
                                  "http://image.tmdb.org/t/p/w500/${detailsProvider.details.posterPath}",
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment:
                                detailsProvider.details.genres.isEmpty
                                    ? MainAxisAlignment.center
                                    : MainAxisAlignment.spaceEvenly,
                            children: [
                              // GENRES
                              GenresGrid(
                                  genres: detailsProvider.details.genres),
                              // TAGLINE
                              detailsProvider.details.tagline != ""
                                  ? Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      padding: const EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 3),
                                        ),
                                      ),
                                      child: Text(
                                        '"${detailsProvider.details.tagline}"',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // RATING |  BOOKMARK ICON
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // ADULT
                        // Text(detailsProvider.details.adult ? "adult" : "",
                        //     style: Theme.of(context).textTheme.labelLarge),
                        // RATING
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: "Rating - ",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          TextSpan(
                            text: detailsProvider.details.voteAverage
                                .toStringAsFixed(1),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          WidgetSpan(
                            child: Icon(
                              Icons.star_rate_rounded,
                              color: Colors.amber[300],
                              size: 20,
                            ),
                          )
                        ])),
                        // ICONS
                        // IconButton(
                        //   onPressed: () {},
                        //   icon: Icon(
                        //       favProvider.isFav(detailsProvider.details.id)
                        //           ? Icons.favorite_rounded
                        //           : Icons.favorite_border_rounded),
                        //   color: Theme.of(context).primaryColor,
                        //   iconSize: 27,
                        // ),
                        IconButton(
                          onPressed: () {
                            _onFavTap(favProvider, detailsProvider.details.id);
                          },
                          icon: Icon(
                              favProvider.isFav(detailsProvider.details.id)
                                  ? Icons.bookmark_added
                                  : Icons.bookmark_add_outlined),
                          color: Theme.of(context).primaryColor,
                          iconSize: 25,
                        ),
                      ],
                    ),
                    // OVERVIEW
                    Text(
                      "Overview",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Divider(
                      indent: 80,
                      endIndent: 80,
                    ),
                    detailsProvider.details.overview == ''
                        ? const Text("-")
                        : Text(
                            detailsProvider.details.overview,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),

                    // BACKDROP LIST
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                      child: BackdropList(id: detailsProvider.details.id),
                    ),

                    // PRODUCITON COMPANIES | LANGUAGES SPOKEN
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment:
                            detailsProvider.details.productionCompanies.isEmpty
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.spaceEvenly,
                        children: [
                          // PRODUCTION COMPANIES
                          detailsProvider.details.productionCompanies.isEmpty
                              ? Container()
                              : Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.45),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Production Companies",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      for (var company in detailsProvider
                                          .details.productionCompanies)
                                        Text(
                                          company.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        )
                                    ],
                                  ),
                                ),
                          // LANGUAGES SPOKEN
                          detailsProvider.details.spokenLanguages.isEmpty
                              ? Container()
                              : Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Languages Spoken",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    for (var lang in detailsProvider
                                        .details.spokenLanguages)
                                      Text(lang.englishName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                  ],
                                ),
                        ],
                      ),
                    ),

                    // CASTS
                    detailsProvider.casts.isEmpty
                        ? Container()
                        : CastList(casts: detailsProvider.casts),

                    // RECOMMENDATION
                    detailsProvider.recomList.isNotEmpty
                        ? MovieList(
                            movieList: detailsProvider.recomList,
                            listName: "You Might Also Like",
                          )
                        : Container(),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    detailsProvider.disposeDetails();
    super.dispose();
  }
}

// Faded background image
// Container(
//                   width: MediaQuery.of(context).size.width * 1,
//                   height: MediaQuery.of(context).size.height * 0.9,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage(
//                           "http://image.tmdb.org/t/p/w500/${details.posterPath}"),
//                       fit: BoxFit.cover,
//                       colorFilter: ColorFilter.mode(
//                           Colors.black.withOpacity(0.2), BlendMode.dstATop),
//                     ),
//                   ),
//                   child:
