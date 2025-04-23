// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TeacherModelAdapter extends TypeAdapter<TeacherModel> {
  @override
  final int typeId = 0;

  @override
  TeacherModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TeacherModel(
      uid: fields[1] as String,
      name: fields[2] as String,
      schoolName: fields[3] as String,
      subject: fields[4] as String,
      phoneNumber: fields[5] as String,
      currentLocation: fields[6] as String,
      isTeacher: fields[7] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, TeacherModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.uid)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.schoolName)
      ..writeByte(4)
      ..write(obj.subject)
      ..writeByte(5)
      ..write(obj.phoneNumber)
      ..writeByte(6)
      ..write(obj.currentLocation)
      ..writeByte(7)
      ..write(obj.isTeacher);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeacherModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
