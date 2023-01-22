import 'dart:async';
import '../extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum IconType { True, False }

class TrueFalseIconWidget extends StatefulWidget {
  const TrueFalseIconWidget({Key? key,}) : super(key: key);

  @override
  State<TrueFalseIconWidget> createState() => TrueFalseWidgetState();
}

class TrueFalseWidgetState extends State<TrueFalseIconWidget> with TickerProviderStateMixin {

  final Duration _animDuration = const Duration(milliseconds: 600);

  Tween<double> _translateTween = Tween(
    begin: 56.0, 
    end: -86.0,
  );

  Tween<double> _opacityTween = Tween(
    begin: 1.0,
    end: 0.0
  );

  late AnimationController _animControlTrue;
  late Animation<double> _animTranslateTrue;
  late Animation<double> _animAlphaTrue;

  late AnimationController _animControlFalse;
  late Animation<double> _animTranslateFalse;
  late Animation<double> _animAlphaFalse;

  @override
  void initState() {
    super.initState();

    _animControlTrue = AnimationController(
      vsync: this, 
      duration: _animDuration
    );
    
    _animControlFalse = AnimationController(
      vsync: this, 
      duration: _animDuration
    );

    _animTranslateTrue = _translateTween.animate(_animControlTrue);
    _animTranslateFalse = _translateTween.animate(_animControlFalse);
    _animAlphaTrue = _opacityTween.animate(_animControlTrue);
    _animAlphaFalse= _opacityTween.animate(_animControlFalse);

    //added listener and repositioned to calculated size
    Future.microtask((){
      _translateTween = Tween(
        begin: context.dynamicWidth(0.12), 
        end: -context.dynamicWidth(0.24),
      );

      _animTranslateTrue = _translateTween.animate(_animControlTrue)..addListener(()=> setState(() { }));
      _animTranslateFalse = _translateTween.animate(_animControlFalse)..addListener(()=> setState(() { }));
      _animAlphaTrue = _opacityTween.animate(_animControlTrue)..addListener(()=> setState(() { }));
      _animAlphaFalse= _opacityTween.animate(_animControlFalse)..addListener(()=> setState(() { }));
      setState(() { });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          icon(IconType.True),
          icon(IconType.False),
        ],
      ),
    );
  }

  Transform icon(IconType type) {
    return Transform.translate(offset: Offset(0.0, type == IconType.True ? _animTranslateTrue.value : _animTranslateFalse.value),
      child: Opacity(
        opacity: type == IconType.True ? _animAlphaTrue.value : _animAlphaFalse.value,
        child: Icon(
          type == IconType.True ? FontAwesomeIcons.check : FontAwesomeIcons.times,
          color: type == IconType.True ? Color(0xFF33CC33) : Color(0xFFCC3333),
        ),
      ),
    );
  }

  void playAnimation(IconType iconType){
    iconType == IconType.True ? _animControlTrue.forward() : _animControlFalse.forward();
    Timer(_animDuration, ()=> iconType == IconType.True ? _animControlTrue.reset() : _animControlFalse.reset());
  }
}