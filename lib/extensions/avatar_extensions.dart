import 'package:flutter/material.dart';

extension StringExtensions on String {
  static const animalsList = [
    'bee',
    'cat',
    'chameleon',
    'crab',
    // 'dog',
    'dolphin',
    'duck',
    'elephant',
    'fish',
    'flamingo',
    'frog',
    'giraffe',
    'hedgehog',
    'hermitcrab',
    'hippopotamus',
    'horse',
    'kangaroo',
    'kiwi',
    'koala',
    'lion',
    'llama',
    'lobster',
    // 'meerkat',
    'octopus',
    'ostrich',
    'owl',
    'panda',
    'parrot',
    'penguin',
    'rabbit',
    'seahorse',
    'seal',
    'shark',
    'squirrel',
    'swan',
    'toucan',
    'turtle',
    'walrus',
    'whale',
  ];

  int hashSum() {
    return codeUnits.reduce((a, b) => a + b);
  }

  String avatarPath() {
    final index = hashSum() % animalsList.length;

    return 'assets/icons/animals/${animalsList[index]}.svg';
  }

  Color toColor({double saturation = 0.62, double lightness = 0.62}) {
    int hash = 0;

    for (int i = 0; i < length; i++) {
      hash = codeUnitAt(i) + ((hash << 5) - hash);
    }

    return HSLColor.fromAHSL(1.0, hash % 360.0, saturation, lightness)
        .toColor();
  }

  // String avatarColor(Color color) {
  //   switch (ThemeData.estimateBrightnessForColor(color)) {
  //     case Brightness.dark:
  //       return Colors.white;
  //     case Brightness.light:
  //       return Colors.black;
  //   }
  // }
}
