// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_tv_show.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveTvShowAdapter extends TypeAdapter<HiveTvShow> {
  @override
  final int typeId = 1;

  @override
  HiveTvShow read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveTvShow(
      tvShowId: fields[0] as int,
      tvShowName: fields[1] as String?,
      firstAirDate: fields[2] as String?,
      status: fields[3] as int,
      updatedAt: fields[4] as DateTime,
      addedAt: fields[5] as DateTime?,
      seasons: (fields[6] as Map?)?.cast<int, HiveSeasons>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveTvShow obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.tvShowId)
      ..writeByte(1)
      ..write(obj.tvShowName)
      ..writeByte(2)
      ..write(obj.firstAirDate)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.addedAt)
      ..writeByte(6)
      ..write(obj.seasons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveTvShowAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
