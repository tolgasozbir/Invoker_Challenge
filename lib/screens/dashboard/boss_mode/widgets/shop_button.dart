import 'package:dota2_invoker_game/screens/dashboard/boss_mode/widgets/shop_view.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/bouncing_button.dart';


class ShopButton extends StatelessWidget {
  const ShopButton({super.key,});

  @override
  Widget build(BuildContext context) {
    return BouncingButton(
      child: Stack(
        children: [
          Container(
            width: 72,
            height: kToolbarHeight,
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: LinearGradient(
                colors: [Color(0xFFE7CB90), Color(0xFF584226), Color(0xFFAB945A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            ),
          ),
          Container(
            width: 64,
            alignment: Alignment.center,
            height: kToolbarHeight,
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: LinearGradient(
                colors: [Color(0xFFD9BA00), Color(0xFFF4C400), Color(0xFF7E5B0C)],
                stops: [0, .2, 1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            ),
            child: Text(
              "SHOP", 
              style: TextStyle(
                fontSize: 16, 
                color: Color(0xFFFBFBCC), 
                fontWeight: FontWeight.bold, 
                shadows: [Shadow(blurRadius: 2)]
              ),
            ),
          ),
        ],
      ),
      onPressed: () {
        print("Shop");
        //hohoh you found me sound
        Navigator.push(context, MaterialPageRoute(builder: (context) => ShopView(),));
      },
    );
  }
}