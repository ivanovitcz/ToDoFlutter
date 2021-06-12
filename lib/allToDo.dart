import 'dart:collection';
import 'dart:convert';

import 'package:dicodingflutter/colorPalette.dart';
import 'package:dicodingflutter/prefToDo.dart';
import 'package:dicodingflutter/stringData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllToDo extends StatefulWidget {
  @override
  _AllToDoState createState() => _AllToDoState();
}

class _AllToDoState extends State<AllToDo> {

  bool isFinish = false;

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
      body: ListView(
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
                    "List All To Do",
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
            margin: EdgeInsets.only(bottom: 20),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector (
                  onTap: () {
                    if(isFinish == true) {
                      isFinish = false;
                      setState(() {
                        
                      });
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: (!isFinish) ? ColorPalette.dangerColor : Colors.black12,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Unfinished",
                        style: TextStyle(
                            fontFamily: 'Niramit',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),

                GestureDetector (
                  onTap: () {
                    if(isFinish == false) {
                      isFinish = true;
                      setState(() {
                        
                      });
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: (isFinish) ? ColorPalette.successColor : Colors.black12,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Finished",
                        style: TextStyle(
                            fontFamily: 'Niramit',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
                
              ],
            ),
          ),

          StreamBuilder<String>(
            stream: PrefToDo.getToDo(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) {
                return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(ColorPalette.primaryColor),
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
      var finished = 0;
      var unfinished = 0;

      for (String key in listToDo.keys) {
        if(listToDo[key]['isFinish'] == 1) {
          finished+=1;
        } else {
          unfinished+=1;
        }
      }

      final reverseListToDo = LinkedHashMap.fromEntries(listToDo.entries.toList().reversed);
      
      if(countToDo == 0) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Tidak Ada To Do")
          ],
        );
      } else {
        if(isFinish) {

          if(finished == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Belum Ada To Do Selesai")
              ],
            );
          } else {
            return Column(
              children: [
                for (String key in reverseListToDo.keys)
                  if(reverseListToDo[key]['isFinish'] != 0)
                    buildOneToDo(context, reverseListToDo, key)
              ],
            );
          }
        } else {
          if(unfinished == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("To Do Sudah Selesai")
              ],
            );
          } else {
            return Column(
              children: [
                for (String key in reverseListToDo.keys)
                  if(reverseListToDo[key]['isFinish'] != 1)
                    buildOneToDo(context, reverseListToDo, key)
              ],
            );
          }
        }
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

          (listToDo[key]['isFinish'] == 0) ?
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
            ) : Container(
              
            ),
        ],
      ),
    );
  }
  


}
