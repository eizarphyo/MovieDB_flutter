import 'package:flutter/material.dart';
import 'package:movie/components/search_result_list.dart';
import 'package:movie/model/overall_response.dart';
import 'package:movie/providers/search_movie_proivder.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  OverallResponse? response;
  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              textInputAction: TextInputAction.search,
              onSubmitted: (movieName) async {
                searchProvider.callApi(movieName, 1);
              },
              decoration: InputDecoration(
                hintText: "Search Movies",
                suffixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).hintColor,
                ),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            searchProvider.isLoading
                ? SizedBox(
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SearchResultsList()
          ],
        ),
      ),
    );
  }
}
