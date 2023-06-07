// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      uid: fields[0] as String?,
      username: fields[1] as String,
      challangerLife: fields[2] as int,
      bestChallengerScore: fields[3] as int,
      bestTimerScore: fields[4] as int,
      bestComboScore: fields[5] as int,
      level: fields[6] as int,
      exp: fields[7] as double,
      expMultiplier: fields[8] as double,
      talentTree: (fields[9] as Map?)?.cast<String, dynamic>(),
      achievements: (fields[10] as Map?)?.cast<String, dynamic>(),
      bestBossScores: (fields[11] as Map?)?.cast<String, dynamic>(),
      lastPlayed: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.challangerLife)
      ..writeByte(3)
      ..write(obj.bestChallengerScore)
      ..writeByte(4)
      ..write(obj.bestTimerScore)
      ..writeByte(5)
      ..write(obj.bestComboScore)
      ..writeByte(6)
      ..write(obj.level)
      ..writeByte(7)
      ..write(obj.exp)
      ..writeByte(8)
      ..write(obj.expMultiplier)
      ..writeByte(9)
      ..write(obj.talentTree)
      ..writeByte(10)
      ..write(obj.achievements)
      ..writeByte(11)
      ..write(obj.bestBossScores)
      ..writeByte(12)
      ..write(obj.lastPlayed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
