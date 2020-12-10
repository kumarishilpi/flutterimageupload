
import 'package:shared_preferences/shared_preferences.dart';

Future<void> session(String username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var username = prefs.getString('username');
  print(username);
}




