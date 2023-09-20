import 'package:flutter/material.dart';

import '../model/credits.dart';

class CastList extends StatefulWidget {
  const CastList({super.key, required this.casts});

  final List<Cast> casts;

  @override
  State<CastList> createState() => _CastListState();
}

class _CastListState extends State<CastList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          heightFactor: 2,
          child: Text(
            "Casts",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.casts.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 90,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: widget.casts[index].profilePath == null
                            ? Image.asset(
                                "images/404.png",
                                color: Colors.grey,
                                fit: BoxFit.cover,
                                height: 120,
                              )
                            : Image.network(
                                "http://image.tmdb.org/t/p/w500/${widget.casts[index].profilePath}",
                                width: 80,
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          widget.casts[index].name,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}
