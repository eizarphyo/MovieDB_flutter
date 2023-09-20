import 'package:flutter/material.dart';
import 'package:movie/providers/search_movie_proivder.dart';
import 'package:provider/provider.dart';

class AppBarSearch extends StatefulWidget {
  const AppBarSearch({super.key});

  @override
  State<AppBarSearch> createState() => _AppBarSearchState();
}

class _AppBarSearchState extends State<AppBarSearch> {
  @override
  Widget build(BuildContext context) {
    SearchProvider searchProvider = Provider.of<SearchProvider>(context);

    return TextField(
      autofocus: true,
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        searchProvider.callApi(value, 1);
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return SearchResultsList();
        // }));
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: false,
        suffixIcon: IconButton(
            onPressed: () {
              searchProvider.closeSearchBar();
              setState(() {});
            },
            icon: const Icon(
              Icons.close,
              size: 16,
              color: Colors.grey,
            )),
        hintText: "Search Movies",
        hintStyle: TextStyle(color: Theme.of(context).hintColor),
      ),
    );
  }
}
