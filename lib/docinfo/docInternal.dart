import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:qrcodescanner/imageview/viewimage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mydocinoutproject/imageview/viewimage.dart';
import 'package:mydocinoutproject/mydefined.dart';
import 'package:mydocinoutproject/docinfo/docnote.dart';

// ignore: must_be_immutable
class DocInternal extends StatefulWidget {
  var docid;
  //bool isloading = true;
  @override
  _DocInternalState createState() => _DocInternalState();
  DocInternal(this.docid);
}

class _DocInternalState extends State<DocInternal> {
    var docinternaldata;
    int buttonind;
   getDocumentdetail() async {   
 
    String   url = domainname + "/api/document-internal/" + widget.docid;
    final http.Response response = await http.get( url, // url to get login api
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': tokenkey,
      },
    );
    var item = json.decode(response.body)['data'][0];
    if(mounted){
        setState(() {
            docinternaldata =  item;      
            });   
    }

}
@override
  void initState() {
    buttonind = 1;
     super.initState();
    getDocumentdetail();   
  }
  @override
  Widget build(BuildContext context) {
    //print(docinternaldata);
    return docinternaldata != null ? 
        datawidget():
        Center(
          child: Container(
             child: CircularProgressIndicator()
          ),
        );
  }

Widget datawidget()
  {
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
     return  docinternaldata != null ? buttonind == 1 ?  
                    Expanded(child: mydocinfomation(),
    ) :  buttonind == 2 ? 
                    Expanded(child: mydocnotecount()) :
                    Expanded(child: mydocincardfiles()): 
                    Container(child: Center(child: CircularProgressIndicator(),),);
  }
  Widget mydocinfomation()
  {
    DateTime mydatetime = DateTime.parse(docinternaldata['arrival_date'].toString());
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
                                    child: Text("លេខឯកសារ",style: mystyle,),                        
                                 ) 
                               ),
                                Expanded(
                                  flex: 2,
                                  child: Container(  
                                     alignment: Alignment.centerLeft,                                
                                    child: Text(' : ' + docinternaldata['document_code'].toString(),style: mystyle,),                         
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
                                    child: Text("ថ្ងៃខែឆ្នាំឯកសារ",style: mystyle,),                        
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
                                    child: Text(' : ផ្ទៃក្នុង',style: mystyle,),                         
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
                                    child: Text(' : ' + docinternaldata['receiver']['name'].toString(),style: mystyle,),                         
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
                                    child: Text(docinternaldata['document_internal_detail'].length != 0 ?  docinternaldata['document_internal_detail'][0]['objective'] == null ? ' : មិនមាន' : " : " + docinternaldata['document_internal_detail'][0]['objective'].toString() : ' : មិនមាន',style: mystyle,),                         
                                 )                          
                               ),                                          
                             ],
                         ),
                        ),
                       ],
                     )
     );
  }
   Widget mydocnotecount()
  {
    final List docprocesslist = docinternaldata['document_process']; 
    return docprocesslist.length == 0 ? Container(child: Center(child : Text('មិនមាន'))) : ListView.builder(
    itemCount: docprocesslist == null ? 0 : docprocesslist.length,
    itemBuilder: (context,index){
      return docnote(docprocesslist[index]);
    },
    );
  }
   Widget mydocincardfiles()
  {
      return docinternaldata['document_internal_detail'].length == 0 ? 
      Center(child: Text("មិនមានឯកសារ")) : 
      ListView.builder(
        itemCount:  docinternaldata['document_internal_detail'].length,
        itemBuilder:  (context,index)  {
            return mydocinimg(docinternaldata['document_internal_detail'][index]);  
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
                            height: 220,                                                                     
                            child: Card(
                              child: Container(                              
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                    child: Text("លេខចូល : " + filein['id'].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text("ថ្ងៃខែ ឯកសារ​ចូល : " + filein['created_at']),
                                ),
                                Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(filein['objective'] != null ? "កម្មវត្ថុឯកសារ : " + filein['objective'] : "កម្មវត្ថុឯកសារ : មិនមាន"),
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
                                                      Navigator.push( context,MaterialPageRoute(builder: (context) => Imageviewer(filein, "3")));                                                                                                                                 
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