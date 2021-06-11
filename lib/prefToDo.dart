import 'package:shared_preferences/shared_preferences.dart';

class PrefToDo {
  static final String prefTodo = '';

  static Stream<String> getToDo() => 
    Stream.periodic(Duration(seconds: 1)).asyncMap((_) => getToDos());

  static Future<String> getToDos() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("todo") ?? '';
  }
}