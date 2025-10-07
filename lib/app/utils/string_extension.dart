extension StringExtension on String {
  String capitalize() {
    return split(' ')
        .map((word) {
          if (word.isNotEmpty) {
            return "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}";
          }
          return word;
        })
        .join(' ');
  }
}
