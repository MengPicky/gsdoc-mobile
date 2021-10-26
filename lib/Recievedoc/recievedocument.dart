//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mydocinoutproject/Recievedoc/QrcodeCreator.dart';
//import 'package:mydocinoutproject/mydefined.dart';
//import 'package:http/http.dart' as http;

class Recievedoc extends StatefulWidget {
   
  @override
  _RecievedocState createState() => _RecievedocState();
}


class _RecievedocState extends State<Recievedoc> {
  var doccode = "";
  bool _isvalidate = false;
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
   getdoccode();
  }
  getdoccode()  {
        setState(() {
            doccode = "DOC00001";
          }); 
          //  final http.Response response = await http.post(domainname + '/api/auth/login', // url to get login api
          //   headers: <String, String>{
          //     'Content-Type': 'application/json; charset=UTF-8',
          //   },
          //   body: jsonEncode(<String, String>{                        
          //     'email':  'gs.info@mef.gov.kh', //nameController.text, 
          //     'password' : 'password' //passwordController.text,
          //   }),                        
          // );             
          // if (response.statusCode == 200) {        
          //       //var objdoc = jsonDecode(response.body);  
          //       setState(() {
          //         doccode = "DOC00001";
          //       });                           
          // }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
            padding: EdgeInsets.all(10),
            child:ListView(
              children: <Widget> [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  child: Image.asset("assets/images/MEF_(Cambodia).png",width: 100,height: 100,),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text('ទទួលឯកសារ', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                ),
                Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(                                 
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,                     
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(     
                              child: Text("លេខកូដយោង",style: TextStyle(fontSize: 15)),                        
                            ) 
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(                                 
                              child: Text(doccode,style: TextStyle(fontSize: 15)), // Auto generate from api                         
                            )                          
                          ),                                          
                        ],
                    ),
                ),
                Padding(          
                      padding: const EdgeInsets.all(10),
                      child: Row(                                 
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,                     
                        children: [
                          Expanded(           
                            flex: 1,
                            child: Container(  
                              alignment: Alignment.centerLeft,   
                              child: Text("ឈ្មោះអ្នកដាក់/លេខទូរស័ព្ទ",style: TextStyle(fontSize: 15)),                        
                            ) 
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(                                 
                              child: TextFormField(  
                            controller: nameController,                                               
                            decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'ឈ្មោះ ឬ លេខទូរស័ព្ទ អ្នកដាក់',   
                            errorText: _isvalidate ? 'សូមបញ្ចូល ឈ្មោះ ឬ លេខទូរស័ព្ទ' : null,                                                                  
                          ),
                        ),                                               
                      )                          
                      ),                                          
                    ],
                ),
            ),
            Padding(
              padding: EdgeInsets.all(10),             
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Colors.blue,onPrimary: Colors.white),                                
                            child: Text("យល់ព្រម"),
                            onPressed: ()   {     
                                if(nameController.text == "")
                                {
                                  setState(() {
                                    _isvalidate=true;
                                  });
                                } else{
                                  setState(() {
                                    _isvalidate=false;
                                     Navigator.push( context,MaterialPageRoute(builder: (context) => new QrCreate(doccode,nameController.text)));
                                  });
                                }                         
                      }
                 ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}