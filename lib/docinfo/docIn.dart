
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mydocinoutproject/docinfo/docnote.dart';
import 'package:mydocinoutproject/imageview/viewimage.dart';
import 'package:http/http.dart' as http;
import 'package:mydocinoutproject/mydefined.dart';



// ignore: must_be_immutable
class DocIN extends StatefulWidget {
  var docindata ;
  var docid;

 

  @override
  _DocINState createState() => _DocINState();
  DocIN(this.docid);
}


  

class _DocINState extends State<DocIN> {
  List docprocess = [];
  int buttonind;
  
   getDocumentdetail() async {    
    String   url = domainname + "/api/document-in/" + widget.docid;
    final http.Response response = await http.get( url, // url to get login api
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': tokenkey,
      },
    );
    var item = json.decode(response.body)['data'][0];
      setState(() {
         widget.docindata =  item;       
        });        
}
  @override
  void initState() {
    buttonind =1;
    getDocumentdetail();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Container(
            child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                  ElevatedButton(
                        style: buttonind == 1 ? 
                              ElevatedButton.styleFrom(primary: Colors.green[800],onPrimary: Colors.white):
                              ElevatedButton.styleFrom(primary: Colors.white,onPrimary: Colors.grey),                                                               
                        child: Row(
                          children: [
                              Text("ពត៌មានបន្ថែម",style: new TextStyle(fontSize: 12),),
                              Container(                                            
                                             margin: EdgeInsets.fromLTRB(0, 3, 0, 0), 
                                             decoration: BoxDecoration(                                              
                                               color: Colors.transparent,
                                               image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: buttonind == 1 ? AssetImage('assets/images/info-active.png')
                                                            : AssetImage('assets/images/info.png')
                                                      ),                                                  
                                             ),                                                                                     
                                             width: 20,
                                             height: 15,
                                           ),
                          ],
                        ),
                        onPressed: (){
                            setState(() {
                              buttonind = 1;
                            });
                        },
                   ) ,
                       ElevatedButton(
                        style: buttonind == 2 ? 
                              ElevatedButton.styleFrom(primary: Colors.green[800],onPrimary: Colors.white):
                              ElevatedButton.styleFrom(primary: Colors.white,onPrimary: Colors.grey),                                                               
                        child: Row(
                          children: [
                              Text("កំណត់ត្រា",style: new TextStyle(fontSize: 12),),
                              Container(                                            
                                             margin: EdgeInsets.fromLTRB(0, 3, 0, 0), 
                                             decoration: BoxDecoration(                                              
                                               color: Colors.transparent,
                                               image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: buttonind == 2 ? AssetImage('assets/images/note-active.png')
                                                            : AssetImage('assets/images/note.png')
                                                      ),                                                  
                                             ),                                                                                     
                                             width: 20,
                                             height: 15,
                                           ),
                          ],
                        ),
                        onPressed: (){
                            setState(() {
                              buttonind = 2;
                            });
                        },
                   ) ,
                       ElevatedButton(
                        style: buttonind == 3 ? 
                              ElevatedButton.styleFrom(primary: Colors.green[800],onPrimary: Colors.white):
                              ElevatedButton.styleFrom(primary: Colors.white,onPrimary: Colors.grey),                                                               
                        child: Row(
                          children: [
                              Text("រូបភាព",style: new TextStyle(fontSize: 12),),
                              Container(                                            
                                             margin: EdgeInsets.fromLTRB(0, 3, 0, 0), 
                                             decoration: BoxDecoration(                                              
                                               color: Colors.transparent,
                                               image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: buttonind == 3 ? AssetImage('assets/images/doc-image-active.png')
                                                            : AssetImage('assets/images/doc-image.png')
                                                      ),                                                  
                                             ),                                                                                     
                                             width: 20,
                                             height: 15,
                                           ),
                          ],
                        ),
                        onPressed: (){
                            setState(() {
                              buttonind = 3;
                            });
                        },
                   ) ,
               ], 
            ),
          ),
         checkbuttonind(),
        ],
      ),
    );
  }

  Widget checkbuttonind()
  {
    return  widget.docindata != null ? buttonind == 1 ?  
                    Expanded(child: mydocinfomation(),
    ) :  buttonind == 2 ? 
                    Expanded(child: mydocnotecount()) :
                    Expanded(child: mydocincardfiles()): 
                    Container(child: Center(child: CircularProgressIndicator(),),);
  }
  Widget mydocinfomation()
  {
    DateTime mydatetime = DateTime.parse(widget.docindata['arrival_date'].toString());
    String mydate = DateFormat('dd-MM-yyyy').format(mydatetime);
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
       // margin: const EdgeInsets.fromLTRB(0,0,0,150),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
               color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ) 
          ]
        ),
        child: Column(
          children: [
             Padding(
                padding: const EdgeInsets.all(10),
                child: Row(                                                      
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(     
                        child: Text("លេខចូល",style: mystyle,),                        
                      ) 
                    ),
                    Expanded(                                                   
                      flex: 1,
                      child: Container(   
                        alignment: Alignment.centerLeft,                              
                        child: Text(widget.docindata['order_number'] == "" ? ' : មិនមាន' : ' : ' + widget.docindata['order_number'],style: mystyle,),                         
                      )                          
                    ),                                          
                  ],
                ),
              ),
            mydivider(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(                                                     
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(     
                        child: Text("ថ្ងៃខែឆ្នាំឯកសារចូល",style: mystyle,),                        
                      ) 
                    ),
                    Expanded(
                      flex: 1,
                      child: Container( 
                        alignment: Alignment.centerLeft,                                 
                        child: Text(' : ' + mydate,style: mystyle,),                         
                      )                          
                    ),                                          
                  ],
              ),
            ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(                                                    
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(     
                        child: Text("មកពីអង្គភាព",style: mystyle,),                        
                      ) 
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(  
                        alignment: Alignment.centerLeft,                                
                        child: Text(widget.docindata['office'] != null ? ' : ' + widget.docindata['office']['title'].toString() : ' : មិនមាន',style: mystyle,),                         
                      )                          
                    ),                                          
                  ],
              ),
            ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(                                                  
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(     
                        child: Text("អ្នកដាក់ឯកសារ",style: mystyle,),                        
                      ) 
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(   
                        alignment: Alignment.centerLeft,                               
                        child: Text(widget.docindata['document_owner'] != null ? ' : ' + widget.docindata['document_owner']['title'].toString() : ' : មិនមាន',style: mystyle,),                         
                      )                          
                    ),                                          
                  ],
              ),
            ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(                                                   
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(     
                        child: Text("អ្នកទទួលឯកសារ",style: mystyle,),                        
                      ) 
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(    
                        alignment: Alignment.centerLeft,                              
                        child: Text(' : ' + widget.docindata['user']['name'],style: mystyle,),                         
                      )                          
                    ),                                          
                  ],
              ),
            ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(                                                   
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(     
                        child: Text("ជាដីការអម",style: mystyle,),                        
                      ) 
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(    
                        alignment: Alignment.centerLeft,                              
                        child: Text(widget.docindata['isCommander_id'] == 0 ? " : មិនមានដីការអម":" : មានដីការអម",style: mystyle,),                         
                      )                          
                    ),                                          
                  ],
              ),
            ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(                                                     
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(     
                        child: Text("ប្រភេទឯកសារ",style: mystyle,),                        
                      ) 
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(  
                        alignment: Alignment.centerLeft,                                
                        child: Text(widget.docindata['document_type'] != null ? ' : ' + widget.docindata['document_type']['title'].toString() : ' : មិនមាន',style: mystyle,),                         
                      )                          
                    ),                                          
                  ],
              ),
            ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(                                                     
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(     
                        child: Text("កម្មវត្ថុ",style: mystyle,),                        
                      ) 
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(  
                        alignment: Alignment.centerLeft,                                
                        child: Text(widget.docindata['objective'] != null ? ' : ' + widget.docindata['objective'] : " : មិនមាន",style: mystyle,),                         
                      )                          
                    ),                                          
                  ],
              ),
            ),
          ],
        ),
      ),
      );
  }
   Widget mydocnotecount()
  {    
    final List docprocesslist = widget.docindata['document_process']; 
    return docprocesslist.length == 0 ?  Container(child: Center(child : Text('មិនមាន'))):  ListView.builder(
    itemCount:  docprocesslist.length,
    itemBuilder: (context,index){
      return docnote(docprocesslist[index]);
    },
    );
  }
  Widget mydocincardfiles()
  {
      return widget.docindata['document_in_detail'].length == 0 ? 
      Center(child: Text("មិនមានឯកសារ")) : 
      ListView.builder(
        itemCount:  widget.docindata['document_in_detail'].length,
        itemBuilder:  (context,index)  {
            return mydocinimg(widget.docindata['document_in_detail'][index]);  
    });
  }
  Widget mydocinimg(filein)
  {
        return   Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start, 
                      children: [
                        Expanded(
                          child:   Container(  
                            decoration: BoxDecoration(
                               color: Colors.white,
                               boxShadow: [
                                 BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3), //
                                 )
                               ]
                            ), 
                            height: 200,                                                                     
                            child: Container(                              
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                  child: Text("លេខចូល : " + filein['document_code'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              ),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text("ថ្ងៃខែ ឯកសារ​ចូល : " + filein['created_at']),
                              ),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(filein['objective_detail'] != null ? "កម្មវត្ថុឯកសារ : " + filein['objective_detail'] : "កម្មវត្ថុឯកសារ : មិនមាន"),
                              ), 
                                
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [                           
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child : ElevatedButton(
                                                  style: ElevatedButton.styleFrom(primary: Colors.blue,onPrimary: Colors.white),                                
                                                  child: Text("មើលរូបភាព"),
                                                  onPressed: (){                                                                                      
                                                    Navigator.push( context,MaterialPageRoute(builder: (context) => Imageviewer(filein, "1")));                                                                                                                                 
                                             }),                                                                                   
                                        ),                                   
                                    ],                        
                                  ),                                                    
                                ],
                              ),
                            ),
                          ),                      
                        )                          
                        ],
                      ),  
                    );
  }
 }