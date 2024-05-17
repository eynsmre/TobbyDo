// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'to_do_items.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ToDoItemsAdapter extends TypeAdapter<ToDoItems> {
  @override
  final int typeId = 0;

  @override
  ToDoItems read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ToDoItems(
      description: fields[0] as String,
    )
      ..creationTime = fields[1] as DateTime
      ..isChecked = fields[2] as bool;
  }

  @override
  void write(BinaryWriter writer, ToDoItems obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.creationTime)
      ..writeByte(2)
      ..write(obj.isChecked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ToDoItemsAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
