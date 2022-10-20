import 'dart:async';
import '../extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TrueFalseWidget extends StatefulWidget {
  const TrueFalseWidget({Key? key,}) : super(key: key);

  @override
  State<TrueFalseWidget> createState() => TrueFalseWidgetState();
}

class TrueFalseWidgetState extends State<TrueFalseWidget> with TickerProviderStateMixin {

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
      duration: Duration(milliseconds: 600)
    );
    
    _animControlFalse = AnimationController(
      vsync: this, 
      duration: Duration(milliseconds: 600)
    );

    _animTranslateTrue = _translateTween.animate(_animControlTrue);
    _animTranslateFalse = _translateTween.animate(_animControlFalse);
    _animAlphaTrue = _opacityTween.animate(_animControlTrue);
    _animAlphaFalse= _opacityTween.animate(_animControlFalse);

    //add listener and repositioned to calculated size
    Future.microtask((){
      _translateTween = Tween(
        begin: context.dynamicHeight(0.08), 
        end: -context.dynamicHeight(0.12),
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
          Transform.translate(offset: Offset(0.0, _animTranslateTrue.value),
            child: Opacity(
              opacity: _animAlphaTrue.value,
              child: Icon(
                FontAwesomeIcons.check,color: Color(0xFF33CC33),
              ),
            ),
          ),
          Transform.translate(offset: Offset(0.0, _animTranslateFalse.value),
            child: Opacity(
              opacity: _animAlphaFalse.value,
              child: Icon(
                FontAwesomeIcons.times,color: Color(0xFFCC3333),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void trueAnimationForward(){
    _animControlTrue.forward();
    Timer(Duration(milliseconds: 600), ()=> _animControlTrue.reset());
  }

  void falseAnimationForward(){
    _animControlFalse.forward();
    Timer(Duration(milliseconds: 600), ()=> _animControlFalse.reset());
  }
}