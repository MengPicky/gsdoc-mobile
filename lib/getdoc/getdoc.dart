import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mydocinoutproject/getdoc/getdocsign.dart';
import 'package:mydocinoutproject/mydefined.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Getdocument extends StatefulWidget {

  @override
  _GetdocumentState createState() => _GetdocumentState();

}

class _GetdocumentState extends State<Getdocument> { 


  TextEditingController qrvaltext = TextEditingController();
  int _isvalidate = 0;
  bool isloading =false;
  String phone="";
  var objdoc;

  getdocumentdata(valuecode) async {
    final http.Response response = await http.get( domainname + '/api/document-in/' + valuecode + '/search', // url to get login api
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': tokenkey,
    },
  );
  var item = json.decode(response.body);
  if(item['data'].length == 0)
  {
    setState(() {
                if(_isvalidate == 3)
                {
                  _isvalidate=3;
                }else{
                   _isvalidate=2;
                }
                isloading =false;
              });
  }else{
setState(() {
      var ownername = item['data'][0]['document_owner']['title'] == null ? '' : item['data'][0]['document_owner']['title'];
      var ownerphone = item['data'][0]['document_owner']['phone'] == null ? '' : item['data'][0]['document_owner']['phone'];
      objdoc = item;
      phone =ownerphone=='' ? ownername : ownername + '(' + ownerphone + ')';
       if(objdoc != null){
        if(objdoc['data'].length == 0)
          {
              setState(() {
                isloading =false;
                _isvalidate=1;
              });
          }else{
            setState(() {
              isloading =false;
                _isvalidate=0;
            });                                      
        // Check document or get document data here
            String doccode = valuecode;                                   
            Navigator.push( context,MaterialPageRoute(builder: (context) => new Getdocsign(doccode,phone,objdoc)));
          }     
      }  
      else
      {
          setState(() {
            isloading =false;
                _isvalidate=1;
              });
      }  
  });
  }    
      //Navigator.push( context,MaterialPageRoute(builder: (context) => new Getdocsign(barcode,phone, item)));
  }
  @override
  Widget build(BuildContext context) {
    
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return isloading ? Scaffold(body: Center(child: CircularProgressIndicator(),),) : Scaffold(
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
                  padding: EdgeInsets.all(10),
                  child: Text('សូមស្គេនឬ បញ្ចូលលេខយោងឯកសារ', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                ),
                Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    ElevatedButton(
                       child: Image.asset("assets/images/qrimage.png",height: 0.3 * bodyHeight,),
                      onPressed:() {
                      _scan();
                    }), _isvalidate == 3 ?
                    Center(
                      child:  Text("ឯកសារស្កេនមិនត្រឹមត្រូវ",style: TextStyle(color: Colors.red),) ,
                    ): Container(child: null,) 
                  ],
                )               
              ),
               Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text('បញ្ចូលលេខយោងឯកសារ', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),              
              ),
               Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: TextFormField(  
                            style: new TextStyle(fontSize: 15),
                            controller: qrvaltext,                                               
                            decoration: InputDecoration(
                           //contentPadding: const EdgeInsets.symmetric(vertical:0),
                           contentPadding: const EdgeInsets.fromLTRB(10,0,10,0),
                            border: OutlineInputBorder(                            
                            ),
                           // labelText: 'វាយ បញ្ចូលលេខយោងឯកសារ',   
                            errorText: _isvalidate == 1 ? 'សូមវាយបញ្ចូលលេខយោងឯកសារ' : _isvalidate ==  2 ? "លេខយោងឯកសារមិនត្រឹមត្រូវ" : null,                                                                  
                          ),
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
                      child:  usergroupid != "2" ?                  
                          Container(
                            alignment: Alignment.centerRight,
                            child : ElevatedButton(
                                    style: ElevatedButton.styleFrom(primary: Colors.blue,onPrimary: Colors.white),                                
                                    child: Text("យល់ព្រម"),
                                    onPressed: (){       
                                      if(qrvaltext.text == "")
                                      {
                                        setState(() {
                                          _isvalidate=1;
                                        });
                                      } else{
                                        setState(() {
                                          isloading = true;
                                        });
                                        getdocumentdata(qrvaltext.text);
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
    );
  }

  
  Future _scan() async {
    await Permission.camera.request();
    String barcode = await scanner.scan();  
    if (barcode == null) {
      print('nothing return.');
    } else {
      _isvalidate = 3;
      getdocumentdata(barcode);     
     // this._outputController.text = barcode;
    }
  }
  
}