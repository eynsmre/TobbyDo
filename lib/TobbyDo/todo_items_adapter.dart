/*import 'package:hive/hive.dart';
import '../todoList/todo_items.dart';

class ToDoItemsAdapter extends TypeAdapter<ToDoItems> {
  @override
  final int typeId = 0; // Assign a unique identifier for your adapter

  @override
  ToDoItems read(BinaryReader reader) {
    final description = reader.readString();
    //final creationTimeMillis = reader.readInt(); // Read as milliseconds since epoch
    //final isChecked = reader.readBool();

    //final creationTime = DateTime.fromMillisecondsSinceEpoch(creationTimeMillis);

    return ToDoItems(
      description: description,
    );
  }

  @override
  void write(BinaryWriter writer, ToDoItems obj) {
    writer.writeString(obj.description);
    //writer.writeInt(obj.creationTime.millisecondsSinceEpoch); // Write as milliseconds since epoch
    //writer.writeBool(obj.isChecked);
  }
}*/
