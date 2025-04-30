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
      uid: fields[1] as String?,
      fullName: fields[2] as String?,
      schoolName: fields[3] as String?,
      subject: fields[4] as String?,
      phoneNumber: fields[5] as String?,
      currentLocation: fields[6] as String?,
      isTeacher: fields[7] as bool?,
      dob: fields[8] as String?,
      bloodGroup: fields[9] as String?,
      aadharNumber: fields[10] as String?,
      email: fields[11] as String?,
      residentialAddress: fields[12] as String?,
      profileUrl: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TeacherModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(1)
      ..write(obj.uid)
      ..writeByte(2)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.schoolName)
      ..writeByte(4)
      ..write(obj.subject)
      ..writeByte(5)
      ..write(obj.phoneNumber)
      ..writeByte(6)
      ..write(obj.currentLocation)
      ..writeByte(7)
      ..write(obj.isTeacher)
      ..writeByte(8)
      ..write(obj.dob)
      ..writeByte(9)
      ..write(obj.bloodGroup)
      ..writeByte(10)
      ..write(obj.aadharNumber)
      ..writeByte(11)
      ..write(obj.email)
      ..writeByte(12)
      ..write(obj.residentialAddress)
      ..writeByte(13)
      ..write(obj.profileUrl);
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
