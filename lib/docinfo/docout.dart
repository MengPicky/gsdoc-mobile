
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mydocinoutproject/docinfo/docnote.dart';
import 'package:mydocinoutproject/imageview/viewimage.dart';
import 'package:http/http.dart' as http;
import 'package:mydocinoutproject/mydefined.dart';
// ignore: must_be_immutable
class DocOut extends StatefulWidget {
  var docoutdata;
  var docid;

  @override
  _DocOutState createState() => _DocOutState();
  DocOut(this.docid);
}
class _DocOutState extends State<DocOut> {
  int buttonind;

  getDocumentdetail() async {    
    String   url = domainname + "/api/document-out/" + widget.docid;
    final http.Response response = await http.get( url, // url to get login api
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': tokenkey,
      },
    );
    var item = json.decode(response.body)['data'][0];
      setState(() {
         widget.docoutdata =  item;       
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
    return  widget.docoutdata != null ? buttonind == 1 ?  
                    Expanded(child: mydocoutinfomation(),
    ) :  buttonind == 2 ? 
                    Expanded(child:  mydocnotecount()) :
                    Expanded(child: mydocoutcardfiles()): 
                    Container(child: Center(child: CircularProgressIndicator(),),);
  }

  Widget mydocoutinfomation()
  {
     DateTime mydatetime = DateTime.parse(widget.docoutdata['out_date'].toString());
    String mydate = DateFormat('dd-MM-yyyy').format(mydatetime);
    return Padding(
                     padding: const EdgeInsets.all(10.0),
                     child: ListView(
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
                                    child: Text(' : ' + widget.docoutdata['document_code'].toString(),style: mystyle,),                         
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
                                    child: Text("ថ្ងៃខែឆ្នាំឯកសារចេញ",style: mystyle,),                        
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
                                    child: Text(' : ' + widget.docoutdata['document_out_detail'][0]['office']['title'].toString(),style: mystyle,),                         
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
                                    child: Text(' : ' + widget.docoutdata['submitter']['name'].toString(),style: mystyle,),                         
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
                                    child: Text(' : ' + widget.docoutdata['receiver']['title'],style: mystyle,),                         
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
                                    child: Text(' : ' + widget.docoutdata['objective'],style: mystyle,),                         
                                 )                          
                               ),                                          
                             ],
                         ),
                        ),
                       ],
                     ),
     );
  }

  Widget mydocnotecount()
  {
    final List docprocesslist = widget.docoutdata['document_process'];
    return docprocesslist.length == 0 ?  Container(child: Center(child : Text('មិនមាន'))) : ListView.builder(
    itemCount:  docprocesslist.length,
    itemBuilder: (context,index){
      return docnote(docprocesslist[index]);
    },
    );
  }
   Widget mydocoutcardfiles()
  {
      return widget.docoutdata['document_out_detail'].length == 0 ? 
      Center(child: Text("មិនមានឯកសារ")) : 
      ListView.builder(
        itemCount:  widget.docoutdata['document_out_detail'].length,
        itemBuilder:  (context,index)  {
            return mydocoutimg(widget.docoutdata['document_out_detail'][index]);  
    });
  }

  Widget mydocoutimg(fileout)
  {
    print(fileout);
     return  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start, 
                      children: [
                        Expanded(
                          child:   Container(   
                            height: 220,                                                                     
                            child: Card(
                              child: Container(                               
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                    child: Text("លេខចេញ : " + widget.docoutdata['document_code'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text("ថ្ងៃខែ ឯកសារ​ចេញ : " + widget.docoutdata['out_date']),
                                ),
                                Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text("កម្មវត្ថុឯកសារ : " + widget.docoutdata['objective']),
                                ),                                                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [                           
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child :  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(primary: Colors.blue,onPrimary: Colors.white),                                  
                                                    child: Text("មើលរូបភាព"),
                                                    onPressed: (){  
                                                          Navigator.push( context,MaterialPageRoute(builder: (context) =>new Imageviewer(fileout, "2")));                                                                                                      
                                                     // Navigator.push( context,MaterialPageRoute(builder: (context) => Imageviewer()));
                                                    }),                                                                                   
                                          ),                                   
                                      ],                        
                                    ),                                                    
                                  ],
                                ),
                              ), 
                            ),
                          ),                      
                        )                          
                        ],
                      ),  
                    );
  }
}