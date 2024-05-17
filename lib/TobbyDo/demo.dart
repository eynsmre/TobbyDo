import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: EditableList(),
    );
  }
}

class EditableList extends StatefulWidget {
  const EditableList({super.key});

  @override
  _EditableListState createState() => _EditableListState();
}

class _EditableListState extends State<EditableList> {
  List<String> items = ['Item 1', 'Item 2', 'Item 3'];
  int editingIndex = -1;

  void toggleEditMode(int index) {
    setState(() {
      editingIndex = editingIndex == index ? -1 : index;
    });
  }

  void saveChanges(int index, String newContent) {
    setState(() {
      items[index] = newContent;
      editingIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editable List')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          if (index == editingIndex) {
            return EditableListItem(
              content: items[index],
              onSave: (newContent) => saveChanges(index, newContent),
            );
          } else {
            return ListTile(
              title: Text(items[index]),
              onTap: () => toggleEditMode(index),
            );
          }
        },
      ),
    );
  }
}

class EditableListItem extends StatefulWidget {
  final String content;
  final Function(String) onSave;

  const EditableListItem({super.key, required this.content, required this.onSave});

  @override
  _EditableListItemState createState() => _EditableListItemState();
}

class _EditableListItemState extends State<EditableListItem> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.content);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextFormField(
        controller: _controller,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.check),
        onPressed: () {
          widget.onSave(_controller.text);
        },
      ),
    );
  }
}
