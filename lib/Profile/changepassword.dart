import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mydocinoutproject/Login/Loginpage.dart';
import 'package:mydocinoutproject/mydefined.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final _oldpasswordController = TextEditingController();
  final _newpasswordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isvalidate = false;
  bool isloading = false;
  String errormsg = '';

  @override
  Widget build(BuildContext context) {
  
    return isloading ? Scaffold(body: Center(child: CircularProgressIndicator(),) ,) : new Form(
      key: _formKey,
      child: 
      Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text('ផ្លាស់ប្តូរពាក្យសម្ងាត់', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                ),  
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Row(
                    children: [
                      Text('ពាក្យសម្ងាត់ចាស់',style: TextStyle(fontSize: 17),),
                      Text('*',style: TextStyle(fontSize: 17,color: Colors.red),),
                    ],
                  ),
                ),
              ),          
              Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: TextFormField(  
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(),
                              hintStyle: TextStyle(color: Colors.black),
                              filled: true,
                              fillColor: Colors.white,
                              //hintText: 'ពាក្យសម្ងាត់ចាស់',                              
                          ),  
                          controller: this._oldpasswordController,
                            obscureText: true,
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                _isvalidate = false;
                              });
                              return 'សូមបញ្ចូលពាក្យសម្ងាត់ចាស់';
                            }
                          },
                      ),             
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Row(
                    children: [
                      Text('ពាក្យសម្ងាត់ថ្មី',style: TextStyle(fontSize: 17),),
                      Text('*',style: TextStyle(fontSize: 17,color: Colors.red),),
                    ],
                  ),
                ),
              ),
              Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: TextFormField(  
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(),
                              hintStyle: TextStyle(color: Colors.black),
                              filled: true,                               
                              fillColor: Colors.white,
                            //  hintText: 'ពាក្យសម្ងាត់ថ្មី',                              
                          ),  
                          controller: this._newpasswordController,
                            obscureText: true,
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                               setState(() {
                                _isvalidate = false;
                              });
                              return 'សូមបញ្ចូលពាក្យសម្ងាត់ថ្មី';
                            }else if(validateStructure(value) == false)
                            {
                              setState(() {
                                _isvalidate = false;
                              });
                                 return 'ពាក្យសម្ងាត់ អក្សរតូច អក្សរធំ លេខ និង សញ្ញា តិចបំផុតចំនួន ៨ ខ្ទង់';
                            }
                          },
                      ),             
              ),
                Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Row(
                    children: [
                      Text('បញ្ជាក់ពាក្យសម្ងាត់',style: TextStyle(fontSize: 17),),
                      Text('*',style: TextStyle(fontSize: 17,color: Colors.red),),
                    ],
                  ),
                ),
              ),
              Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: TextFormField(  
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(),
                              hintStyle: TextStyle(color: Colors.black),
                              filled: true,
                              fillColor: Colors.white,
                            //  hintText: 'បញ្ជាក់ពាក្យសម្ងាត់',     
                            // errorText: _isvalidate ? errormsg : ''
                          ),  
                          controller: this._confirmController,
                            obscureText: true,
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                               setState(() {
                                _isvalidate = false;
                              });
                              return 'សូមបញ្ចូលបញ្ជាក់ពាក្យសម្ងាត់';
                            }
                          },
                      ),             
              ),
              Container(
                child: _isvalidate ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(errormsg),
                )  : null,
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                children: [   
                  Expanded(
                    child:   
                    Container(
                      alignment: Alignment.centerLeft,                             
                      child :  TextButton(                     
                      child: Text(
                        'ចាកចេញ',
                        style: TextStyle(fontSize: 17,decoration: TextDecoration.underline,color:Colors.blue),
                      ),
                      onPressed: () { 
                            Navigator.pop(context);
                      },
                    ),
                  ),
                  ),                                
                  Expanded(                     
                      child:  usergroupid != "2" ?                  
                          Container(
                            alignment: Alignment.centerRight,
                            child : ElevatedButton(
                                    style: ElevatedButton.styleFrom(primary: Colors.blue,onPrimary: Colors.white),                                  
                                    child: Text("យល់ព្រម"),
                                    onPressed: () async {  
                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          isloading = true;
                                        });                                                                             
                                      final String oldpasswordtext =
                                          this._oldpasswordController.text;
                                      final String newpasswordtext =
                                          this._newpasswordController.text;
                                      final String confirmpassword = this._confirmController.text;                                     
                                      this.changepassword(oldpasswordtext, newpasswordtext,confirmpassword);
                                      }
                                    }),                                                                                   
                      ): Container(),  
                    )
                ],                        
              ),
              ),
          ],
        ),
      ),
    )

    );
  }

   bool validateStructure(String value){
        String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
        RegExp regExp = new RegExp(pattern);
        return regExp.hasMatch(value);
  }

  

  changepassword(oldpassword,newpasswrod,confirmpassword) async {
    final http.Response response = await http.post( domainname + '/api/change-password' , 
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': tokenkey,
      },
      body: jsonEncode(<String, String>{                        
      'old_password':   oldpassword,   
      'new_password' : newpasswrod,  
      'confirm_password' : confirmpassword,  
    }),  
  );
  var item = json.decode(response.body); 
  setState(() {
     isloading = false;
  });
  if(item['status'] == 400)
  {
    setState(() {    
      _isvalidate = true;
      errormsg = item['message'].toString();
    });   
  }  else
  {
     showAlertDialog(context);   
  }  
     
  }


  showAlertDialog(BuildContext context) {  
  // Create button  
  Widget okButton = TextButton(  
    child: Text("OK"),  
    onPressed: ()async {  
          await http.post(
                          domainname + '/api/auth/logout', // url to get login api
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                       );
                      getlogout();
                      Navigator.pushReplacement( context,MaterialPageRoute(builder: (context) => new Loginpage()));
    },  
  );
    AlertDialog alert = AlertDialog(  
    title: Text("ពត៌មានអ្នកប្រើប្រាស់"),  
    content: Text("ការកែប្រែបានជោគជ័យ ។ កម្មវិធីត្រូវអោយអ្នក Log Out និង Log In ម្តងទៀត។ អរគុណ"),  
    actions: [  
      okButton,  
    ],  
  );  
 
  // show the dialog  
  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  ); 
 }
}