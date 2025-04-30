// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentModelAdapter extends TypeAdapter<StudentModel> {
  @override
  final int typeId = 1;

  @override
  StudentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentModel(
      uid: fields[0] as String?,
      fullName: fields[1] as String?,
      rollNumber: fields[3] as String?,
      admissionNumber: fields[4] as String?,
      dob: fields[5] as String?,
      bloodGroup: fields[6] as String?,
      aadharNumber: fields[7] as String?,
      email: fields[8] as String?,
      phoneNumber: fields[9] as String?,
      residentialAddress: fields[10] as String?,
      parentName: fields[11] as String?,
      parentPhone: fields[12] as String?,
      schoolName: fields[13] as String?,
      standard: fields[14] as String?,
      division: fields[15] as String?,
      currentLocation: fields[16] as String?,
      isStudent: fields[17] as bool?,
      profileUrl: fields[18] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudentModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.rollNumber)
      ..writeByte(4)
      ..write(obj.admissionNumber)
      ..writeByte(5)
      ..write(obj.dob)
      ..writeByte(6)
      ..write(obj.bloodGroup)
      ..writeByte(7)
      ..write(obj.aadharNumber)
      ..writeByte(8)
      ..write(obj.email)
      ..writeByte(9)
      ..write(obj.phoneNumber)
      ..writeByte(10)
      ..write(obj.residentialAddress)
      ..writeByte(11)
      ..write(obj.parentName)
      ..writeByte(12)
      ..write(obj.parentPhone)
      ..writeByte(13)
      ..write(obj.schoolName)
      ..writeByte(14)
      ..write(obj.standard)
      ..writeByte(15)
      ..write(obj.division)
      ..writeByte(16)
      ..write(obj.currentLocation)
      ..writeByte(17)
      ..write(obj.isStudent)
      ..writeByte(18)
      ..write(obj.profileUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
