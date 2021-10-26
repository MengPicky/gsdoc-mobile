
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter/material.dart';
//import 'package:mydocinoutproject/getdoc/getdoc.dart';
import 'package:mydocinoutproject/mydefined.dart';
import 'package:signature/signature.dart';

class Getdocsign extends StatefulWidget {
  final String doccode;
  final String phone;

   
  final objdoc;
  @override
  _GetdocsignState createState() => _GetdocsignState();
  Getdocsign(this.doccode,this.phone,this.objdoc);
}

class _GetdocsignState extends State<Getdocsign> {
    bool isloading =false;
   TextEditingController subname = TextEditingController();
    final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
  );
  int isready = 0;
  var img64;
  @override
  Widget build(BuildContext context) {
 
    return isloading ? Scaffold(body: Center(child: CircularProgressIndicator(),),) : Scaffold(
      body:  Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          addAutomaticKeepAlives: true,
          children: <Widget>[           
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text('សូម ពិនិត្យ និង បំពេញពត៌មាន', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                ),
              Padding(
                 padding: EdgeInsets.all(10),
                 child: Row(                 
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [                    
                      Expanded(
                        flex: 1,
                        child:Container( 
                          alignment: Alignment.center,
                          child: Text('លេខកូដយោង', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),)                   
                      ),
                       Expanded(
                        flex: 2,
                        child:Container( 
                            alignment: Alignment.centerLeft,
                            child: Text(widget.doccode, style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),                  
                      ),
                    )                
                   ],
                 ),
             ),  
              Padding(
                 padding: EdgeInsets.all(10),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Expanded(
                        flex: 1,
                        child:Container( 
                          alignment: Alignment.center,
                          child:Text('ឈ្មោះអ្នកដាក់/\nលេខទូរស័ព្ទ', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),               
                      ),
                     ),
                       Expanded(
                        flex: 2,
                        child:Container( 
                            alignment: Alignment.centerLeft,
                            child:Text(widget.phone, style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),                  
                      ),
                    )
                                                                          
                   ],
                 ),
             ),
              Padding(
                 padding: EdgeInsets.all(10),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Expanded(
                        flex: 1,
                        child:Container( 
                          alignment: Alignment.center,
                          child:Text('អ្នកទទួលជំនួស', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),               
                      ),
                     ),
                       Expanded(
                        flex: 2,
                        child:Container( 
                            alignment: Alignment.centerLeft,
                            child:  Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(10),
                                          child: TextFormField(  
                                          controller: subname,    
                                          style: TextStyle(fontSize:15),                                           
                                          decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.fromLTRB(10,0,10,0),
                                          border: OutlineInputBorder(),
                                                                                   
                          ),
                        ),             
                        ),                  
                      ),
                    )
                                          
                   ],
                 ),
             ), 
              Padding(
                 padding: EdgeInsets.all(0),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                      Container(
                      alignment: Alignment.center,
                    
                      child: Text('Sign/ចុះហត្ថលេខា', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      ),
                      Signature(
                      controller: _controller,
                      height: 250,
                      backgroundColor: Colors.transparent
                      ),
                      Container(
                      decoration: const BoxDecoration(color: Colors.black),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[ isready == 1? Container():
                          //SHOW EXPORTED IMAGE IN NEW ROUTE
                          IconButton(
                            icon: const Icon(Icons.check),
                            color: Colors.blue,
                            onPressed: () async {
                              if (_controller.isNotEmpty) {
                                 Uint8List data = await _controller.toPngBytes();
                                setState(() {
                                  isready = 1;
                                   img64 = base64.encode(data);
                                });                                                                                     
                                //Image objimage = Image.memory(data);
                               // Uint8List bytes = base64.decode(img64);                                
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (BuildContext context) {
                                //       return Scaffold(
                                //         appBar: AppBar(),
                                //         body: Center(
                                //             child: Container(
                                //                 color: Colors.transparent, child: Image.memory(bytes))),
                                //       );                                
                                //     },
                                //   ),
                                // );
                              }
                            },
                          ),                        
                          //CLEAR CANVAS
                          IconButton(
                            icon: const Icon(Icons.clear),
                            color: Colors.blue,
                            onPressed: () {
                              setState(() {
                                 _controller.clear(); 
                                  isready =0 ;
                              });                           
                            },
                          ),
                          
                        ],
                      ),
                    ),               
                Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.all(20),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [ isready == 1 ?
                  ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Colors.blue,onPrimary: Colors.white),                              
                            child:  Text("យល់ព្រម"),
                            onPressed: ()   async {   
                              setState(() {
                                isloading = true;
                              });
                              // API Save
                               final http.Response response = await http.post(domainname + '/api/document-in/submit-qr', // url to get login api
                                headers: <String, String>{
                                  'Content-Type': 'application/json; charset=UTF-8',
                                  'Authorization': tokenkey,
                                },
                                 body: jsonEncode(<String, String>{
                                  'dc_id': widget.objdoc['data'][0]['id'].toString(),
                                  "dc_status_id": '2',//widget.objdoc['data'][0]['document_status_id'].toString(),
                                  "receiver_id": widget.objdoc['data'][0]['receiver_id'].toString(),
                                  "forward_handler_id":userid.toString(),
                                  "is_monitor":"0",
                                  "submitted_date": DateTime.now().toString(),
                                  "type": '1', //widget.objdoc['data'][0]['document_type_id'].toString(),
                                  "description":"",
                                  "ended_process":"1",
                                  "ended_process_date": DateTime.now().toString(),
                                  "dc_process_result_status_id":"5",
                                  "receiver": subname.text,
                                  "qrfile":"data:image/png;base64," + img64
                                }),                      
                             );
                              var item = json.decode(response.body);  
                              setState(() {
                                isloading=false;
                              });   
                              if (item['message'] == 'success')
                              {            
                                 showAlertDialog(context);     
                               //  Navigator.pop(context);
                              }                                                   
                      }
                      ):  ElevatedButton(
                                  style: ElevatedButton.styleFrom(primary: Colors.grey,onPrimary: Colors.white),                                
                                  child:  Text("យល់ព្រម"),
                                  onPressed: ()   {                                                          
                            }
                      ),
                      ],
                    ),
                    ),           
                   ],
                 ),
             ),          
          ],
        ),
      ),
    );
  }
  
  showAlertDialog(BuildContext context) {  
 Timer _timer;
  // Create button  
 showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          _timer = Timer(Duration(seconds: 3), () {
              Navigator.pop(context);
              Navigator.pop(context);
          });

          return AlertDialog(
            backgroundColor: Colors.white,
            title: Center(
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48,
                ),
            ),
            content: SingleChildScrollView(
              child: Center(child: Text('ប្រតិបត្តិការបានជោគជ័យ',style: TextStyle(fontSize: 20),)),
            ),
        );
        }
      ).then((val){
        if (_timer.isActive) {   
          _timer.cancel();
        
        }
      }); 
 }
}