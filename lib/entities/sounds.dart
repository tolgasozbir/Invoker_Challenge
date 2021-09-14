import 'dart:math';
import 'package:audioplayers/audioplayers.dart';


class Sounds {
  
  final _player = AudioCache();
  Random _rnd=Random();

  void playSound(String sound){
    _player.play(sound,volume: 0.50);
  }

  void playSoundBegining(){
    int random=_rnd.nextInt(_beginingSound.length);
    _player.play(_beginingSound[random],volume: 0.30);
  }

  void failCombinationSound(){
    int random=_rnd.nextInt(_beginingSound.length);
    _player.play(_failSound[random],volume: 0.15);
  }

  String _orbValue="";

  void trueCombinationSound(List<String> combination){
    for (var item in combination) {
      _orbValue+=item;
    }
    switch (_orbValue) {
      case "qqq": _player.play(_coldSnapSound[_rnd.nextInt(_coldSnapSound.length)],volume: 0.15); break;
      case "qqw": _player.play(_ghostWalkSound[_rnd.nextInt(_ghostWalkSound.length)],volume: 0.15); break;
      case "qqe": _player.play(_iceWallSound[_rnd.nextInt(_iceWallSound.length)],volume: 0.15); break;
      case "www": _player.play(_emp[_rnd.nextInt(_emp.length)],volume: 0.15); break;
      case "wwq": _player.play(_tornado[_rnd.nextInt(_tornado.length)],volume: 0.15); break;
      case "wwe": _player.play(_alacrity[_rnd.nextInt(_alacrity.length)],volume: 0.15); break;
      case "eee": _player.play(_sunStrike[_rnd.nextInt(_sunStrike.length)],volume: 0.15); break;
      case "eeq": _player.play(_forgeSpirit[_rnd.nextInt(_forgeSpirit.length)],volume: 0.15); break;
      case "eew": _player.play(_chaosMeteor[_rnd.nextInt(_chaosMeteor.length)],volume: 0.15); break;
      case "qwe": _player.play(_blast[_rnd.nextInt(_blast.length)],volume: 0.15); break;
      default:
    }
    _orbValue="";
  }

  List<String> _blast=[
    "blast1.mp3",
    "blast2.mp3",
    "blast3.mp3",
  ];

  List<String> _chaosMeteor=[
    "meteor1.mp3",
    "meteor2.mp3",
  ];

  List<String> _forgeSpirit=[
    "forge_spirit1.mp3",
    "forge_spirit2.mp3",
  ];

  List<String> _sunStrike=[
    "sunstrike1.mp3",
    "sunstrike2.mp3",
    "sunstrike3.mp3",
  ];

  List<String> _alacrity=[
    "alacrity1.mp3",
    "alacrity2.mp3",
  ];

  List<String> _tornado=[
    "tornado1.mp3",
    "tornado2.mp3",
    "tornado3.mp3",
  ];

  List<String> _emp=[
    "emp1.mp3",
    "emp2.mp3",
    "emp3.mp3",
  ];

  List<String> _iceWallSound=[
    "icewall1.mp3",
    "icewall2.mp3",
  ];

  List<String> _ghostWalkSound=[
    "ghost_walk1.mp3",
    "ghost_walk2.mp3",
    "ghost_walk3.mp3",
  ];

  List<String> _coldSnapSound=[
    "cold_snap1.mp3",
    "cold_snap2.mp3",
    "cold_snap3.mp3",
  ];

  List<String> _beginingSound=[
    "begin1.mp3",
    "begin2.mp3",
    "begin3.mp3",
    "begin4.mp3",
    "begin5.mp3",
  ];

  List<String> _failSound=[
    "fail1.mp3",
    "fail2.mp3",
    "fail3.mp3",
    "fail4.mp3",
    "fail5.mp3",
    "fail6.mp3",
    "fail7.mp3",
  ];

}