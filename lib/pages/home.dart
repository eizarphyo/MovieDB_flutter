import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:movie/components/loader.dart';
import 'package:movie/pages/account.dart';
import 'package:provider/provider.dart';

import '../components/appbar_search.dart';
import '../components/search_result_list.dart';
import '../providers/search_movie_proivder.dart';
import '../providers/theme_mode_provider.dart';
import 'fav_movies.dart';
import 'movies.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  // NAVIGATION PAGE LIST
  List<Widget> pages = [
    const Movies(),
    // GenerateRandomNum(),
    const FavMoviesPage(),
    const AccountPage(),
  ];

  // BOTTOM NAVIGATION BAR ITEM LIST
  List<BottomNavigationBarItem> naviItems = const [
    BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
        ),
        label: "Home"),
    // BottomNavigationBarItem(icon: Icon(Icons.casino_outlined), label: "Random"),
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
  ];

  int _selectedIndex = 0;

  String? fcmToken;

  @override
  void initState() {
    super.initState();
    // getToken();
  }

  getToken() async {
    fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      debugPrint("FCMTOKEN >>>>");
      debugPrint(fcmToken);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SearchProvider searchProvider = Provider.of<SearchProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil((route) => route.isFirst);
        return true;
        // return (await showDialog(
        //       context: context,
        //       builder: (context) => AlertDialog(
        //         title: new Text('Are you sure?'),
        //         content: new Text('Do you want to exit?'),
        //         actions: <Widget>[
        //           TextButton(
        //             onPressed: () =>
        //                 Navigator.of(context).pop(false),
        //             child: new Text('No'),
        //           ),
        //           TextButton(
        //             onPressed: () =>
        //                 Navigator.of(context).popUntil((route) => route.isFirst);
        //             child: new Text('Yes'),
        //           ),
        //         ],
        //       ),
        //     )) ??
        //     false;
      },
      child: Scaffold(
        drawer: searchProvider.response != null
            ? null
            : Drawer(
                backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
                child: Column(
                  children: [
                    DrawerHeader(
                      child: Container(
                        decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage("images/popcorn.jpg"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(5)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.0)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        direction: Axis.vertical,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Transform.rotate(
                            angle: 45.5,
                            child: const Icon(
                              Icons.build_outlined,
                              size: 25,
                            ),
                          ),
                          const Text(
                            "Coming Soon..",
                            style:
                                TextStyle(fontSize: 20, fontFamily: "Alkatra"),
                          )
                        ],
                      ),
                    )
                    // ListTile(
                    //   onTap: () {},
                    //   title: TextField(
                    //     textInputAction: TextInputAction.search,
                    //     onSubmitted: (value) {
                    //       // searchMovie(value);
                    //     },
                    //     decoration: const InputDecoration(
                    //         hintText: "Search Movie",
                    //         border: OutlineInputBorder(
                    //             borderSide: BorderSide.none)),
                    //   ),
                    //   trailing: const Icon(Icons.search),
                    // ),
                    // ListTile(
                    //   onTap: () {},
                    //   title: const Text("Watch List"),
                    //   trailing: const Icon(Icons.bookmark_border),
                    // ),
                    // ListTile(
                    //   onTap: () {
                    //     Get.to(const ProfilePage());
                    //   },
                    //   title: const Text("Profile"),
                    //   trailing: const Icon(Icons.person_2_outlined),
                    // ),
                    // ListTile(
                    //   onTap: () {},
                    //   title: const Text("Account"),
                    //   trailing: const Icon(Icons.settings),
                    // ),
                    // ListTile(
                    //   onTap: () async {
                    //     debugPrint("tapped logout");
                    //     final SharedPreferences prefs =
                    //         await SharedPreferences.getInstance();
                    //     await prefs.remove('token');
                    //     Navigator.pushNamed(context, "login");
                    //     debugPrint("done");
                    //   },
                    //   title: const Text("Logout"),
                    //   trailing: Icon(
                    //     Icons.logout_outlined,
                    //     color: Theme.of(context).primaryColor,
                    //   ),
                    // ),
                  ],
                )),
        appBar: AppBar(
          leading: searchProvider.response != null
              ? IconButton(
                  onPressed: () {
                    searchProvider.closeSearchBar();
                    searchProvider.disposeResponse();
                  },
                  icon: const Icon(Icons.arrow_back))
              : null,
          title: searchProvider.showSearch
              ? const AppBarSearch()
              // TextField(
              //     focusNode: _searchFocus,
              //     controller: _searchController,
              //     textInputAction: TextInputAction.search,
              //     onChanged: (value) {
              //       setState(() {});
              //     },
              //     onSubmitted: (value) {
              //       searchProvider.callApi(value, 1);
              //       Get.to(SearchResultPage());
              //     },
              //     decoration: InputDecoration(
              //       border: InputBorder.none,
              //       filled: false,
              //       suffixIcon: IconButton(
              //           onPressed: () {
              //             _searchController.clear();
              //             _showSearchBar = false;
              //             setState(() {});
              //           },
              //           icon: const Icon(
              //             Icons.close,
              //             size: 16,
              //             color: Colors.grey,
              //           )),
              //       hintText: "Search Movie",
              //       hintStyle: TextStyle(color: Theme.of(context).hintColor),
              //       // border:
              //       //     const OutlineInputBorder(borderSide: BorderSide.none),
              //       // border: const UnderlineInputBorder(borderSide: BorderSide.none),
              //     ),
              //   )
              : Container(),
          actions: [
            searchProvider.showSearch
                ? Container()
                // SEARCH ICON
                : IconButton(
                    onPressed: () {
                      setState(() {
                        searchProvider.showSearchBar();
                        _searchFocus.requestFocus();
                      });
                    },
                    icon: const Icon(Icons.search),
                  ),
            // LIGHT MODE - DARK MODE
            IconButton(
              onPressed: () {
                if (themeProvider.isDarkMode) {
                  themeProvider.setThemeMode(ThemeMode.light);
                } else {
                  themeProvider.setThemeMode(ThemeMode.dark);
                }
              },
              icon: Icon(themeProvider.isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode),
            ),
          ],
        ),
        body: Stack(children: [
          Visibility(
              visible:
                  searchProvider.isLoading || searchProvider.response != null
                      ? false
                      : true,
              maintainState: true,
              child: pages[_selectedIndex]),
          Positioned(
              child: searchProvider.isLoading
                  ? const Loader()
                  : searchProvider.response != null
                      ? SearchResultsList()
                      : Container())
        ]),
        bottomNavigationBar: BottomNavigationBar(
          items: naviItems,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
