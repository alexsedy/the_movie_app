// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_seasons.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveSeasonsAdapter extends TypeAdapter<HiveSeasons> {
  @override
  final int typeId = 2;

  @override
  HiveSeasons read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveSeasons(
      seasonId: fields[0] as int,
      airDate: fields[1] as String?,
      status: fields[2] as int,
      updatedAt: fields[3] as DateTime,
      episodeCount: fields[4] as int?,
      episodes: (fields[5] as Map?)?.cast<int, HiveEpisodes>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveSeasons obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.seasonId)
      ..writeByte(1)
      ..write(obj.airDate)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.episodeCount)
      ..writeByte(5)
      ..write(obj.episodes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveSeasonsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
