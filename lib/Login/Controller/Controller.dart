import 'package:shared_preferences/shared_preferences.dart';

abstract class Controller {
  SharedPreferences sharedPref;
  void shareDataLogin();
}
