import 'package:auto_size_text/auto_size_text.dart';
import 'package:dota2_invoker_game/constants/locale_keys.g.dart';
import 'package:dota2_invoker_game/enums/local_storage_keys.dart';
import 'package:dota2_invoker_game/extensions/color_extension.dart';
import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:dota2_invoker_game/mixins/screen_state_mixin.dart';
import 'package:dota2_invoker_game/models/circle_theme_model.dart';
import 'package:dota2_invoker_game/providers/color_settings_provider.dart';
import 'package:dota2_invoker_game/services/app_services.dart';
import 'package:dota2_invoker_game/widgets/app_snackbar.dart';
import 'package:dota2_invoker_game/widgets/empty_box.dart';
import 'package:flutter/material.dart';

import 'package:dota2_invoker_game/constants/app_colors.dart';
import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:provider/provider.dart';

class CircleColorCustomizer extends StatefulWidget {
  const CircleColorCustomizer({super.key});

  @override
  State<CircleColorCustomizer> createState() => _CircleColorCustomizerState();
}

class _CircleColorCustomizerState extends State<CircleColorCustomizer> with ScreenStateMixin {
  // State variables for circle colors
  Color _outerCircleColor   = AppColors.circleColor; // Default outer color
  Color _middleCircleColor  = AppColors.circleColor; // Default middle color
  Color _innerCircleColor   = AppColors.circleColor; // Default inner color

  // Default colors from constants for reset
  final Color _defaultCircleColor = AppColors.circleColor;

  // Tracks which circle's color is being edited in the modal
  String? _editingCircle; // 'inner', 'middle', 'outer' or null

  // Full color palette for the picker
  final List<Color> _colorPalette = [
    const Color(0xFFF44336), // Red
    const Color(0xFFE91E63), // Pink
    const Color(0xFF9C27B0), // Purple
    const Color(0xFF673AB7), // Deep Purple
    const Color(0xFF3F51B5), // Indigo
    const Color(0xFF2196F3), // Blue
    const Color(0xFF03A9F4), // Light Blue
    const Color(0xFF00BCD4), // Cyan
    const Color(0xFF009688), // Teal
    const Color(0xFF4CAF50), // Green
    const Color(0xFF8BC34A), // Light Green
    const Color(0xFFCDDC39), // Lime
    const Color(0xFFFFEB3B), // Yellow
    const Color(0xFFFFC107), // Amber
    const Color(0xFFFF9800), // Orange
    const Color(0xFFFF5722), // Deep Orange
    const Color(0xFF80471C), // Brown
    const Color(0xFF9E9E9E), // Grey
    const Color(0xFF607D8B), // Blue Grey
    const Color(0xFFFFFFFF), // White
  ];

  // Preset color themes - Using distinct and varied harmonious colors ONLY from _colorPalette
  final List<ColorThemeModel> _colorThemes = [
    const ColorThemeModel(
      name: LocaleKeys.ColorPicker_ColorThemeKeys_mist, 
      outer: Color(0xFF673AB7), 
      middle: Color(0xFF9C27B0), 
      inner: Color(0xFFE91E63),
    ),
    const ColorThemeModel(
      name: LocaleKeys.ColorPicker_ColorThemeKeys_cool, 
      outer: Color(0xFF2196F3), 
      middle: Color(0xFF00BCD4), 
      inner: Color(0xFF009688),
    ),
    const ColorThemeModel(
      name: LocaleKeys.ColorPicker_ColorThemeKeys_nature, 
      outer: Color(0xFF009688), 
      middle: Color(0xFF4CAF50), 
      inner: Color(0xFFCDDC39),
    ),
    const ColorThemeModel(
      name: LocaleKeys.ColorPicker_ColorThemeKeys_flame, 
      outer: Color(0xFFF44336), 
      middle: Color(0xFFFF9800), 
      inner: Color(0xFFFFEB3B),
    ),
    const ColorThemeModel(
      name: LocaleKeys.ColorPicker_ColorThemeKeys_terra, 
      outer: Color(0xFF80471C), 
      middle: Color(0xFFFF5722), 
      inner: Color(0xFFFF9800),
    ),
    const ColorThemeModel(
      name: LocaleKeys.ColorPicker_ColorThemeKeys_aqua, 
      outer: Color(0xFF00BCD4), 
      middle: Color(0xFF03A9F4), 
      inner: Color(0xFF607D8B),
    ),
    const ColorThemeModel(
      name: LocaleKeys.ColorPicker_ColorThemeKeys_contrast, 
      outer: Color(0xFF2196F3), 
      middle: Color(0xFF9E9E9E), 
      inner: Color(0xFFFF9800),
    ),
    const ColorThemeModel(
      name: LocaleKeys.ColorPicker_ColorThemeKeys_vibe, 
      outer: Color(0xFFE91E63), 
      middle: Color(0xFF9C27B0), 
      inner: Color(0xFF3F51B5),
    ),
    const ColorThemeModel(
      name: LocaleKeys.ColorPicker_ColorThemeKeys_light, 
      outer: Color(0xFF2196F3), 
      middle: Color(0xFF4CAF50), 
      inner: Color(0xFFFFEB3B),
    ),
    const ColorThemeModel(
      name: LocaleKeys.ColorPicker_ColorThemeKeys_berry, 
      outer: Color(0xFFE91E63), 
      middle: Color(0xFF9C27B0), 
      inner: Color(0xFF009688),
    ),
    const ColorThemeModel(
      name: LocaleKeys.ColorPicker_ColorThemeKeys_sky, 
      outer: Color(0xFFFFFFFF), 
      middle: Color(0xFF03A9F4), 
      inner: Color(0xFF00BCD4),
    ),
  ];


