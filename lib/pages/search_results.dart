import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/providers/search_movie_proivder.dart';
import 'package:provider/provider.dart';

import '../providers/details_provider.dart';
import 'movie_details.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SearchProvider searchProvider = Provider.of<SearchProvider>(context);
    final detailsProvider = Provider.of<DetailsProvider>(context);

    return searchProvider.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(),
            body: searchProvider.response == null
                ? Container()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Total movies: ${searchProvider.response!.totalResults}",
                            style:
                                TextStyle(color: Theme.of(context).hintColor),
                          ),
                        ),
                      ),
                      // GRID VIEW
                      Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                // mainAxisSpacing: 10,
                                crossAxisSpacing:
                                    MediaQuery.of(context).size.width * 0.001,
                                childAspectRatio: 0.58,
                              ),
                              scrollDirection: Axis.vertical,
                              itemCount: searchProvider.results.length,
                              itemBuilder: (context, index) {
                                // POSTER & TITLE
                                return GestureDetector(
                                  onTap: () {
                                    detailsProvider.callDetailApi(
                                        searchProvider.results[index].id);
                                    Get.to(MovieDetails());
                                  },
                                  child: Column(
                                    children: [
                                      searchProvider
                                                  .results[index].posterPath ==
                                              null
                                          ? Image.asset(
                                              "images/404.png",
                                              color: Colors.grey,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.43,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.64,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              "http://image.tmdb.org/t/p/w500/${searchProvider.results[index].posterPath}",
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.43,
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 3),
                                        child: Text(
                                          searchProvider.results[index].title,
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
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      searchProvider.response!.totalPages <= 1
                          ? Container()
                          : Row(
                              children: [
                                Text(
                                  "Pages ",
                                  style: TextStyle(
                                      color: Theme.of(context).hintColor),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          searchProvider.response!.totalPages,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            searchProvider.callApi(
                                                searchProvider.name, index + 1);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Text(
                                              '${index + 1}',
                                              style: searchProvider
                                                          .response!.page ==
                                                      index + 1
                                                  ? null
                                                  : TextStyle(
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                      decoration: TextDecoration
                                                          .underline),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ));
  }
}
