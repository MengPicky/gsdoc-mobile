import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mydocinoutproject/Login/Controller/Controller.dart';
import 'package:mydocinoutproject/Login/Model/LoginModel.dart';
import 'package:mydocinoutproject/mydefined.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Controller.dart';

class LoginController extends Controller {
  LoginController() {
    this.shareDataLogin();
  }

  @override
  void shareDataLogin() async {
    sharedPref = await SharedPreferences.getInstance();
  }

  checksessionexpire(uid,token) async{
     final http.Response response = await http.get(domainname + '/api/check-session-existed/' + uid , 
                          headers: <String, String>{
                            'Content-Type':   'application/json; charset=UTF-8',
                              'Authorization': token,
                          },                                          
                        ); 

      var sessiondata = jsonDecode(response.body);
      if(sessiondata['data'].length > 0)
      {
        if(sessiondata['data'][0]['token'] == ""){
          return 0;
        }else{
          return 1;
        }
      }else
      {
        return 0;
      }
  }

  Future login(username, password) async {
    try {
         final http.Response response = await http.post(domainname + '/api/auth/login', // url to get login api
                          headers: <String, String>{
                            'Content-Type':   'application/json; charset=UTF-8',
                          },
                          body: jsonEncode(<String, String>{                        
                             'email':   username, //'gs.info@mef.gov.kh',   
                             'password' : password, // password   
                          }),                        
                        ); 

      var loginData = new LoginModels(jsonDecode(response.body));
      if (loginData.code == 1){
          sharedPref.setString('token', loginData.tokentype + " " + loginData.accesstoken);
          sharedPref.setString('email', loginData.data['email']);
          sharedPref.setString('namelogin', loginData.data['name_login']);
          sharedPref.setString('uname', loginData.data['name']);
          sharedPref.setString('photo', loginData.data['photo']);
          sharedPref.setString('password', password);
          sharedPref.setInt('id', loginData.data['id']);
          var usergroupid = 0;
          if(loginData.data['type'] == 'Internal')    
          {
            usergroupid = 0;
          } else if(loginData.data['type'] == 'External')
          {
          usergroupid = 2;
          }  else{
            usergroupid = 1;
          }    
          sharedPref.setInt('groupid',usergroupid);
          return loginData.code;
      } else {
          return 0;
      }
    } catch (err) {
      print(err);
      return 0;
    }
  }

  Future getLocalToken() async {
    sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString('token');
  }

  

  Future removeLocalToken() async {
    sharedPref = await SharedPreferences.getInstance();
    sharedPref.clear();
    sharedPref.remove("id");
    sharedPref.remove("token");
    sharedPref.remove("email");
    sharedPref.remove("uname");
    sharedPref.remove("groupid");
    sharedPref.remove("photo");
    sharedPref.remove("password");
    sharedPref.remove('namelogin');
  }

   Future getLocalemail() async {
    sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString("email");
  }

  Future getlocalid() async {
    sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getInt("id");
  }

   Future getlocalname() async {
    sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString("uname");
  }

   Future getlocalphoto() async {
    sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString("photo");
  }

   Future getlocalgroup() async {
    sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getInt("groupid");
  }
   Future getlocalpassword() async {
    sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString("password");
  }
  Future getlocalnamelogin() async {
    sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString("namelogin");
  }
}
