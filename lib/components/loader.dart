import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 1),
        // color: Color.fromARGB(227, 158, 158, 158),
        child: LoadingAnimationWidget.waveDots(
            color: Colors.grey,
            size: MediaQuery.of(context).size.height * 0.05),
      ),
    );
  }
}
