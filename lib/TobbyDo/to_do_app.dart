import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'colors.dart';
import 'completed_page.dart';
import 'services/login_controller.dart';
import 'to_do_items.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'to_do_database.dart';

class ToDoApp extends StatefulWidget {
  const ToDoApp({super.key});

  @override
  State<ToDoApp> createState() => _ToDoAppState();
}

//ToDoDatabase dataBase = ToDoDatabase();
List<ToDoItems> todos = [];
List<ToDoItems> dones = [];
final saveBox = Hive.box("save_box");
final loginController = Get.put(LoginController());

class _ToDoAppState extends State<ToDoApp> {
  final TextEditingController _textEditingController = TextEditingController();
  bool isChecked = false;
  List<ToDoItems> foundToDos = [];

  void createInitialData() {
    todos = [
      ToDoItems(description: "This is"),
      ToDoItems(description: "TO DO"),
      ToDoItems(description: "page"),
    ];

    dones = [
      ToDoItems(description: "Here is"),
      ToDoItems(description: "DONE"),
      ToDoItems(description: "page"),
    ];

    for (int i = 0; i < dones.length; i++) {
      dones[i].isChecked = true;
    }
  }

  @override
  void dispose() {
    updateDataBase(); // Save data to Hive when the app is closed
    super.dispose();
  }

  void loadData() {
    todos = (saveBox.get("todos") as List<dynamic>).cast<ToDoItems>();
    dones = (saveBox.get("dones") as List<dynamic>).cast<ToDoItems>();
  }

  void updateDataBase() {
    saveBox.put("todos", todos.cast<dynamic>());
    saveBox.put("dones", dones.cast<dynamic>());
    //print("Added todos: ${saveBox.get("todos")}");
  }

  @override
  void initState() {
    if (saveBox.get("todos") == null && saveBox.get("dones") == null) {
      createInitialData();
    } else {
      loadData();
    }

    foundToDos = todos;
    super.initState();
  }

  void runFilter(String enteredKeyword) {
    List<ToDoItems> results = [];
    if (enteredKeyword.isEmpty) {
      results = todos;
    } else {
      results = todos.where((element) => element.description.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
      //TODO BİLGİ
    }

    setState(() {
      foundToDos = results;
    });
  }

  void addItemToDo(String text) {
    ToDoItems newToDo = ToDoItems(description: text);
    setState(() {
      todos.add(newToDo);
    });
    updateDataBase();
  }

  void moveToDone(ToDoItems completedItem) {
    setState(() {
      completedItem.setCreationTime();
      dones.add(completedItem);
      todos.removeWhere((element) => element == completedItem);
    });
    updateDataBase();
  }

  void navigateToDonePage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const Done(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
    updateDataBase();
    loadData();
    setState(() {});
  }

  void editingFunc() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //primary: false,
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        elevation: 0,
        forceMaterialTransparency: true,
        title: Padding(
          padding: PaddingUtility.smallHV,
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PageChangeButton(
                onPressedFunction: navigateToDonePage,
                icon: const Icon(Icons.done_all_rounded),
                color: ColorsUtility.blue,
                shadowColor: ColorsUtility.red,
              ),
              Obx(() {
                if (loginController.googleAccount.value == null) {
                  return IfLoggedIn(loginController: loginController);
                } else {
                  return IfNotLoggedIn(loginController: loginController);
                }
              })
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addButtonShowDialog(context);
        },
        backgroundColor: ColorsUtility.red,
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: PaddingUtility.normalHV,
        child: Column(
          children: [
            SearchBox(boxColor: ColorsUtility.red, cursorColor: ColorsUtility.blue, onChangeFunction: (value) => runFilter(value)),
            const ToDoTitle(text1: "What y", color1: ColorsUtility.red, text2: "ou need", text3: " to do"),
            if (todos.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: foundToDos.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 1,
                      shadowColor: ColorsUtility.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        contentPadding: PaddingUtility.xsmallV,
                        onTap: null,
                        leading: Padding(
                          padding: PaddingUtility.xsmallH,
                          child: Checkbox(
                            value: foundToDos[index].getIsChecked(),
                            onChanged: (value) {
                              setState(() {
                                foundToDos[index].setIsChecked();
                                //todos.removeAt(index);
                                moveToDone(foundToDos[index]);
                                //todos.removeAt(index);
                                //TODO instead of removing, it will be moved to the DONE page
                              });
                              updateDataBase();
                            },
                            activeColor: ColorsUtility.red,
                            checkColor: ColorsUtility.white,
                            side: const BorderSide(color: ColorsUtility.red),
                          ),
                        ),
                        title: Padding(
                          padding: PaddingUtility.xsmallV,
                          child: Text(foundToDos[index].description, style: TextStyle(color: ColorsUtility.red[800])),
                        ),
                        subtitle: Padding(
                          padding: PaddingUtility.xsmallbottomOnly,
                          child: Text(foundToDos[index].getFormattedCreationDate(), style: const TextStyle(color: ColorsUtility.blue)),
                        ),
                        trailing: Padding(
                          padding: PaddingUtility.xsmallH,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  foundToDos.removeAt(index); //TODO
                                });
                                updateDataBase();
                              },
                              icon: const Icon(Icons.delete_outlined),
                              color: ColorsUtility.red),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> addButtonShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        var addMessage = 'Add';
        var cancelMessage = 'Cancel';
        var addToDoMessage = "Add To Do";
        return AlertDialog(
          //elevation: 0,
          //icon: Icon(Icons.add),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: ColorsUtility.red,
          title: Text(
            addToDoMessage,
            style: const TextStyle(color: ColorsUtility.white),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width, //To make it width size of the screen
            child: TextField(
              controller: _textEditingController,
              cursorColor: ColorsUtility.white,
              style: const TextStyle(color: ColorsUtility.white),
              decoration: const InputDecoration(
                /*hintText: "Enter To Do",
                  hintStyle: TextStyle(color: ColorsUtility.white),*/
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorsUtility.white)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorsUtility.white),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    todos.add(ToDoItems(description: _textEditingController.text));
                  });
                  //addItemToDo(_textEditingController.text);
                  //TODO
                  updateDataBase();
                  _textEditingController.clear();
                  Navigator.of(context).pop();
                },
                child: Text(addMessage, style: const TextStyle(color: ColorsUtility.white))),
            TextButton(
              //TODO Add the ToDo item to the list
              onPressed: () {
                _textEditingController.clear();
                Navigator.of(context).pop();
              },
              child: Text(cancelMessage, style: const TextStyle(color: ColorsUtility.white)),
            ),
          ],
        );
      },
    );
  }
}

