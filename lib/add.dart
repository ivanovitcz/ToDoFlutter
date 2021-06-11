import 'dart:convert';

import 'package:dicodingflutter/colorPalette.dart';
import 'package:dicodingflutter/stringData.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  int indexCategory = 5;
  Map<String, dynamic> todo = {};

  void saveToDo(val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("todo", val);
  }

  Future<String> getToDo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("todo") ?? '';
  }

  @override
  Widget build(BuildContext context) {
    // getToDo().then((value) {
    //   todo = value;
    //   setState(() {});
    // });

    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          onPressed: () {
            getToDo().then((resp) {
              int lengthTodo = 0;

              if(resp != '') {
                todo = jsonDecode(resp);
                lengthTodo = todo.length;
                print(todo);
              }


              var tempTodo = { 'isFinish' : 0, 
                               'category' : indexCategory,
                               'title' : titleController.text,
                               'desc' : descController.text
                            };

              if(titleController.text == '' || descController.text == '') {
                showDialog<String>(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Center(child: Text('Title/Description tidak boleh kosong!', textAlign: TextAlign.center)),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: Center(child: Text('OK')),
                      ),
                    ],
                  ),
                );
              } else {
                todo[lengthTodo.toString()] = tempTodo;
                // print(json.encode(todo));
                saveToDo(json.encode(todo));
                showDialog<String>(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Center(child: Text('Sukses Menambahkan To Do!', textAlign: TextAlign.center)),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Center(child: Text('OK')),
                      ),
                    ],
                  ),
                );
              }
            });
          },
          label: const Text('Create'),
          icon: const Icon(Icons.add_circle),
          backgroundColor: ColorPalette.successColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 10,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Create To Do",
                      style: TextStyle(
                          fontFamily: 'Niramit',
                          color: ColorPalette.titleColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 26),
                    ),
                  ),
                  
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                "Title",
                style: TextStyle(
                    fontFamily: 'Niramit',
                    color: ColorPalette.titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: TextField(
                controller: titleController,
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                "Description",
                style: TextStyle(
                    fontFamily: 'Niramit',
                    color: ColorPalette.titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: TextField(
                maxLines: 4,
                controller: descController,
              ),
            ),

            for (int i = 0; i < StringData.categories.length; i += 2)
            Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: buildCategoryRow(context, i)),
          ],
        ),
      ),       
    );
  }

  Row buildCategoryRow(BuildContext context, int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildCategoryContainer(context, i),
        buildCategoryContainer(context, i + 1),
      ],
    );
  }

  GestureDetector buildCategoryContainer(BuildContext context, int i) {
    return GestureDetector(
      onTap: () {
        indexCategory = i;
        setState(() {
          
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: 15),
        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
        height: MediaQuery.of(context).size.height / 15,
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: (indexCategory == i) ? StringData.categories[i][1] : Colors.black12,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(StringData.categories[i][2], color: Colors.white),
            Text(
              StringData.categories[i][0],
              style: TextStyle(
                fontFamily: 'Niramit',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.left,
            )
          ],
        ),
      ),
    );
  }
}