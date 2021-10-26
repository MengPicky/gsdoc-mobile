 

import 'package:mydocinoutproject/docinfo/docIn.dart';
//import 'package:qrcodescanner/imageview/viewimage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

import 'package:mydocinoutproject/docinfo/docInternal.dart';
import 'package:mydocinoutproject/docinfo/docout.dart';


 
class Docinfo extends StatefulWidget {
  final String docid;
  final String doctype;
  final String docrefcode;
  @override
  Docinfo(this.docid,this.doctype,this.docrefcode);
  _DocinfoState createState() => _DocinfoState();
  
}
class _DocinfoState extends State<Docinfo>
 {   
   SearchBar searchBar;
   String myoptionval;
   String headerinfo ="";

  @override
  void initState()
  {
    super.initState();
  }

   TextStyle mystyle = TextStyle(
     fontSize: 18,
     color: Colors.grey,
     fontFamily: "Khmer OS",
   );
   
   Widget docardwidget()
  {
    if(widget.doctype == "1")
    {
       // headerinfo ="ឯកសារចូល";
     return DocIN(widget.docid);     
    }else if(widget.doctype == "2")
    {
      //  headerinfo ="ឯកសារចេញ";
     return DocOut(widget.docid);  
    }
    else 
    {
     // headerinfo ="ឯកសារផ្ទៃក្នុង";
      return DocInternal(widget.docid);  
    }
  }
  String headerappbar()
  {
     if(widget.doctype == "1")
    {
        headerinfo ="ឯកសារចូល : " + widget.docrefcode;   
    }else if(widget.doctype == "2")
    {
        headerinfo ="ឯកសារចេញ : " + widget.docrefcode; 
    }
    else 
    {
        headerinfo ="ឯកសារផ្ទៃក្នុង : " + widget.docrefcode;
    }
    return headerinfo;
  }
   AppBar buildAppBar(BuildContext context) {
    return new AppBar(         
        title: Center(
            child: Text(headerappbar()), 
        ),
        // actions: [
        //   searchBar.getSearchAction(context),
          // PopupMenuButton<String>(
          //   onSelected: (val){
          //     setState(() {
          //       myoptionval = val;
          //     });
          //   },
          //   itemBuilder: (BuildContext context) => [
          //     PopupMenuItem(
          //       value: "1",
          //       child: Text("First Item"),
          //     ),
          //     PopupMenuItem(
          //       value: "2",
          //       child: Text("Second Item"),
          //     ),
          //   ],
          //   )
         // ]
        );
    }
    void onSubmitted(String value) {
      setState(() {
        print(value);
      });
    }
   
   _DocinfoState() {
     // get cocument data by id
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
      body:  docardwidget()   
    );   
             
  }
}