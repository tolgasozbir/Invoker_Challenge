import 'package:collection/collection.dart';

class SpellCombinationChecker {
  static const _mapEquality = MapEquality();

  static bool checkEquality(String correctCombination, String currentCombination) {
    if (correctCombination == currentCombination) return true;
    
    final Map<String, int> correctCharCounts = {};
    final Map<String, int> currentCharCounts = {};

    for (int i = 0; i < 3; i++) {
      final String correctChar = correctCombination[i];
      final String currentChar = currentCombination[i];
      
      correctCharCounts[correctChar] = (correctCharCounts[correctChar] ?? 0) + 1;
      currentCharCounts[currentChar] = (currentCharCounts[currentChar] ?? 0) + 1;
    }
    
    return _mapEquality.equals(correctCharCounts, currentCharCounts);
  }
}
