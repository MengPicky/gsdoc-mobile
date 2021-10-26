import 'dart:convert';

import 'package:mydocinoutproject/Checkdoc/checkdoccomment.dart';
import 'package:mydocinoutproject/Viewdoc/viewdoc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:mydocinoutproject/mydefined.dart';
import 'package:http/http.dart' as http;

class Signdoc extends StatefulWidget {
  final String docid;
  final String doctype;
  @override
  _SigndocState createState() => _SigndocState(); 
  Signdoc( this.docid,this.doctype);
}

class _SigndocState extends State<Signdoc> {
   var docobj ;
   SearchBar searchBar;
   String myoptionval;

   getDocumentdetail() async {      
    String   url; 
    if(widget.doctype == "1")
    {
      url = domainname + "/api/document-in/" + widget.docid;
    }else if(widget.doctype == "2")
    {
      url =domainname + "/api/document-out/" + widget.docid;
    }else
    {
      url = domainname + "/api/document-internal/" + widget.docid;
    }
    final http.Response response = await http.get( url, // url to get login api
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': tokenkey,
      },
    );
    var item = json.decode(response.body)['data'][0];
      setState(() {
         docobj =  item;       
        });        
    }

  @override
  void initState() {
    getDocumentdetail();
    super.initState();
  }

   AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title:  Text("ផ្តល់ចំណារ"),         
        // actions: [
        //   searchBar.getSearchAction(context),
        //   PopupMenuButton<String>(
        //     onSelected: (val){
        //       setState(() {
        //         myoptionval = val;
        //       });
        //     },
        //     itemBuilder: (BuildContext context) => [
        //       PopupMenuItem(
        //         value: "1",
        //         child: Text("First Item"),
        //       ),
        //       PopupMenuItem(
        //         value: "2",
        //         child: Text("Second Item"),
        //       ),
        //     ],
        //     )
        //   ]
          );
    }
    void onSubmitted(String value) {
      setState(() {
        print(value);
      });
    }
   _SigndocState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),                    
      body: Padding(
        padding: const EdgeInsets.all(10),
        child:mydocincardfiles()
      )   
    );
  }

  
  Widget mydocincardfiles()
  {
    if(docobj != null){ 
    var objectdata;
    if(widget.doctype == "1"){

     objectdata = docobj['document_in_detail'];
         
    }else if(widget.doctype == "2")
    {
      objectdata = docobj['document_out_detail'];
          
    }else
    {
      objectdata = docobj['document_internal_detail'];
    }
      return objectdata == null ? Container(child: Center(child: CircularProgressIndicator(),),) : objectdata.length == 0 ? 
      Center(child: Center(child: Text("មិនមានឯកសារ"))) : 
      ListView.builder(
        itemCount:  objectdata.length,
        itemBuilder:  (context,index)  {
            return mydocinimg(objectdata[index]);  
    });
    }else
    {
      return Container(child: Center(child: CircularProgressIndicator(),),);
    }
   
  }
  Widget mydocinimg(filein)
  {     
        var doccodetext ;
        if(widget.doctype == "2")
        {
          doccodetext = 'មិនមាន'; // api អត់មាន
        }else if(widget.doctype == "1")
        {
           doccodetext = filein['document_code'].toString();
        }else
        {
          doccodetext = 'មិនមាន'; // api អត់មាន
        }
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
                                    child: Text("លេខចូល : " + doccodetext,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
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
                                      child : docobj['doc_confirm_note'] == null ? ElevatedButton(
                                                    style: ElevatedButton.styleFrom(primary: Colors.blue,onPrimary: Colors.white),                                
                                                    child: Text("ផ្តល់ចំណារ"),
                                                    onPressed: (){    
                                                      Navigator.push( context,MaterialPageRoute(builder: (context) =>new Viewdoc(docobj,widget.doctype)));                                                                                                                                                                                                           
                                               }): ElevatedButton(
                                                    style: ElevatedButton.styleFrom(primary: Colors.blue,onPrimary: Colors.white),                                  
                                                    child: Text("ពិនិត្យចំណារឯកសារ"),
                                                    onPressed: (){    
                                                      Navigator.push( context,MaterialPageRoute(builder: (context) =>new Checkdoc(docobj,widget.doctype)));                                                                                                                                                                                                           
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