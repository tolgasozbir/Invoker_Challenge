

import 'package:flutter/foundation.dart';

import '../../constants/app_image_paths.dart';
import '../../enums/elements.dart';
import '../../enums/spells.dart';

enum InvokerSet {
  defaultSet(
    miniMapIcon: ImagePaths.icInvokerMiniMap,
    elementSuffix: '',
    spellSuffix: {},
  ),
  personaSet(
    miniMapIcon: ImagePaths.icInvokerMiniMapPersona,
    elementSuffix: '_persona',
    spellSuffix: {
      Spell.ghost_walk,
      Spell.tornado,
      Spell.alacrity,
      Spell.sun_strike,
      Spell.forge_spirit,
      Spell.deafening_blast,
    },
  );

  final String miniMapIcon;
  final String elementSuffix;
  final Set<Spell> spellSuffix;

  const InvokerSet({
    required this.miniMapIcon,
    required this.elementSuffix,
    required this.spellSuffix,
  });
}

extension InvokerSetExtension on InvokerSet {
  Invoker get type {
    switch (this) {
      case InvokerSet.defaultSet:
        return Invoker.sets[InvokerSet.defaultSet]!;
      case InvokerSet.personaSet:
        return Invoker.sets[InvokerSet.personaSet]!;
    }
  }
}

@immutable
final class Invoker {
  final Map<Elements, String> skills;
  final Map<Spell, String> spells;
  final String miniMapIcon;

  const Invoker({required this.skills, required this.spells, required this.miniMapIcon});

  /// **Tüm Setleri Dinamik Olarak Yarat**
  static final Map<InvokerSet, Invoker> sets = {
    for (var set in InvokerSet.values) set: _createInvoker(set),
  };

  // static final Invoker defaultSet = _createInvoker(InvokerSet.defaultSet);
  // static final Invoker personaSet = _createInvoker(InvokerSet.personaSet);

  static Invoker _createInvoker(InvokerSet set) {
    return Invoker(
      miniMapIcon: set.miniMapIcon,
      skills: _buildImageMap(
        Elements.values,
        ImagePaths.elements,
        (element) => element == Elements.invoke ? '' : set.elementSuffix,
      ),
      spells: _buildImageMap(
        Spell.values,
        ImagePaths.spells,
        (spell) => set.spellSuffix.contains(spell) ? '_persona' : '',
      ),
    );
  }

  static Map<T, String> _buildImageMap<T>(
    Iterable<T> values,
    String basePath,
    String Function(T) suffixBuilder,
  ) => {
      for (final value in values) 
        value: '$basePath${value.toString().split('.').last}${suffixBuilder(value)}.png',
  };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Invoker &&
            mapEquals(other.skills, skills) &&
            mapEquals(other.spells, spells) &&
            other.miniMapIcon == miniMapIcon);
  }

  @override
  int get hashCode => Object.hash(skills, spells, miniMapIcon);
}
