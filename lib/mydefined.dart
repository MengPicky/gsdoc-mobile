library my_prj.globals;

import 'package:flutter/material.dart';
import 'package:mydocinoutproject/Login/Controller/LoginController.dart';


String domainname = "http://gs.obpathom.com";
//String domainname = "https://itd-doc.mef.gov.kh";
  // get username and password for login api get update data for update profile
  var loginname;
  var loginpass;
  //session
  LoginController _controller = new LoginController();
  var username;
  var uemail;
  var uphoto;
  var groupid;
  String tokenkey ="";
// Object of user after login
var userlog;
var usergroupid; // Management = 0 , Operator =1 , Guest =2 
var userid ;

 Widget mydivider()
  {
    return Divider(
        color: Colors.grey,
        height: 1,
      );
  }

   getsessionvalue() async {
     userid = await _controller.getlocalid();
     username = await _controller.getlocalname();
     uemail = await _controller.getLocalemail();
     uphoto = await _controller.getlocalphoto();
     groupid = await _controller.getlocalgroup();
     tokenkey = await _controller.getLocalToken();
     loginpass = await _controller.getlocalpassword();
     loginname = await _controller.getlocalnamelogin();
  }
  
  getlogout() async{
    await _controller.removeLocalToken();
  }

  

     