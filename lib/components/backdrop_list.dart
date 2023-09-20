import 'package:flutter/material.dart';
import 'package:movie/model/images.dart';
import 'package:movie/network/api.dart';

class BackdropList extends StatefulWidget {
  const BackdropList({super.key, required this.id});
  final int id;

  @override
  State<BackdropList> createState() => _BackdropListState();
}

class _BackdropListState extends State<BackdropList> {
  MovieImages? images;
  List<Backdrop> backdrops = [];

  @override
  void initState() {
    super.initState();
    getImagesWithApi();
  }

  getImagesWithApi() async {
    images = await getImages(widget.id);
    if (images != null) {
      backdrops = images!.backdrops;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return images == null || backdrops.isEmpty
        ? Container()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Photos",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: backdrops.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Image(
                            image: NetworkImage(
                                "http://image.tmdb.org/t/p/w500/${backdrops[index].filePath}")),
                      );
                    }),
              ),
            ],
          );
  }
}
