//import 'package:code1/demos/todoList/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'colors.dart';
import 'to_do_app.dart';
import 'to_do_items.dart';

//Text fieldlere türkçe harf girilemiyor (bu yalnızca bilgisayarda açılan emülatörde, telefonlarda giriliyor)
//Ayrı başlıklar için ayrı sayfalar oluşturabilme
//Edit özelliği

class Done extends StatefulWidget {
  const Done({super.key});

  @override
  State<Done> createState() => _DoneState();
}

class _DoneState extends State<Done> {
  List<ToDoItems> donesFound = [];

  @override
  void initState() {
    donesFound = dones;
    super.initState();
  }

  void runFilter(String enteredKeyword) {
    List<ToDoItems> results = [];
    if (enteredKeyword.isEmpty) {
      results = dones;
    } else {
      results = dones.where((element) => element.description.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
      //TODO BİLGİ
    }

    setState(() {
      donesFound = results;
    });
  }

  void navigateToUncompletedPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const ToDoApp(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void updateDataBase() {
    saveBox.put("todos", todos.cast<dynamic>());
    saveBox.put("dones", dones.cast<dynamic>());
    //print("Added todos: ${saveBox.get("todos")}");
  }

  void moveToNone(ToDoItems backToUncompletedItem) {
    setState(() {
      backToUncompletedItem.setCreationTime();
      todos.add(backToUncompletedItem);
      dones.removeWhere((element) => element == backToUncompletedItem);
    });
    updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        elevation: 0,
        forceMaterialTransparency: true,
        title: Padding(
          padding: PaddingUtility.smallH,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PageChangeButton(
                onPressedFunction: navigateToUncompletedPage,
                icon: const Icon(Icons.wysiwyg),
                color: ColorsUtility.red,
                shadowColor: ColorsUtility.blue,
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
        centerTitle: true,
      ),
      body: Container(
        padding: PaddingUtility.normalHV,
        child: Column(
          children: [
            SearchBox(
              boxColor: ColorsUtility.blue,
              cursorColor: ColorsUtility.red,
              onChangeFunction: (value) => runFilter(value),
            ),
            const ToDoTitle(
              text1: "What h",
              color1: ColorsUtility.blue,
              text2: "ave you",
              color2: ColorsUtility.blue,
              text3: " done",
              color3: ColorsUtility.blue,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: donesFound.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: ColorsUtility.white,
                    shadowColor: ColorsUtility.blue,
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      contentPadding: PaddingUtility.xsmallV,
                      leading: Padding(
                        padding: PaddingUtility.xsmallH,
                        child: Checkbox(
                          value: donesFound[index].getIsChecked(),
                          onChanged: (value) {
                            setState(() {
                              donesFound[index].setIsChecked();
                              //todos.removeAt(index);
                              moveToNone(donesFound[index]);
                              //todos.removeAt(index);
                              //TODO instead of removing, it will be moved to the DONE page
                            });
                            updateDataBase();
                          },
                          activeColor: ColorsUtility.blue,
                          checkColor: ColorsUtility.white,
                          side: const BorderSide(color: ColorsUtility.blue),
                        ),
                      ),
                      title: Padding(
                        padding: PaddingUtility.xsmallV,
                        child: Text(donesFound[index].description, style: const TextStyle(color: ColorsUtility.blue)),
                      ),
                      subtitle: Text(donesFound[index].getFormattedCreationDate(), style: const TextStyle(color: ColorsUtility.red)),
                      trailing: Padding(
                        padding: PaddingUtility.xsmallH,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              donesFound.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.delete_outlined),
                          color: ColorsUtility.blue,
                        ),
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
}
