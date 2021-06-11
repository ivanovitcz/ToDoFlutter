// import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:dicodingflutter/add.dart';
import 'package:dicodingflutter/allToDo.dart';
import 'package:dicodingflutter/colorPalette.dart';
import 'package:dicodingflutter/prefToDo.dart';
import 'package:dicodingflutter/stringData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  Future<String> getToDo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("todo") ?? '';
  }

  saveToDo(val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("todo", val);
  }
  
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Add()));
          },
          child: Icon(Icons.add),
          backgroundColor: ColorPalette.primaryColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 10,
            child: Text(
              "My ToDo List",
              style: TextStyle(
                  fontFamily: 'Niramit',
                  color: ColorPalette.titleColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 26),
            ),
          ),

          buildAllCategory(context),
          
          Container(
            margin: EdgeInsets.only(top: 40),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "To Do Terakhir",
                  style: TextStyle(
                      fontFamily: 'Niramit',
                      color: ColorPalette.titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AllToDo()));
                  },
                  child: Text(
                    "Lihat Semua",
                    style: TextStyle(
                        fontFamily: 'Niramit',
                        color: ColorPalette.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          ),

          StreamBuilder<String>(
            stream: PrefToDo.getToDo(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) {
                return Container(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(ColorPalette.primaryColor),
                  ),
                );
              }
              return buildListToDo(context, snapshot);
            }
          ),
          
        ],
      ),
    );
  }

  Column buildListToDo(BuildContext context, AsyncSnapshot snapshot) {
    
    if(snapshot.data != '') {
      var listToDo = json.decode(snapshot.data);
      
      var countToDo = listToDo.length;
      var cek = 0;
      for (String key in listToDo.keys) {
        if(listToDo[key]['isFinish'] == 1) {
          cek+=1;
        }
      }
      if(countToDo != cek) {
        final reverseListToDo = LinkedHashMap.fromEntries(listToDo.entries.toList().reversed);
        return Column(
          children: [
            for (String key in reverseListToDo.keys)
              if(reverseListToDo[key]['isFinish'] != 1)
                buildOneToDo(context, reverseListToDo, key)
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("To Do Sudah Selesai")
          ],
        );
      }
      
      
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Tidak Ada To Do")
        ],
      );
    }
    
  }

  Container buildOneToDo(BuildContext context, listToDo, String key) {
    return Container(
      margin: EdgeInsets.only(right: 25, left: 25, bottom: 20),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        color: ColorPalette.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 15),
                  child: Icon(
                    StringData.categories[listToDo[key]['category']][2],
                    color: StringData.categories[listToDo[key]['category']][1]
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog<String>(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Center(child: Text(listToDo[key]['title'], textAlign: TextAlign.center)),
                        content: Text(listToDo[key]['desc'], textAlign: TextAlign.center),
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
                  },
                  child: Container(
                    child: Text(
                      listToDo[key]['title'],
                      style: TextStyle(
                        fontFamily: 'Niramit',
                        color: ColorPalette.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                )
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              getToDo().then((resp) {
                var tempToDo = jsonDecode(resp);
                tempToDo[key] = { 'isFinish' : 1, 
                               'category' : tempToDo[key]['category'],
                               'title' : tempToDo[key]['title'],
                               'desc' : tempToDo[key]['desc']
                            };
                saveToDo(json.encode(tempToDo));
                showDialog<String>(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Center(child: Text('Selamat To Do Anda Selesai!', textAlign: TextAlign.center)),
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
              });
            },
            child: Icon(
              Icons.check_circle_outline,
              color: Colors.green[100],
            ),
          ),
        ],
      ),
    );
  }
  
  Column buildAllCategory(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < StringData.categories.length; i += 2) 
          Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: buildCategoryRow(context, i)),
      ]
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

  Container buildCategoryContainer(BuildContext context, int i) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      height: MediaQuery.of(context).size.height / 8,
      width: MediaQuery.of(context).size.width / 2.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        color: StringData.categories[i][1],
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
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                StringData.categories[i][0],
                style: TextStyle(
                  fontFamily: 'Niramit',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                "0/0",
                style: TextStyle(
                  fontFamily: 'Niramit',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          )
        ],
      ),
    );
  }

  


}
