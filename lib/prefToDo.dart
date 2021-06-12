import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PrefToDo {
  static final String prefTodo = '';

  static Stream<String> getToDo() => 
    Stream.periodic(Duration(seconds: 1)).asyncMap((_) => getToDos());

  static Future<String> getToDos() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("todo") ?? '';
  }

  // static Stream<String> getCountToDo(i) => 
  //   Stream.periodic(Duration(seconds: 1)).asyncMap((_) => getCountToDos(i));

  // static Future<String> getCountToDos(int i) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   var allToDo = pref.getString("todo") ?? '';
  //   print(allToDo);
  //   if(allToDo != '') {
  //     return "0/0";
  //   } else {
  //     var finished = 0;
  //     var all = 0;
  //     var listToDo = json.decode(allToDo);
  //     for (String key in listToDo.keys) {
  //       if(listToDo[key]['category'] == i) {
  //         all += 1;
  //         if(listToDo[key]['isFinish'] == 1) {
  //           finished += 1;
  //         } 
  //       }
  //     }
  //     var output = finished.toString()+"/"+all.toString();
  //     return "AAA";
  //   }
  // }
}