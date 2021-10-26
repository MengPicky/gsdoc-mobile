import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mydocinoutproject/Dashboard/dashboard.dart';
import 'package:mydocinoutproject/mydefined.dart';

class Viewdoc extends StatefulWidget {
    final doctype ;
    final docfile;
  @override
  _ViewdocState createState() => _ViewdocState();
  Viewdoc(this.docfile,this.doctype);
}

class _ViewdocState extends State<Viewdoc> {
   TextEditingController qrvaltext = TextEditingController();
    bool _isvalidate = false;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  child: Image.asset("assets/images/MEF_(Cambodia).png",width: 100,height: 100,),
                ),
                Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                child: Text('វាយបញ្ចូលចំណារ', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),              
              ),
               Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                child: TextFormField(  
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 10,
                            controller: qrvaltext,                                               
                            decoration: InputDecoration(
                            border: OutlineInputBorder(),
                           // labelText: 'វាយ បញ្ចូលលេខយោងឯកសារ',   
                            errorText: _isvalidate ? 'សូមបញ្ចូល វាយ បញ្ចូលលេខយោងឯកសារ' : null,                                                                  
                          ),
                        ),             
              ),         
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.all(20),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child:   
                    Container(
                      alignment: Alignment.centerLeft,                             
                      child :  TextButton(                      
                      child: Text(
                        'ថយក្រោយ',
                        style: TextStyle(fontSize: 17,decoration: TextDecoration.underline,color:Colors.blue),
                      ),
                      onPressed: () { 
                            Navigator.pop(context);
                      },
                    ),
                  ),
                  ),
                  Expanded(
                    child:  ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Colors.blue,onPrimary: Colors.white),                                  
                            child: Text("រក្សាទុក"),
                            onPressed: () async  {  
                            
                                 var dcid ;    
                                // if(widget.doctype == "1")
                                // {
                                //   dcid = widget.docfile['document_in_detail'][0]['id'].toString();
                                // }    else if(widget.doctype == "2")
                                // {
                                //     dcid = widget.docfile['document_out_detail'][0]['id'].toString();
                                // }   else
                                // {
                                //   dcid = widget.docfile['document_internal_detail'][0]['id'].toString();
                                // }     
                                 dcid = widget.docfile['id'].toString();         
                                final http.Response response = await http.post(domainname + '/api/document-in/give-comment', // url to get login api
                                 headers: <String, String>{
                                  'Content-Type': 'application/json; charset=UTF-8',
                                  'Authorization': tokenkey,
                                },
                                body: jsonEncode(<String, String>{                        
                                  "dc_id": dcid.toString(),
                                  "note_title": qrvaltext.text.toString(),
                                }),                        
                              ); 
                           var success = jsonDecode(response.body);
                           if(success['message'] == 'success')
                           {
                                Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Dashboard()),
                              );
                           }
                      }
                     ),
                  )            
                ],
              ),
              ),
          ],
        ),
      ),
    );
  }
}