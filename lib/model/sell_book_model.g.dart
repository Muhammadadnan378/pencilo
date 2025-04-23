// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sell_book_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SellBookModelAdapter extends TypeAdapter<SellBookModel> {
  @override
  final int typeId = 2;

  @override
  SellBookModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SellBookModel(
      bookUid: fields[0] as String,
      uid: fields[1] as String,
      title: fields[2] as String,
      amount: fields[3] as String,
      contactNumber: fields[4] as String,
      images: (fields[5] as List).cast<String>(),
      addedDate: fields[6] as String,
      oldOrNewBook: fields[7] as String,
      currentLocation: fields[8] as String,
      uploading: fields[10] as bool?,
      uploaded: fields[9] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, SellBookModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.bookUid)
      ..writeByte(1)
      ..write(obj.uid)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.contactNumber)
      ..writeByte(5)
      ..write(obj.images)
      ..writeByte(6)
      ..write(obj.addedDate)
      ..writeByte(7)
      ..write(obj.oldOrNewBook)
      ..writeByte(8)
      ..write(obj.currentLocation)
      ..writeByte(9)
      ..write(obj.uploaded)
      ..writeByte(10)
      ..write(obj.uploading);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SellBookModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