  @override
  void initState() {
    super.initState();
    _loadColors(); // Load colors when the widget initializes
  }

  // --- Shared Preferences Methods ---

  // Load colors from shared preferences
  Future<void> _loadColors() async {
    final defaultColor = _defaultCircleColor.toARGB32();

    final cache = AppServices.instance.localStorageService;
    final cacheOuter   = cache.getValue<int>(LocalStorageKey.outerColor)  ?? defaultColor;
    final cacheMiddle  = cache.getValue<int>(LocalStorageKey.middleColor) ?? defaultColor;
    final cacheInner   = cache.getValue<int>(LocalStorageKey.innerColor)  ?? defaultColor;

    _outerCircleColor   = Color(cacheOuter);
    _middleCircleColor  = Color(cacheMiddle);
    _innerCircleColor   = Color(cacheInner);
  }

  // Save current colors to shared preferences
  Future<void> _saveColors() async {
    final cache = AppServices.instance.localStorageService;
    await cache.setValue<int>(LocalStorageKey.outerColor,  _outerCircleColor.toARGB32());
    await cache.setValue<int>(LocalStorageKey.middleColor, _middleCircleColor.toARGB32());
    await cache.setValue<int>(LocalStorageKey.innerColor,  _innerCircleColor.toARGB32());
    context.read<ColorSettingsProvider>().updateColors(
      healthColor: _outerCircleColor, 
      roundColor: _middleCircleColor, 
      timeColor: _innerCircleColor,
    );
    AppSnackBar.showSnackBarMessage(text: 'Başarılı', snackBartype: SnackBarType.success);
  }

  // Reset colors to default and save
  void _resetToDefault() {
    _outerCircleColor = _defaultCircleColor;
    _middleCircleColor = _defaultCircleColor;
    _innerCircleColor = _defaultCircleColor;
    updateScreen();
    _saveColors(); // Save the default colors
  }

