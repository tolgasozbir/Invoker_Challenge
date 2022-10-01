import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:dota2_invoker/providers/spell_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpellsHelperWidget extends StatefulWidget {
  SpellsHelperWidget({Key? key, this.height,}) : super(key: key);
  
  final double? height;

  @override
  State<SpellsHelperWidget> createState() => _SpellsHelperWidgetState();
}

class _SpellsHelperWidgetState extends State<SpellsHelperWidget> {
  late final _spellImagePaths;

  @override
  void initState() {
    _spellImagePaths = context.read<SpellProvider>().getAllSpellImagePaths;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? context.dynamicHeight(0.24), 
      child: Card(
        color: Colors.black12,
        child: Row(
          children: [
            quasColumn(),
            wexColumn(),
            exortColumn(),
          ],
        ),
      ),
    );
  }

  Widget quasColumn() {
    return Expanded(
      child: Card(
        color: Color(0x333DA5FF),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Color(0x443DA5FF),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(_spellImagePaths[0],scale: 5,),   //TODO: Q W E  enum yap değere göre kendisini oluştursun
                  Card(color: Color(0x703DA5FF), child: Text(" Q ", style: TextStyle(fontSize: 17),)),
                  Card(color: Color(0x703DA5FF), child: Text(" Q ", style: TextStyle(fontSize: 17),)),
                  Card(color: Color(0x703DA5FF), child: Text(" Q ", style: TextStyle(fontSize: 17),)),
                ],
              ),
            ),
            Card(
              color: Color(0x443DA5FF),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(_spellImagePaths[1],scale: 5,),
                  Card(color: Color(0x703DA5FF), child: Text(" Q ", style: TextStyle(fontSize: 17),)),
                  Card(color: Color(0x703DA5FF), child: Text(" Q ", style: TextStyle(fontSize: 17),)),
                  Card(color: Color(0x70EC3DFF), child: Text(" W ", style: TextStyle(fontSize: 17),)),
                ],
              ),
            ),
            Card(
              color: Color(0x443DA5FF),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(_spellImagePaths[2],scale: 5,),
                  Card(color: Color(0x703DA5FF), child: Text(" Q ", style: TextStyle(fontSize: 17),)),
                  Card(color: Color(0x703DA5FF), child: Text(" Q ", style: TextStyle(fontSize: 17),)),
                  Card(color: Color(0x70FFAA00), child: Text(" E ", style: TextStyle(fontSize: 17),)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget wexColumn() {
    return Card(
      color: Color(0x23EC3DFF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            color: Color(0x34EC3DFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(_spellImagePaths[3],scale: 5,), 
                Card(color: Color(0x60EC3DFF), child: Text(" W ", style: TextStyle(fontSize: 17),)),
                Card(color: Color(0x60EC3DFF), child: Text(" W ", style: TextStyle(fontSize: 17),)),
                Card(color: Color(0x60EC3DFF), child: Text(" W ", style: TextStyle(fontSize: 17),)),
              ],
            ),
          ),
          Card(
            color: Color(0x34EC3DFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(_spellImagePaths[4],scale: 5,), 
                Card(color: Color(0x60EC3DFF), child: Text(" W ", style: TextStyle(fontSize: 17),)),
                Card(color: Color(0x60EC3DFF), child: Text(" W ", style: TextStyle(fontSize: 17),)),
                Card(color: Color(0x703DA5FF), child: Text(" Q ", style: TextStyle(fontSize: 17),)),
              ],
            ),
          ),
          Card(
            color: Color(0x34EC3DFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(_spellImagePaths[5],scale: 5,), 
                Card(color: Color(0x60EC3DFF), child: Text(" W ", style: TextStyle(fontSize: 17),)),
                Card(color: Color(0x60EC3DFF), child: Text(" W ", style: TextStyle(fontSize: 17),)),
                Card(color: Color(0x70FFAA00), child: Text(" E ", style: TextStyle(fontSize: 17),)),
              ],
            ),
          ),
          Card(
            color: Color(0x34EC3DFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(_spellImagePaths[6],scale: 5,), 
                Card(color: Color(0x703DA5FF), child: Text(" Q ", style: TextStyle(fontSize: 17),)),
                Card(color: Color(0x60EC3DFF), child: Text(" W ", style: TextStyle(fontSize: 17),)),
                Card(color: Color(0x70FFAA00), child: Text(" E ", style: TextStyle(fontSize: 17),)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget exortColumn() {
    return Expanded(
      child: Card(
        color: Color(0x33EE9900),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Color(0x22FFAA11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(_spellImagePaths[7],scale: 5,), 
                  Card(color: Color(0x70FFAA00), child: Text(" E ", style: TextStyle(fontSize: 17),)),
                  Card(color: Color(0x70FFAA00), child: Text(" E ", style: TextStyle(fontSize: 17),)),
                  Card(color: Color(0x70FFAA00), child: Text(" E ", style: TextStyle(fontSize: 17),)),
                ],
              ),
            ),
            Card(
              color: Color(0x22FFAA11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(_spellImagePaths[8],scale: 5,), 
                  Card(color: Color(0x70FFAA00), child: Text(" E ", style: TextStyle(fontSize: 17),)),
                  Card(color: Color(0x70FFAA00), child: Text(" E ", style: TextStyle(fontSize: 17),)),
                  Card(color: Color(0x703DA5FF), child: Text(" Q ", style: TextStyle(fontSize: 17),)),
                ],
              ),
            ),
            Card(
              color: Color(0x22FFAA11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(_spellImagePaths[9],scale: 5,), 
                  Card(color: Color(0x70FFAA00), child: Text(" E ", style: TextStyle(fontSize: 17),)),
                  Card(color: Color(0x70FFAA00), child: Text(" E ", style: TextStyle(fontSize: 17),)),
                  Card(color: Color(0x60EC3DFF), child: Text(" W ", style: TextStyle(fontSize: 17),)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
