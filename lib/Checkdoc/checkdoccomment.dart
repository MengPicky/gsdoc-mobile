import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mydocinoutproject/Dashboard/dashboard.dart';
import 'package:mydocinoutproject/mydefined.dart';

class Checkdoc extends StatefulWidget {
  final doctype ;
  final docfile;
  @override
  _CheckdocState createState() => _CheckdocState();
  Checkdoc(this.docfile,this.doctype);
}

class _CheckdocState extends State<Checkdoc> {
  TextEditingController qrvaltext = TextEditingController();
  bool _isvalidate = false;
 
  @override
  void initState() {
    super.initState();
    qrvaltext = TextEditingController(text: widget.docfile['doc_confirm_note']['note_title'].toString());
  }

  @override
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
                            maxLines: 10,    
                            minLines: 1,                       
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
                    child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.blue,onPrimary: Colors.white),                             
                          child: Text("កែប្រែ"),
                          onPressed: () async  {                            
                                final http.Response response = await http.post(domainname + '/api/document-in/give-comment', // url to get login api
                                 headers: <String, String>{
                                  'Content-Type': 'application/json; charset=UTF-8',
                                  'Authorization': tokenkey,
                                },
                                body: jsonEncode(<String, String>{       
                                  "id" :  widget.docfile['doc_confirm_note']['id'].toString(),                
                                  "dc_id": widget.docfile['doc_confirm_note']['dc_id'].toString(),
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
                   )            
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