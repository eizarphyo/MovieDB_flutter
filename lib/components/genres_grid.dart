import 'package:flutter/material.dart';
import '../model/details.dart';

class GenresGrid extends StatefulWidget {
  const GenresGrid({super.key, required this.genres});
  final List<Genre> genres;

  @override
  State<GenresGrid> createState() => _GenresGridState();
}

class _GenresGridState extends State<GenresGrid> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.width * 0.15,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1 / 0.3),
              itemCount: widget.genres.length,
              itemBuilder: (context, i) {
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius:
                          const BorderRadius.all(Radius.elliptical(300, 300))),
                  child: Center(
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: widget.genres[i].name,
                          style: Theme.of(context).textTheme.labelSmall,
                        )),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
