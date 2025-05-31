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
      bookName: fields[2] as String,
      amount: fields[3] as String,
      contactNumber: fields[4] as String,
      images: (fields[5] as List).cast<String>(),
      addedDate: fields[6] as String,
      oldOrNewBook: fields[7] as String,
      currentLocation: fields[8] as String,
      uploading: fields[10] as bool?,
      uploaded: fields[9] as bool?,
      buyBookUsersList: (fields[11] as List?)?.cast<String>(),
      userName: fields[12] as String?,
      userContact: fields[13] as String?,
      storageImagePath: (fields[14] as List?)?.cast<String>(),
      requestCount: fields[15] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, SellBookModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.bookUid)
      ..writeByte(1)
      ..write(obj.uid)
      ..writeByte(2)
      ..write(obj.bookName)
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
      ..write(obj.uploading)
      ..writeByte(11)
      ..write(obj.buyBookUsersList)
      ..writeByte(12)
      ..write(obj.userName)
      ..writeByte(13)
      ..write(obj.userContact)
      ..writeByte(14)
      ..write(obj.storageImagePath)
      ..writeByte(15)
      ..write(obj.requestCount);
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
