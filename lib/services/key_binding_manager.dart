import 'dart:convert';

import '../enums/elements.dart';
import '../enums/local_storage_keys.dart';
import 'app_services.dart';

/// Element (Quas/Wex/Exort/Invoke) -> klavye tuşu atamalarını yöneten singleton.
///
/// Atamalar local storage'da JSON olarak (`{"quas": "q", ...}`) saklanır.
class KeyBindingManager {
  KeyBindingManager._();

  static final KeyBindingManager instance = KeyBindingManager._();

  /// Varsayılan düzen: QWER.
  static const Map<Elements, String> defaultBindings = {
    Elements.quas: 'q',
    Elements.wex: 'w',
    Elements.exort: 'e',
    Elements.invoke: 'r',
  };

  final Map<Elements, String> _bindings = {};

  /// Tuşu değiştirilebilen elementler.
  List<Elements> get bindableElements => defaultBindings.keys.toList();

  /// Local storage hazır olduktan sonra (main.dart, initServices sonrası)
  /// çağrılmalıdır.
  void init() => _loadFromStorage();

  /// [element] için atanmış tuş harfi (küçük harf). Atama yoksa varsayılan.
  String keyOf(Elements element) => _bindings[element] ?? defaultBindings[element] ?? '';

  /// [element]'e [key] tuşunu atar.
  ///
  /// Tuş başka bir element tarafından kullanılıyorsa iki element tuşlarını
  /// takas eder; böylece her elementin benzersiz ve dolu bir tuşu olur.
  /// Takas gerçekleştiyse tuşu değişen diğer elementi, aksi halde null döner.
  Future<Elements?> assignKey(Elements element, String key) async {
    final newKey = key.trim().toLowerCase();
    if (newKey.isEmpty) return null;

    final oldKey = keyOf(element);
    if (oldKey == newKey) return null;

    final swappedElement = _elementUsingKey(newKey, except: element);

    _bindings[element] = newKey;
    if (swappedElement != null) _bindings[swappedElement] = oldKey;

    await _saveToStorage();
    return swappedElement;
  }

  Future<void> resetToDefaults() async {
    _bindings
      ..clear()
      ..addAll(defaultBindings);
    await _saveToStorage();
  }

  /// [key] tuşunu kullanan elementi bulur; [except] aramanın dışında tutulur.
  Elements? _elementUsingKey(String key, {required Elements except}) {
    for (final element in defaultBindings.keys) {
      if (element != except && keyOf(element) == key) return element;
    }
    return null;
  }

  void _loadFromStorage() {
    _bindings
      ..clear()
      ..addAll(defaultBindings);

    final raw = AppServices.instance.localStorageService.getValue<String>(LocalStorageKey.keyBindings);
    if (raw == null || raw.isEmpty) return;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      for (final element in defaultBindings.keys) {
        final key = decoded[element.name];
        if (key is String && key.trim().isNotEmpty) {
          _bindings[element] = key.trim().toLowerCase();
        }
      }
    } catch (_) {
      // Bozuk kayıt: varsayılanlarla devam et.
    }
  }

  Future<void> _saveToStorage() async {
    final json = {
      for (final element in defaultBindings.keys) element.name: keyOf(element),
    };
    await AppServices.instance.localStorageService.setValue<String>(
      LocalStorageKey.keyBindings,
      jsonEncode(json),
    );
  }
}
