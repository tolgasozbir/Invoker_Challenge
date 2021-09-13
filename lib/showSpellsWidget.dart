import 'package:flutter/material.dart';

class ShowSpellsWidget extends StatelessWidget {
  const ShowSpellsWidget({
    Key? key,
    required this.showSpellsVisible,
    required this.spellList,
    required this.width,
    required this.height,
  }) : super(key: key);

  final bool showSpellsVisible;
  final List<String> spellList;
  final double height;
  final double width;


  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showSpellsVisible,
      child: SizedBox(
        width: double.infinity, 
        height: height, 
        child: Card(
          color: Colors.black12,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
          
                firstColumn(),
                secondColumn(),
                thirdColumn(),
          
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget firstColumn() {
    return Card(
      color: Color(0x333DA5FF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Card(
            color: Color(0x443DA5FF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(spellList[0],scale: 5,), 
                Card(color: Color(0x703DA5FF), child: Text(" Q ", style: TextStyle(fontSize: 17),)),
                Card(color: Color(0x703DA5FF), child: Text(" Q ", style: TextStyle(fontSize: 17),)),
                Card(color: Color(0x703DA5FF), child: Text(" Q ", style: TextStyle(fontSize: 17),)),
              ],
            ),
          ),      
          Card(
            color: Color(0x443DA5FF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(spellList[1],scale: 5,), 
                Card(color: Color(0x703DA5FF), child: Text(" Q ", style: TextStyle(fontSize: 17),)),
                Card(color: Color(0x703DA5FF), child: Text(" Q ", style: TextStyle(fontSize: 17),)),
                Card(color: Color(0x70EC3DFF), child: Text(" W ", style: TextStyle(fontSize: 17),)),
              ],
            ),
          ),      
          Card(
            color: Color(0x443DA5FF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(spellList[2],scale: 5,), 
                Card(color: Color(0x703DA5FF), child: Text(" Q ", style: TextStyle(fontSize: 17),)),
                Card(color: Color(0x703DA5FF), child: Text(" Q ", style: TextStyle(fontSize: 17),)),
                Card(color: Color(0x70FFAA00), child: Text(" E ", style: TextStyle(fontSize: 17),)),
              ],
            ),
          ),    ],
      ),
    );
  }

  Widget secondColumn() {
    return SingleChildScrollView(
      child: Card(
        color: Color(0x23EC3DFF),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Card(
              color: Color(0x34EC3DFF),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(spellList[3],scale: 5,), 
                  Card(color: Color(0x60EC3DFF), child: Text(" W ", style: TextStyle(fontSize: 17),)),
                  Card(color: Color(0x60EC3DFF), child: Text(" W ", style: TextStyle(fontSize: 17),)),
                  Card(color: Color(0x60EC3DFF), child: Text(" W ", style: TextStyle(fontSize: 17),)),
                ],
              ),
            ),
            Card(
              color: Color(0x34EC3DFF),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(spellList[4],scale: 5,), 
                  Card(color: Color(0x60EC3DFF), child: Text(" W ", style: TextStyle(fontSize: 17),)),
                  Card(color: Color(0x60EC3DFF), child: Text(" W ", style: TextStyle(fontSize: 17),)),
                  Card(color: Color(0x703DA5FF), child: Text(" Q ", style: TextStyle(fontSize: 17),)),
                ],
              ),
            ),
            Card(
              color: Color(0x34EC3DFF),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(spellList[5],scale: 5,), 
                  Card(color: Color(0x60EC3DFF), child: Text(" w ", style: TextStyle(fontSize: 17),)),
                  Card(color: Color(0x60EC3DFF), child: Text(" W ", style: TextStyle(fontSize: 17),)),
                  Card(color: Color(0x70FFAA00), child: Text(" E ", style: TextStyle(fontSize: 17),)),
                ],
              ),
            ),
            Card(
              color: Color(0x34EC3DFF),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(spellList[6],scale: 5,), 
                  Card(color: Color(0x703DA5FF), child: Text(" Q ", style: TextStyle(fontSize: 17),)),
                  Card(color: Color(0x60EC3DFF), child: Text(" W ", style: TextStyle(fontSize: 17),)),
                  Card(color: Color(0x70FFAA00), child: Text(" E ", style: TextStyle(fontSize: 17),)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget thirdColumn() {
    return Card(
      color: Color(0x33EE9900),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Card(
            color: Color(0x22FFAA11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(spellList[7],scale: 5,), 
                Card(color: Color(0x70FFAA00), child: Text(" E ", style: TextStyle(fontSize: 17),)),
                Card(color: Color(0x70FFAA00), child: Text(" E ", style: TextStyle(fontSize: 17),)),
                Card(color: Color(0x70FFAA00), child: Text(" E ", style: TextStyle(fontSize: 17),)),
              ],
            ),
          ),
          Card(
            color: Color(0x22FFAA11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(spellList[8],scale: 5,), 
                Card(color: Color(0x70FFAA00), child: Text(" E ", style: TextStyle(fontSize: 17),)),
                Card(color: Color(0x70FFAA00), child: Text(" E ", style: TextStyle(fontSize: 17),)),
                Card(color: Color(0x703DA5FF), child: Text(" Q ", style: TextStyle(fontSize: 17),)),
              ],
            ),
          ),
          Card(
            color: Color(0x22FFAA11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(spellList[9],scale: 5,), 
                Card(color: Color(0x70FFAA00), child: Text(" E ", style: TextStyle(fontSize: 17),)),
                Card(color: Color(0x70FFAA00), child: Text(" E ", style: TextStyle(fontSize: 17),)),
                Card(color: Color(0x60EC3DFF), child: Text(" W ", style: TextStyle(fontSize: 17),)),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
