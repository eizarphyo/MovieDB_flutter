import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HoriListLoader extends StatefulWidget {
  const HoriListLoader({super.key});

  @override
  State<HoriListLoader> createState() => _HoriListLoaderState();
}

class _HoriListLoaderState extends State<HoriListLoader> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.background,
                  highlightColor: Colors.grey,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.22,
                    width: MediaQuery.of(context).size.width * 0.4,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.background,
                  highlightColor: Colors.grey,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.02,
                    width: MediaQuery.of(context).size.width * 0.4,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
