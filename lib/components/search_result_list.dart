import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/pages/movie_details.dart';
import 'package:movie/pages/search_results.dart';
import 'package:movie/providers/search_movie_proivder.dart';
import 'package:provider/provider.dart';

import '../providers/details_provider.dart';

class SearchResultsList extends StatefulWidget with ChangeNotifier {
  SearchResultsList({super.key});

  @override
  State<SearchResultsList> createState() => _SearchResultsListState();
}

class _SearchResultsListState extends State<SearchResultsList> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);
    final detailsProvider = Provider.of<DetailsProvider>(context);

    return searchProvider.response == null
        ? Container()
        : searchProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    searchProvider.response!.totalPages <= 1
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Get.to(const SearchResultPage());
                                  // Navigator.push(context,
                                  //     MaterialPageRoute(builder: ((context) {
                                  //   return SearchResultPage();
                                  // })));
                                },
                                child: const Text("Show all"),
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
                                  int id = searchProvider.results[index].id;
                                  detailsProvider.callDetailApi(id);
                                  Get.to(MovieDetails());
                                },
                                child: Column(
                                  children: [
                                    searchProvider.results[index].posterPath ==
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
                                        : Image(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.43,
                                            image: NetworkImage(
                                                "http://image.tmdb.org/t/p/w500/${searchProvider.results[index].posterPath}"),
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
                  ],
                ),
              );
  }
}
