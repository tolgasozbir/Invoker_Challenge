import 'package:dota2_invoker/constants/app_colors.dart';
import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:dota2_invoker/screens/dashboard/loading_view.dart';
import 'package:flutter/material.dart';
import '../services/sound_service.dart';

class MenuButton extends StatefulWidget {
  const MenuButton({
    required this.fadeInDuration,
    required this.color,
    required this.imagePath,
    required this.title,
    required this.navigatePage,
    this.primaryColor,
    Key? key, 
  }) : super(key: key);

  final Duration fadeInDuration;
  final Color color;
  final Color? primaryColor;
  final String imagePath;
  final String title;
  final Widget navigatePage;

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  double _fadeInOpacity=0;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    await Future.delayed(Duration(milliseconds: 400), (){
      setState(() => _fadeInOpacity = 1 );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: AnimatedOpacity(
        opacity: _fadeInOpacity, 
        duration: widget.fadeInDuration,
        child: button(context),
      ),
    );
  }

  SizedBox button(BuildContext context) {

    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      primary: widget.primaryColor ?? AppColors.buttonSurfaceColor,
      elevation: 10,
      shadowColor: widget.color,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        side: BorderSide(color: widget.color),
      )
    );

    return SizedBox(
      width: context.dynamicWidth(0.8),
      child:  ElevatedButton(
        style: buttonStyle,
        child: buttonSurface(context),
        onPressed: () {
          SoundService.instance.playSoundBegining();
          Navigator.push(context, MaterialPageRoute(builder: (context)=> LoadingView(page: widget.navigatePage)));
        },
      ),
    );
  }

  Row buttonSurface(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: context.dynamicHeight(0.1),
          width: context.dynamicWidth(0.12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage(widget.imagePath),
            fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          "${widget.title}  ",
          style: TextStyle(fontSize: context.sp(16)),
        ),
      ],
    );
  }
}