import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final String title;

  const LoadingView({
    super.key,
    this.title = '',
  });

  @override
  Widget build(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(title),
          ),
        CircularProgressIndicator(),
      ],
    );
  }
}
