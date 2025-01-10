// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_movies.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveMoviesAdapter extends TypeAdapter<HiveMovies> {
  @override
  final int typeId = 0;

  @override
  HiveMovies read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveMovies(
      movieId: fields[0] as int,
      movieTitle: fields[1] as String?,
      releaseDate: fields[2] as String?,
      status: fields[3] as int,
      updatedAt: fields[4] as DateTime,
      addedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveMovies obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.movieId)
      ..writeByte(1)
      ..write(obj.movieTitle)
      ..writeByte(2)
      ..write(obj.releaseDate)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveMoviesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
