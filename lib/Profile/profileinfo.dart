
import 'dart:convert';
import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mydocinoutproject/Dashboard/dashboard.dart';
import 'package:mydocinoutproject/Login/Controller/LoginController.dart';
import 'package:mydocinoutproject/mydefined.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}


class _ProfileState extends State<Profile> {
  LoginController _controller = new LoginController();
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  File _image;
  final picker = ImagePicker();
  bool isloading = false;
 
   Future login() async {
    try {
       getsessionvalue();
       getlogout();
      final int status = await _controller.login(uemail, loginpass);
      getsessionvalue();
      if (status == 1){      
         // getsessionvalue();
          Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => new Dashboard()),
          ModalRoute.withName('/Dashboard'));
      }
    
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
      
    } catch (err) {
      print(err);
    }
  }

  updateprofile(username,usersys,email) async {
    // reference : https://flutteragency.com/how-to-upload-images-in-flutter/
     final request = http.MultipartRequest('POST', Uri.parse(domainname + '/api/update-user-profile'));
      request.headers['Authorization'] = '$tokenkey';
      request.fields['id'] = userid.toString();
      request.fields['name'] = username;
      request.fields['name_login'] = usersys;
      request.fields['email'] = email;
    if (_image != null) {
      //  String hasImage = _image.path.toString().split('.').last;

        request.fields['photo'] = domainname + '/storage/' ;
        request.fields['status'] = '1';
        request.files.add(await http.MultipartFile.fromPath(
          'photo',
          _image.path.toString(),
        ));
      }
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = json.decode( String.fromCharCodes(responseData));
      setState(() {
        isloading =false;
      });
      if (responseString['code'] == 1)
      {
        showAlertDialog(context); 
      }
  }
  showAlertDialog(BuildContext context) {  
  // Create button  
  Widget okButton = TextButton(  
    child: Text("OK"),  
    onPressed: ()async {  
          //getlogout();
          // login again to refresh data
          
          await http.post(
                          domainname + '/api/auth/logout', // url to get login api
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                       );          
          this.login();
          //Navigator.pushReplacement( context,MaterialPageRoute(builder: (context) => new Dashboard()));
    },  
  );
    AlertDialog alert = AlertDialog(  
    title: Text("ពត៌មានអ្នកប្រើប្រាស់"),  
    content: Text("ការកែប្រែបានជោគជ័យ ។ សូមរង់ចាំការធ្វើបច្ចុប្បន្នភាព ។"),  
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
void _showPicker(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
}
_imgFromCamera() async {
  PickedFile image = await picker.getImage(
    source: ImageSource.camera, imageQuality: 50
  );

  setState(() {
    _image = File(image.path);
  });
}

_imgFromGallery() async {
  PickedFile image = await picker.getImage(
      source: ImageSource.gallery, imageQuality: 50
  );

  setState(() {
     _image = File(image.path);
  });
}

@override
void initState() {
  _usernameController.text = username;
  _userController.text = loginname;
  _emailController.text = uemail;
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isloading ? Scaffold(body:  Center(child: CircularProgressIndicator()),) : new Form(
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
                  child: Text('កែប្រែពត៌មានអ្នកប្រើប្រាស់', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(5,5,5,0),
                  child: GestureDetector(
                  onTap: () {
                     _showPicker(context);
                  },
                  child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.transparent,
                  child: _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        _image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.fitHeight,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(                    
                        fit: BoxFit.cover,
                        image: uphoto != null ? NetworkImage(domainname + '/storage/' + uphoto) : new AssetImage('assets/images/default_avatar.jpg'),                    
                        ),
                      ),
                      width: 100,
                      height: 100,                    
                      ),
                    ),
                  ),
                ),  
               Container(
                // padding: EdgeInsets.fromLTRB(80, 0, 0, 5),
                 transform: Matrix4.translationValues(50.0, -20.0, 0.0),
                 child:IconButton(icon:  Icon(Icons.camera_alt), onPressed:(){ _showPicker(context);}),
               ),   
               Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Row(
                    children: [
                      Text('ឈ្មោះអ្នកប្រើប្រាស់',style: TextStyle(fontSize: 17),),
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
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.black),
                                filled: true,
                                fillColor: Colors.white,
                               // hintText: 'ឈ្មោះអ្នកប្រើប្រាស់',                              
                           ),  
                            controller: this._usernameController,
                            // obscureText: true,
                            // ignore: missing_return
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'សូមបញ្ចូលឈ្មោះអ្នកប្រើប្រាស់';
                              }
                            },
                        ),             
              ),
               Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Row(
                    children: [
                      Text('ឈ្មោះចូលប្រព័ន្ធ',style: TextStyle(fontSize: 17),),
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
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.black),
                                filled: true,
                                fillColor: Colors.white,
                              //  hintText: 'ឈ្មោះចូលប្រព័ន្ធ',                              
                           ),  
                            controller: this._userController,
                            // obscureText: true,
                            // ignore: missing_return
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'សូមបញ្ចូលឈ្មោះចូលប្រព័ន្ធ';
                              }
                            },
                        ),             
              ),
               Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Row(
                    children: [
                      Text('សារអេឡិចត្រូនិច',style: TextStyle(fontSize: 17),),
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
                                  Icons.email,
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.black),
                                filled: true,
                                fillColor: Colors.white,
                              //  hintText: 'សារអេឡិចត្រូនិច',                              
                           ),  
                            controller: this._emailController,
                            // obscureText: true,
                            // ignore: missing_return
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'សូមបញ្ចូលសារអេឡិចត្រូនិច';
                              }else if(EmailValidator.validate(value) == false)
                              {
                                return 'សូមបញ្ចូលទម្រង់សារអេឡិចត្រូនិចអោយបានត្រឹមត្រូវ';
                              }
                            },
                        ),             
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
                                      final String usernameText =
                                          this._usernameController.text;
                                      final String usertext =
                                          this._userController.text;
                                      final String emailtext = this._emailController.text;
                                      this.updateprofile(usernameText, usertext,emailtext);
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
 
}