  // --- UI Build Methods ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.ColorPicker_customizeColors.locale),
      ),
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Circle preview area
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer Circle
                _buildCircle(0.60, _outerCircleColor),
                // Middle Circle
                _buildCircle(0.48, _middleCircleColor),
                // Inner Circle
                _buildCircle(0.36, _innerCircleColor),
              ],
            ),
          ),
        ),

        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const EmptyBox.h12(), // Added spacing

                // Color selection rows
                _buildCircleColorPickerRow(
                  LocaleKeys.ColorPicker_CircleLabels_outer.locale,
                  _outerCircleColor,
                  (color) {
                    setState(() {
                      _outerCircleColor = color;
                    });
                  },
                ),
                 const EmptyBox.h8(), // Spacing between rows
                 _buildCircleColorPickerRow(
                  LocaleKeys.ColorPicker_CircleLabels_middle.locale,
                  _middleCircleColor,
                  (color) {
                    setState(() {
                      _middleCircleColor = color;
                    });
                  },
                ),
                const EmptyBox.h8(), // Spacing between rows
                _buildCircleColorPickerRow(
                  LocaleKeys.ColorPicker_CircleLabels_inner.locale,
                  _innerCircleColor,
                  (color) {
                    setState(() {
                      _innerCircleColor = color;
                    });
                  },
                ),

                const EmptyBox.h12(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    LocaleKeys.ColorPicker_presetThemes.locale,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                // Theme selection row
                Expanded(
                  child: ListView.builder(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _colorThemes.length,
                    itemBuilder: (context, index) {
                      final theme = _colorThemes[index];
                      return Padding(
                        padding: EdgeInsets.only(right: index == _colorThemes.length - 1 ? 0 : 12), // No padding after last item
                        child: GestureDetector(
                          onTap: () {
                            // Apply theme colors
                            _outerCircleColor = theme.outer;
                            _middleCircleColor = theme.middle;
                            _innerCircleColor = theme.inner;
                            updateScreen();
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  // Using a simple gradient for theme preview
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                       theme.outer,
                                       theme.middle,
                                       theme.inner,
                                    ],
                                    stops: const [0.0, 0.5, 1.0], // Distribute colors
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.outer.withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                              const EmptyBox.h4(),
                              SizedBox(
                                width: 42,
                                child: Text(
                                  theme.name.locale,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[400],
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Reset and Save buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _resetToDefault, // Call the reset function
                      icon: const Icon(Icons.restart_alt),
                      label: Text(LocaleKeys.ColorPicker_reset.locale),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[400],
                        side: BorderSide(color: Colors.grey[700]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const EmptyBox.w24(),
                    ElevatedButton.icon(
                      onPressed: _saveColors, // Call the save function
                      icon: const Icon(Icons.check),
                      label: Text(LocaleKeys.ColorPicker_apply.locale),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to build a single circle preview
  Widget _buildCircle(double size, Color color) {
    return Container(
      width: context.dynamicWidth(size),
      height: context.dynamicWidth(size),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        //color: color.withOpacity(0.2), // Use original color with opacity for fill
        border: Border.all(color: color, width: 4), // Use darker color for border
      ),
    );
  }

  // Helper method to build a color selection row for a specific circle
  Widget _buildCircleColorPickerRow(String label, Color currentColor, ValueChanged<Color> onColorSelected) {
    return Row(
      children: [
        // Current color indicator
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentColor, // Use the actual selected color
             border: Border.all(
              color: currentColor.darkerColor(), // Darker border for indicator
              width: 2,
            ),
          ),
        ),
        const EmptyBox.w8(),
        // Label for the circle
        Expanded( // Use Expanded to prevent overflow
          child: AutoSizeText(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
               color: Colors.white70, // Added a color for visibility
            ),
             maxLines: 1,
          ),
        ),
        const EmptyBox.w8(), // Spacing
        // Button to open color picker
        OutlinedButton.icon(
          onPressed: () {
            // Set which circle is being edited and show the picker
             setState(() {
               _editingCircle = label; // Use the label to identify
             });
            _showColorPickerSheet(
              initialColor: currentColor,
              onColorSelected: (selectedColor) {
                 // This callback is triggered when a color is tapped in the picker
                 onColorSelected(selectedColor); // Pass the color back to update the specific circle
              },
              setModalState: (VoidCallback fn) {
                 // This parameter is the setModalState from the StatefulBuilder
                 // It's not directly used here, but shows how you *could* update modal state if needed
                 fn(); // Execute the function passed from the modal
              },
            );
          },
          icon: Icon(Icons.colorize, color: currentColor), // Icon color matches circle
          label: Text(LocaleKeys.ColorPicker_selectColor.locale),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: currentColor.darkerColor()), // Darker border for button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
             foregroundColor: currentColor, // Text color matches circle
          ),
        ),
      ],
    );
  }

  // Shows the color picker bottom sheet
  void _showColorPickerSheet({
    required Color initialColor,
    required ValueChanged<Color> onColorSelected,
    required void Function(VoidCallback fn) setModalState, // Added setModalState parameter
  }) {
    Color tempSelectedColor = initialColor; // Keep track of selection within the modal

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF212121),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        // Use StatefulBuilder to manage the internal state of the modal (like the checkmark)
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateInsideModal) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // Display which circle is being edited
                        _editingCircle ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Added color
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white,), // Added color
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const EmptyBox.h16(),
                  // Color palette grid
                  Expanded( // Added Expanded to make the grid scrollable if needed
                    child: GridView.builder(
                       shrinkWrap: true, // Important for Expanded inside Column
                       physics: const ClampingScrollPhysics(), // Prevent excessive scrolling
                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5, // Number of columns
                          crossAxisSpacing: 16, // Spacing between columns
                          mainAxisSpacing: 16, // Spacing between rows
                        ),
                       itemCount: _colorPalette.length,
                       itemBuilder: (context, index) {
                          final color = _colorPalette[index];
                          // Determine if this color is currently selected in the modal
                          final bool isSelected = tempSelectedColor.toARGB32() == color.toARGB32();

                          return GestureDetector(
                            onTap: () {
                              setStateInsideModal(() {
                                // Update the temporary color within the modal
                                tempSelectedColor = color;
                              });
                              // Immediately update the main state and close the modal
                              onColorSelected(color); // Use the callback to update the main state
                              Navigator.pop(context); // Close the modal
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? Colors.white : Colors.transparent,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          );
                       },
                    ),
                  ),
                  const EmptyBox.h16(), // Spacing below grid
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
       // Reset editing state when modal is closed
       setState(() {
         _editingCircle = null;
       });
    });
  }
}
