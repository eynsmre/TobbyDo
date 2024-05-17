import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
part 'to_do_items.g.dart';

//hive generator
@HiveType(typeId: 0)
class ToDoItems {
  @HiveField(0)
  final String description;

  @HiveField(1)
  DateTime creationTime;

  @HiveField(2)
  bool isChecked;

  ToDoItems({required this.description})
      : creationTime = DateTime.now(),
        isChecked = false;

  void setIsChecked() {
    isChecked = !isChecked;
  }

  void setCreationTime() {
    creationTime = DateTime.now();
  }

  DateTime getCreationTime() {
    return creationTime;
  }

  bool getIsChecked() {
    return isChecked;
  }

  String getFormattedCreationDate() {
    return DateFormat('dd.MM.yyyy HH:mm').format(creationTime); //If you make MMMM it will be the name of the month
  }
}
