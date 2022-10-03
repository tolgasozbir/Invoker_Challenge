import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:dota2_invoker/constants/app_strings.dart';

class SoundService {

  static SoundService? _instance;
  static SoundService get instance {
    if (_instance != null) {
      return _instance!;
    }
    _instance = SoundService._();
    return _instance!;
  }

  SoundService._();

  final _player = AudioCache();
  Random _rnd = Random();

  void _playSound({required String fileName, double volume = 0.35}){
    _player.play(fileName, volume: volume);
  }

  void playSoundBegining(){
    _playSound(
      fileName: _beginingSound[_rnd.nextInt(_beginingSound.length)], 
      volume: 0.40
    );
  }

  void failCombinationSound(){
    _playSound(fileName: _failSound[_rnd.nextInt(_failSound.length)],);
  }

  void ggSound(){
    _playSound(fileName: _ggSound[_rnd.nextInt(_ggSound.length)],);
  }


  void trueCombinationSound(List<String> combination){
    String _orbValue="";
    for (var item in combination) {
      _orbValue+=item;
    }
    switch (_orbValue) {
      case "qqq": _playSound(fileName: _coldSnapSound[_rnd.nextInt(_coldSnapSound.length)],); break;
      case "qqw": _playSound(fileName: _ghostWalkSound[_rnd.nextInt(_ghostWalkSound.length)],); break;
      case "qqe": _playSound(fileName: _iceWallSound[_rnd.nextInt(_iceWallSound.length)],); break;
      case "www": _playSound(fileName: _emp[_rnd.nextInt(_emp.length)],); break;
      case "wwq": _playSound(fileName: _tornado[_rnd.nextInt(_tornado.length)],); break;
      case "wwe": _playSound(fileName: _alacrity[_rnd.nextInt(_alacrity.length)],); break;
      case "eee": _playSound(fileName: _sunStrike[_rnd.nextInt(_sunStrike.length)],); break;
      case "eeq": _playSound(fileName: _forgeSpirit[_rnd.nextInt(_forgeSpirit.length)],); break;
      case "eew": _playSound(fileName: _chaosMeteor[_rnd.nextInt(_chaosMeteor.length)],); break;
      case "qwe": _playSound(fileName: _blast[_rnd.nextInt(_blast.length)],); break;
    }
    _orbValue="";
  }

  //spells
  List<String> _coldSnapSound=[
    SoundPaths.cold_snap1,
    SoundPaths.cold_snap2,
    SoundPaths.cold_snap3,
  ];

  List<String> _ghostWalkSound=[
    SoundPaths.ghost_walk1,
    SoundPaths.ghost_walk2,
    SoundPaths.ghost_walk3,
  ];

  List<String> _iceWallSound=[
    SoundPaths.icewall1,
    SoundPaths.icewall2,
  ];

  List<String> _emp=[
    SoundPaths.emp1,
    SoundPaths.emp2,
    SoundPaths.emp3,
  ];

  List<String> _tornado=[
    SoundPaths.tornado1,
    SoundPaths.tornado2,
    SoundPaths.tornado3,
  ];

  List<String> _alacrity=[
    SoundPaths.alacrity1,
    SoundPaths.alacrity2,
  ];

  List<String> _sunStrike=[
    SoundPaths.sunstrike1,
    SoundPaths.sunstrike2,
    SoundPaths.sunstrike3,
  ];

  List<String> _forgeSpirit=[
    SoundPaths.forge_spirit1,
    SoundPaths.forge_spirit2,
  ];

  List<String> _chaosMeteor=[
    SoundPaths.meteor1,
    SoundPaths.meteor2,
  ];

  List<String> _blast=[
    SoundPaths.blast1,
    SoundPaths.blast2,
    SoundPaths.blast3,
  ];

  //loading
  List<String> _beginingSound=[
    SoundPaths.begin1,
    SoundPaths.begin2,
    SoundPaths.begin3,
    SoundPaths.begin4,
    SoundPaths.begin5,
  ];
  //fails
  List<String> _failSound=[
    SoundPaths.fail1,
    SoundPaths.fail2,
    SoundPaths.fail3,
    SoundPaths.fail4,
    SoundPaths.fail5,
    SoundPaths.fail6,
    SoundPaths.fail7,
  ];
  //gg
  List<String> _ggSound=[
    SoundPaths.gg1,
    SoundPaths.gg2,
    SoundPaths.gg3,
    SoundPaths.gg4,
  ];
}