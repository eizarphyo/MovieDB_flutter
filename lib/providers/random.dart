import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/model/details.dart';
import 'package:movie/network/api.dart';
import 'package:movie/providers/details_provider.dart';
import 'package:provider/provider.dart';

import '../pages/movie_details.dart';

class GenerateRandomNum extends StatefulWidget {
  const GenerateRandomNum({super.key});

  @override
  State<GenerateRandomNum> createState() => _GenerateRandomNumState();
}

class _GenerateRandomNumState extends State<GenerateRandomNum> {
  Random random = Random();
  late DetailsProvider detailsProvider;

  bool _loading = true;

  // int id = 0.obs();
  int? id;

  _navigateToDetails() {
    Get.to(MovieDetails());

    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return MovieDetails();
    // }));
  }

  _generateRandomNum() async {
    setState(() {
      _loading = true;
    });

    int randomId = random.nextInt(999998) + 1;
    debugPrint("----------");
    debugPrint(">>>>> $randomId");

    try {
      Details details = await getMovieDetailsWithId(randomId);

      debugPrint(">>>>> Movie Found -- ${details.id} | ${details.title}");
      setState(() {
        _loading = false;
      });
      debugPrint("must stop here");

      id = randomId;

      // _navigateToDetails();
    } catch (e) {
      debugPrint("ERROR CAUGHT - INVALID MOVIE ID");
      _generateRandomNum();
    }
  }

  @override
  void initState() {
    // generate random movie id
    _generateRandomNum();

    // Define a function that navigates to the DetailsPage using build context
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   detailsProvider = Provider.of(context, listen: false);
    //   _generateRandomNum();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DetailsProvider detailsProvider = Provider.of(context);

    debugPrint('$id');

    if (id != null) {
      debugPrint('delayed 5 sec');

      Future.delayed(Duration(seconds: 5), () {
        detailsProvider.callDetailApi(id!);
        Get.to(MovieDetails());
        id = null;
        debugPrint("navigate here --------------->");
      });
      // _navigateToDetails();
    }

    return _loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container();
  }
}
