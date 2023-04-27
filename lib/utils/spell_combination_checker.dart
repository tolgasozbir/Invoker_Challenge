import 'package:collection/collection.dart';

class SpellCombinationChecker {
  static final _mapEquality = MapEquality();

  static bool checkEquality(String correctCombination, String currentCombination) {
    if (correctCombination == currentCombination) return true;
    
    Map<String, int> correctCharCounts = {};
    Map<String, int> currentCharCounts = {};

    for (int i = 0; i < 3; i++) {
      String correctChar = correctCombination[i];
      String currentChar = currentCombination[i];
      
      correctCharCounts[correctChar] = (correctCharCounts[correctChar] ?? 0) + 1;
      currentCharCounts[currentChar] = (currentCharCounts[currentChar] ?? 0) + 1;
    }
    
    return _mapEquality.equals(correctCharCounts, currentCharCounts);
  }
}