class IfNotLoggedIn extends StatelessWidget {
  const IfNotLoggedIn({
    super.key,
    required this.loginController,
  });

  final LoginController loginController;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: IconButton(
        onPressed: () {
          loginController.logout();
        },
        icon: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(loginController.googleAccount.value?.photoUrl ?? "", fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class IfLoggedIn extends StatelessWidget {
  const IfLoggedIn({
    super.key,
    required this.loginController,
  });

  final LoginController loginController;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      shadowColor: ColorsUtility.red,
      elevation: 3,
      child: IconButton(
        onPressed: () {
          loginController.login();
        },
        icon: Image.asset("assets/googleLogo.png"),
      ),
    );
  }
}

/*
class MyCheckBox extends StatefulWidget {
  const MyCheckBox({
    super.key,
  });

  @override
  State<MyCheckBox> createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isChecked,
      onChanged: (value) {
        setState(() {
          isChecked = value!;
          
        });
      },
      activeColor: ColorsUtility.red,
      checkColor: ColorsUtility.white,
      side: const BorderSide(color: ColorsUtility.red),
    );
  }
}
*/
class ToDoTitle extends StatelessWidget {
  final String text1;
  final Color color1;
  final String? text2;
  final Color? color2;
  final String? text3;
  final Color? color3;

  const ToDoTitle({
    required this.text1,
    required this.color1,
    this.text2,
    this.color2 = ColorsUtility.red,
    this.text3,
    this.color3 = ColorsUtility.red,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: PaddingUtility.titlePadding,
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            children: [
              TextSpan(
                  text: text1,
                  style: TextStyle(
                    color: color1,
                  )),
              TextSpan(
                text: text2,
                style: TextStyle(color: color2),
              ),
              TextSpan(
                text: text3,
                style: TextStyle(
                  color: color3,
                ),
              ),
            ],
          ),
        ));
  }
}

class SearchBox extends StatelessWidget {
  final Color boxColor; // New color parameter
  final Color cursorColor;
  final Function onChangeFunction;

  const SearchBox({
    required this.boxColor,
    required this.cursorColor,
    required this.onChangeFunction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: PaddingUtility.smallH,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: boxColor,
        ),
        child: TextField(
          cursorColor: cursorColor,
          onChanged: (value) => onChangeFunction(value),
          style: const TextStyle(color: ColorsUtility.white),
          decoration: const InputDecoration(
            hintText: "Search",
            hintStyle: TextStyle(color: ColorsUtility.white),
            icon: Icon(Icons.search),
            iconColor: Colors.white,
            border: InputBorder.none,
          ),
        ));
  }
}

class PageChangeButton extends StatelessWidget {
  final VoidCallback onPressedFunction;
  final Icon icon;
  final Color color;
  final Color shadowColor;
  const PageChangeButton({
    required this.onPressedFunction,
    required this.icon,
    required this.color,
    required this.shadowColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      elevation: 3,
      shadowColor: shadowColor,
      child: IconButton(
        onPressed: onPressedFunction,
        icon: icon,
        color: color,
        //hoverColor: ColorsUtility.red,
      ),
    );
  }
}
