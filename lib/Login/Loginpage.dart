

import 'package:flutter/material.dart';
import 'package:mydocinoutproject/Dashboard/dashboard.dart';
import 'package:mydocinoutproject/Login/Controller/LoginController.dart';
import 'package:mydocinoutproject/mydefined.dart';



class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}
class _LoginpageState extends State<Loginpage> {
  LoginController _controller = new LoginController();
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading;
  bool _isvalidate;

// session login
  _getLoginFromController() async {
    var localtoken = await _controller.getLocalToken();
    await new Future.delayed(new Duration(seconds: 0));
    if (localtoken == null) {
      this.setState(() {
        _isLoading = false;
      });
    } else {  
           var localuserid = await _controller.getlocalid();
           var mysession = await _controller.checksessionexpire(localuserid.toString(),localtoken.toString());
           if(mysession == 1)
           {
               getsessionvalue();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => new Dashboard()),
                ModalRoute.withName('/Dashboard')); 
           }else
           {
                this.setState(() {
                 _isLoading = false;
            });
           }
           
    }
  }
  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _isvalidate = true;
    _getLoginFromController();
  }
// if login == true
  Future login(String username, String password) async {
    this.setState(() {
      this._isLoading = true;
    });
    try {
      final int status = await _controller.login(username, password);
      if (status == 1){
        getsessionvalue();
         Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => new Dashboard()),
          ModalRoute.withName('/Dashboard'));
      } else {
        this.setState(() {
          this._isvalidate =false;
          this._isLoading = false;
        });

        // showDialog(context: context, builder: (BuildContext context){
        //   return AlertDialog(
        //     title: new Text("Log in"),
        //     content: new Text("គណនីយមិនត្រឹមត្រូវ"),
        //     actions: <Widget>[
        //        new FlatButton(onPressed: (){
        //           Navigator.of(context).pop();
        //         }, child: new Text("Close"))
        //     ],
        //   );
        // });
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: (_isLoading)
                  ? new Center(
                      child: new Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: new CircularProgressIndicator()),
                    )
                  : new Form(
                      key: _formKey,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                child: Image.asset("assets/images/MEF_(Cambodia).png",width: 100,height: 100,),
                              ),
                            TextFormField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.black),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'អ្នកប្រើប្រាស់'
                                ),
                            controller: this._usernameController,
                            // obscureText: true,
                            // ignore: missing_return
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'សូមបញ្ចូលអ្នកប្រើប្រាស់';
                              }
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            prefixIcon:
                                Icon(Icons.lock, color: Colors.black),
                            hintStyle: TextStyle(color: Colors.black),
                            fillColor: Colors.white,
                            errorText: _isvalidate == false ? 'គណនីយ មិនត្រឹមត្រូវ' : null,
                            hintText: 'ពាក្យសម្ងាត់'),
                            controller: this._passwordController,
                            obscureText: true,
                            
                            //ignore: missing_return
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'សូមបញ្ចូលពាក្យសម្ងាត់';
                              }
                            },
                          ),            
                          Container(
                            height: 50,
                            padding: EdgeInsets.fromLTRB(0,10,0,0),
                            child: ElevatedButton(
                               style: ElevatedButton.styleFrom(primary: Colors.blue,onPrimary: Colors.white),
                              child: Text('ចូលប្រើប្រាស់',style: TextStyle(fontSize: 20),),
                              onPressed: () async {  
                                if (_formKey.currentState.validate()) {
                                  final String usernameText =
                                      this._usernameController.text;
                                  final String passwordText =
                                      this._passwordController.text;                                
                                  this.login(usernameText, passwordText);
                            
                                }
                              },                      
                            ),
                          ),                                     
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}