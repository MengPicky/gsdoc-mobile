import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:mydocinoutproject/Login/Loginpage.dart';
import 'package:mydocinoutproject/Profile/changepassword.dart';
import 'package:mydocinoutproject/Profile/profileinfo.dart';
// import 'package:mydocinoutproject/Signature/signdoc.dart';
import 'package:mydocinoutproject/docinfo/docinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

//QR code
import 'package:flutter/cupertino.dart';
import 'package:mydocinoutproject/getdoc/getdoc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mydocinoutproject/mydefined.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:mydocinoutproject/Recievedoc/recievedocument.dart';
// Date format 
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();

}

class _DashboardState extends State<Dashboard> {

  //local data
  bool isloading =false;
  List cards =[];
  List allmydata=[];
  List mysearchcards = [];
  List mystate = [];
  var mychildren = <Widget>[]; 
  var issearch = 0;
  var dashboraddata ;
  String doctextnameheader = "";
  String doctextdatehead = "";
  SearchBar searchBar;
  String doctype = "1";
  TextEditingController commenttext = TextEditingController();
  String iscomment = "";
  final _searchdoc = TextEditingController();


   AppBar buildAppBar(BuildContext context) {
    return new AppBar(

      toolbarHeight: 170,
         title:  Column(
          children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("ឯកសារ",style: new TextStyle(fontFamily: 'KHMERMEF2'),)
                        ),
                        PopupMenuButton(
                        icon: Icon(Icons.menu),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              width: double.infinity,                            
                              decoration: BoxDecoration(
                                  color: Colors.lightGreen,
                              ),                           
                              child: Column(
                                children: [
                                  Container( 
                                        width: 80,
                                        height: 80,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                        color: Color(0xff4f359b), 
                                        borderRadius: BorderRadius.circular(80/2),
                                        image: DecorationImage(                    
                                            fit: BoxFit.fill,
                                            image: uphoto != null ? NetworkImage(domainname + '/storage/' + uphoto) : new AssetImage('assets/images/default_avatar.jpg'),
                                            ),  
                                          ),
                                      ),
                                      Container(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                              padding: EdgeInsets.all(10),
                                              child: username != null ? Text(username):Text("No Name"),
                                          ),
                                        Container(  
                                          padding: EdgeInsets.fromLTRB(15, 0, 0, 10),                                                  
                                            child: uemail != null ? Text(uemail,style: TextStyle(color: Colors.red[800],decoration: TextDecoration.underline,)):Text("No Email"),
                                          ),                        
                                        ],
                                      ),
                                    ),                                 
                                ],
                              ),
                            ),                           
                      ),                     
                      PopupMenuItem(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8,0,0,0),
                            child: Row(
                              children: [
                                Icon(Icons.info, color: Colors.black,),
                                Text('  អំពីកម្មវិធី ជំនាន់ទី​ ១.០'),
                              ],
                            ),
                          ),
                          onTap: (){

                          },
                        ),
                      ),
                      PopupMenuItem(
                        child: checkpermissionrecievedoc(),
                      ),
                      PopupMenuItem(
                        child:  InkWell(
                           child: Padding(
                             padding:const EdgeInsets.fromLTRB(8,0,0,0),
                             child: Row(
                              children: [
                                Icon(Icons.person, color: Colors.black,),
                                Text('  ពត៌មានអ្នកប្រើប្រាស់'),
                              ],
                          ),
                           ),
                          onTap: (){
                             Navigator.push( context,MaterialPageRoute(builder: (context) => new Profile()));
                        },)
                      ),
                      PopupMenuItem(
                        child: InkWell(
                           child: Padding(
                             padding: const EdgeInsets.fromLTRB(8,0,0,0),
                             child: Row(
                              children: [
                                Icon(Icons.lock, color: Colors.black,),
                                Text('  ប្តូរពាក្យសម្ងាត់'),
                              ],
                          ),
                           ),
                            onTap: () {
                                  Navigator.push( context,MaterialPageRoute(builder: (context) => new ChangePassword()));                       
                            },
                        ),
                      ),
                       PopupMenuItem(
                        child: InkWell(                     
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8,0,0,0),
                                child: Row(
                                  children: [
                                    Icon(Icons.logout, color: Colors.black,),
                                    Text('  ចាកចេញ'),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                      await http.post(
                                            domainname + '/api/auth/logout', // url to get login api
                                            headers: <String, String>{
                                              'Content-Type': 'application/json; charset=UTF-8',
                                            },
                                        );
                                        getlogout();
                                         Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => new Loginpage()),
                                                    ModalRoute.withName('/Loginpage')
                                                    );                                                          
                              },
                        ),
                      ),
                    ]
                    ),                             
               ],
             ),
              Container(
                width: double.infinity,
                child: TextFormField(
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                  ),
                                  border: OutlineInputBorder(                                  
                                  ),                                                            
                                  filled: true,
                                  fillColor: Colors.white, 
                                   hintText: 'ស្វែងរកឯកសារ'                          
                                  ),
                              controller: _searchdoc,
                              style: TextStyle(color: Colors.black,fontSize: 15),
                              onFieldSubmitted: (value){
                                  onSubmitted(value);
                              },                             
                            ),
             ),
         ],
        ) , 
        bottom: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(text : "ឯកសារ"),
                    Tab(text : "ពត៌មានសង្ខេប"),
                  ],
                ),   
        //actions: [searchBar.getSearchAction(context)]
       );
  }
  void onSubmitted(String value) {
    if(value.isEmpty)
    {
      mystate=[];
      setState(() {
        cards = [];
        issearch =0;
      });
    }else
    {
      setState(() {
        isloading = true;
        issearch = 1;
      });
        getdocumentalldata(value); 
    }
   
  }

 

  @override
  void initState()
  {

    super.initState();
    doctype='1';
    refreshdata();
    
    getdashboardcardlist(); 
     

  }
   _DashboardState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        hintText: "ស្វែងរកឯកសារ",
        clearOnSubmit: false,
        onSubmitted: onSubmitted,
        setState: setState,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        }
        );
  }
  
  refreshdata()
  { 
        mystate = [];
       if(doctype == "1")
        {
        getDocument('/api/document-in');  
        setState(() {
            doctextnameheader = "ឯកសារចូល";
            doctextdatehead="ថ្ងៃខែ ឯកសារ​ចូល";
        });      
        }else if(doctype == '2')
        {
           setState(() {
            doctextnameheader = "ឯកសារចេញ";
            doctextdatehead="ថ្ងៃខែ ឯកសារ​ចេញ";
              });
          getDocument('/api/document-out');
        }else if(doctype == '3')
        {
           setState(() {
            doctextnameheader = "ឯកសារផ្ទៃក្នុង";
            doctextdatehead="ថ្ងៃខែ ឯកសារ​ផ្ទៃក្នុង";
            });
          getDocument('/api/document-internal');
        }else
        {
          setState(() {
            cards = [];
          });         
        }
    
  }
  
  getDocument(String url) async {
  setState(() {
    isloading = true;
  });
  final http.Response response = await http.get(domainname + url, // url to get login api
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': tokenkey,
    },
  );
  var item = json.decode(response.body)['data'];
  if(mounted)
  {
    setState(() {
        cards = item;
        isloading=false;
      });
  }
}

  getdashboardcardlist() async {
  final http.Response response = await http.get( domainname + '/api/document-dashboard', // url to get login api
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': tokenkey,
    },
  );
 
  var item = json.decode(response.body);
  if(mounted){
    setState(() {
        dashboraddata = item;
      });
  }
     
}
  getdocumentalldata(valuecode) async { 
    allmydata=[];
    mychildren =  <Widget>[];
    mysearchcards  = [];
    mystate = [];
    final http.Response response = await http.get( domainname + '/api/document-search/' + valuecode , // url to get login api
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': tokenkey,
    },
  );
  var item = json.decode(response.body);
 
  var docinalldata = item['document_in'];
  var docoutalldata = item['document_out'];
  var docinternalalldata = item['document_internal'];
  if (mounted)
  {
    if(docinalldata.length > 0)
    {
      allmydata.add(docinalldata['data']);
    }
    if(docoutalldata.length > 0)
    {
      allmydata.add(docoutalldata['data']);
    }
    if(docinternalalldata.length > 0)
    {
     allmydata.add(docinternalalldata['data']);
    }
  }   
   for (var i = 0; i < allmydata.length; i++) {
      for (var docobj in allmydata[i]) {
        if(i==0)
        {
          mystate.add('1');
        }else if(i==1)
        {
           mystate.add('2');
        }else
        {
           mystate.add('3');
        }
        // mychildren.add(searchcard(docobj,doctype));  
         mysearchcards.add(docobj);            
      }
   }
    doctype = '0';
    setState(() {
     cards = mysearchcards;
     isloading=false;
    });
       
  }
 
  @override
  Widget build(BuildContext context) {
   

    return   DefaultTabController(
        length: 2, 
      child: Scaffold(
        primary: true,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0,0,0,15),
        child: FloatingActionButton(child: Icon(Icons.qr_code), onPressed: (){
          _scan();
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,   
       appBar: searchBar.build(context), 
      //   endDrawer: Drawer(
      //   child: ListView(
      //   padding: EdgeInsets.zero,
      //   children: <Widget>[
      //   DrawerHeader(
      //     child: Center(
      //       child: Column(            
      //         children: <Widget>[                 
      //           Container( 
      //             width: 80,
      //             height: 80,
      //             padding: EdgeInsets.all(10),
      //             decoration: BoxDecoration(
      //             color: Color(0xff4f359b), 
      //             borderRadius: BorderRadius.circular(80/2),
      //             image: DecorationImage(                    
      //                 fit: BoxFit.fill,
      //                 image: uphoto != null ? NetworkImage(domainname + '/storage/' + uphoto) : new AssetImage('assets/images/default_avatar.jpg'),
      //                 ),  
      //               ),
      //           ),
      //           Container(
      //             child: Column(
      //               children: <Widget>[
      //                 Container(
      //                     padding: EdgeInsets.all(10),
      //                     child: username != null ? Text(username):Text("No Name"),
      //                 ),
      //                 Container(                                                     
      //                     child: uemail != null ? Text(uemail,style: TextStyle(color: Colors.red[800],decoration: TextDecoration.underline,)):Text("No Email"),
      //                 ),                        
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     decoration: BoxDecoration(
      //       color: Colors.lightGreen,
      //     ),
      //   ),
      //   ListTile(
      //     title: Text('អំពីកម្មវិធី ជំនាន់ទី​ ១.០'),
      //     onTap: () {
      //       // Update the state of the app.
      //       // ...
      //     },
      //   ),
      //   //checkpermissiondocin(),
      //   checkpermissionrecievedoc(),
      //     ListTile(
      //     title: Text('ពត៌មានអ្នកប្រើប្រាស់'),
      //     onTap: ()  {
      //               Navigator.push( context,MaterialPageRoute(builder: (context) => new Profile()));                        
      //     },
      //   ),
      //     ListTile(
      //     title: Text('ប្តូរពាក្យសម្ងាត់'),
      //     onTap: () {
      //           Navigator.push( context,MaterialPageRoute(builder: (context) => new ChangePassword()));                       
      //     },
      //   ),
      //   ListTile(
      //     title: Text('ចាកចេញ'),
      //     onTap: () async {
      //             await http.post(
      //                   domainname + '/api/auth/logout', // url to get login api
      //                   headers: <String, String>{
      //                     'Content-Type': 'application/json; charset=UTF-8',
      //                   },
      //                 );
      //               getlogout();
      //               Navigator.pushReplacement( context,MaterialPageRoute(builder: (context) => new Loginpage()));                        
      //      },
      //     ),         
      //  ],
      // ),
      // ),               
      body:  TabBarView(
        children:  <Widget>[       
                  Container(
                  padding: EdgeInsets.fromLTRB(10,5,10,5),
                  child: Container(
                    child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                      style: doctype == "1" ? 
                                            ElevatedButton.styleFrom(primary: Colors.green[800],onPrimary: Colors.white):
                                            ElevatedButton.styleFrom(primary: Colors.white,onPrimary: Colors.grey),                                                               
                                      child: Row(
                                        children: [
                                           Text("ឯកសារចូល",style: new TextStyle(fontSize: 12),),
                                           Container(                                            
                                             margin: EdgeInsets.fromLTRB(0, 5, 0, 0), 
                                             decoration: BoxDecoration(                                              
                                               color: Colors.transparent,
                                               image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: doctype == "1" ? AssetImage('assets/images/doc-in-active.png')
                                                            : AssetImage('assets/images/doc-in.png')
                                                      ),                                                  
                                             ),                                                                                     
                                             width: 20,
                                             height: 15,
                                           ),
                                        ],
                                      ),
                                      onPressed: (){       
                                      setState(() {
                                        doctype = "1";
                                         refreshdata();
                                      });     
                                }) , 
                                 ElevatedButton(
                                     style: doctype == "2" ? 
                                            ElevatedButton.styleFrom(primary: Colors.green[800],onPrimary: Colors.white):
                                            ElevatedButton.styleFrom(primary: Colors.white,onPrimary: Colors.grey),                                                         
                                       child: Row(
                                        children: [
                                          Text("ឯកសារចេញ",style: new TextStyle(fontSize: 12),),
                                            Container(     
                                              margin: EdgeInsets.fromLTRB(0, 5, 0, 0),                                                                                 
                                             decoration: BoxDecoration(                                              
                                               color: Colors.transparent,
                                               image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                     image: doctype == "2" ? AssetImage('assets/images/doc-out-active.png')
                                                            : AssetImage('assets/images/doc-out.png')
                                                      ),                                                  
                                             ),                                                                                     
                                             width: 20,
                                             height: 15,
                                           ),
                                        ],
                                      ) ,
                                      onPressed: (){       
                                      setState(() {
                                        doctype = "2";
                                         refreshdata();
                                      }); 
                                }) ,
                                 ElevatedButton(
                                     style: doctype == "3" ? 
                                            ElevatedButton.styleFrom(primary: Colors.green[800],onPrimary: Colors.white):
                                            ElevatedButton.styleFrom(primary: Colors.white,onPrimary: Colors.grey),                                                             
                                      child: Row(
                                        children: [
                                          Text("ឯកសារផ្ទៃក្នុង",style: new TextStyle(fontSize: 12),),
                                           Container(     
                                              margin: EdgeInsets.fromLTRB(0, 5, 0, 0), 
                                             decoration: BoxDecoration(                                              
                                               color: Colors.transparent,
                                               image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                       image: doctype == "3" ? AssetImage('assets/images/doc-internal-active.png')
                                                            : AssetImage('assets/images/doc-internal.png')                      
                                                      ),                                                  
                                             ),                                                                                     
                                             width: 20,
                                             height: 15,
                                           ),
                                        ],
                                      ) ,
                                      onPressed: (){       
                                      setState(() {
                                        doctype = "3";
                                         refreshdata();
                                      });     
                                }) 
                            ],
                          )
                          // DropdownButtonFormField(value: doctype,items: [
                          //   DropdownMenuItem(child: Text(""),value: "0"),
                          //   DropdownMenuItem(child: Text("ឯកសារចូល"),value: "1"),
                          //   DropdownMenuItem(child: Text("ឯកសារចេញ"),value: "2"),
                          //   DropdownMenuItem(child: Text("ឯកសារផ្ទៃក្នុង"),value: "3"),
                          // ],
                          //  onChanged: (value){                                  
                          //     setState(() {
                          //       doctype = value;
                          //        refreshdata();
                          //     });
                          //   },
                          // ),
                        ), 
                        Expanded( child: isloading ? Center(child:  CircularProgressIndicator(),) : getmycard() )                        
                      ],
                    ),
                  ) 
                ),
              dashboardCard(),                            
            ],     
        ), 
          
      ),
    );       
  }
  Widget checkpermissiondocin()
  {
     return groupid != 2 ?   ListTile(
            title: Text('ដាក់ឯកសារ'),
            onTap: () {
               Navigator.push( context,MaterialPageRoute(builder: (context) => new Recievedoc()));  
              // Update the state of the app.
              // ...
            },
          ) : Container();
  }
   Widget checkpermissionrecievedoc()
  {
     return groupid != 2 ?   InkWell(
             child: Padding(
               padding: const EdgeInsets.fromLTRB(8,0,0,0),
               child: Row(
                        children: [
                          Icon(Icons.note_add, color: Colors.black,),
                          Text('  ទទួលឯកសារ'),
                        ],
                      ),             
             ),
             onTap: (){
                 Navigator.push( context,MaterialPageRoute(builder: (context) => new Getdocument()));    
             },
       ): 
       Container();
  }
  Widget getuserlistdoc(){
    getDocument('/api/guestdoclist/userid');  
        setState(() {
            doctextnameheader = "ឯកសារ";
            doctextdatehead="ថ្ងៃខែ ឯកសារ​ចូល";
        });   
     return ListView.builder(
      itemCount: cards.length,
      itemBuilder:  (context,index){
        return mydoccard(cards[index],doctype);
    });
  }
 
  Widget getmycard(){  
    return cards.length==0? Center(child: Text("មិនមានទិន្នន័យ"),) : ListView.builder(
      itemCount: cards.length,
      itemBuilder:  (context,index){
        return mystate.isEmpty ? mydoccard(cards[index],doctype) : mydoccard(cards[index],mystate[index]);
    });
  }

  Widget mydoccard(card,type){
    // ignore: non_constant_identifier_names
    var mycodetext;
    var myobjecttext;
    double objWidth = MediaQuery.of(context).size.width*0.55;
    DateTime mydatetime = DateTime.parse(card['created_at'].toString());
    String mydate = DateFormat('dd-MM-yyyy').format(mydatetime);
      if(type=='1')
      {
          doctextnameheader = "ឯកសារចូល";
          doctextdatehead="ថ្ងៃខែ ឯកសារ​ចូល";
          mycodetext = card['document_ref_code'] == null ? '' : card['document_ref_code'];
        
      }else if(type=='2')
      {
          doctextnameheader = "ឯកសារចេញ";
          doctextdatehead="ថ្ងៃខែ ឯកសារ​ចេញ";
          mycodetext = card['document_ref_code'] == null ? '' : card['document_ref_code'];       
      }else
      {
          
          doctextnameheader = "ឯកសារផ្ទៃក្នុង";
          doctextdatehead="ថ្ងៃខែ ឯកសារ​ផ្ទៃក្នុង";
          mycodetext = card['document_code'] == null ? '' : card['document_code'];
    
      }
      if (card['objective'] == null)
      {
       myobjecttext = "មិនមាន";
      }
      else
      {
        myobjecttext =  card['objective'];
      }
    return   Container(   
      child: Card(                  
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(5,5,5,5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                       Container(   
                          margin: EdgeInsets.fromLTRB(0, 3, 0, 0),                         
                            decoration: BoxDecoration(                                              
                              color: Colors.transparent,
                              image: DecorationImage(
                                    fit: BoxFit.cover,
                                      image: AssetImage('assets/images/doc-no.png')                                                           
                                    ),                                                  
                            ),                                                                                     
                            width: 20,
                            height: 15,
                          ),
                      Text(
                        " " + doctextnameheader + " " + mycodetext,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),        
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(5,5,5,5),
                  child: Row(
                    children: [
                        Container(   
                           margin: EdgeInsets.fromLTRB(0, 3, 0, 0),                         
                            decoration: BoxDecoration(                                              
                              color: Colors.transparent,
                              image: DecorationImage(
                                    fit: BoxFit.cover,
                                      image: AssetImage('assets/images/date.png')                                                           
                                    ),                                                  
                            ),                                                                                     
                            width: 20,
                            height: 15,
                          ),
                      Text(" " + doctextdatehead +" : "+ mydate),
                    ],
                  ),
              ),
               Container(
                  padding: EdgeInsets.fromLTRB(5,5,5,5),
                  child: Row(         
                    children: [
                    Container(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              child: Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.fromLTRB(0, 3, 0, 0),                      
                                decoration: BoxDecoration(                                              
                                  color: Colors.transparent,
                                  image: DecorationImage(
                                        fit: BoxFit.cover,
                                          image: AssetImage('assets/images/purpose.png')                                                           
                                        ),                                                  
                                ),                                                                                     
                                width: 20,
                                height: 15,
                              ),                             
                            ),
                            WidgetSpan(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Text( "កម្មវត្ថុឯកសារ: "),
                              )
                            ), 
                            WidgetSpan(
                              child: Container(
                              width: objWidth,
                              alignment: Alignment.centerLeft,
                              child: Text(myobjecttext,overflow: TextOverflow.ellipsis,maxLines: 1,),
                            ))                      
                          ]
                        )
                      ),                        
                      ),                                         
                    ],
                  ),
                  
              ),                                                                
              Row(
                children: [   
                  Expanded(
                    child:   
                    Container(
                      alignment: Alignment.centerLeft,                             
                      child :  TextButton(                    
                      child: Text(
                        'ពត៌មាន',
                        style: TextStyle(fontSize: 17,decoration: TextDecoration.underline,color:Colors.blue),
                      ),
                      onPressed: () { 
                        setState(() {
                          String ind = card['id'].toString();  
                          String docrefcode = doctype == "3" ? card['document_code'].toString() : card['document_ref_code'].toString();        
                          Navigator.push( context,MaterialPageRoute(builder: (context) =>new Docinfo(ind,type.toString(),docrefcode)));                        
                        });                                                                                       
                      },
                    ),
                  ),
                  ),                                
                  Expanded(                     
                      child:  groupid != "2" ? doctype == "1" ?                  
                          Container(
                            alignment: Alignment.centerRight,
                            child : ElevatedButton(
                                          style: ElevatedButton.styleFrom(primary: Colors.blue,onPrimary: Colors.white),                                                               
                                          child: Text("ផ្តល់ចំណារ"),
                                          onPressed: (){       
                                            String ind = card['id'].toString();  
                                            String docrefcode = card['document_ref_code'].toString(); 
                                            getDocumentdetail(ind,docrefcode);                                           
                                           //Navigator.push( context,MaterialPageRoute(builder: (context) => Signdoc(ind, type.toString())));
                                          })                                                                                    
                                ): Container(): Container(),  )
                 
                ],                        
              ),                                                    
            ],
          ),
        )
      ),
    );           
  }

  Future _scan() async {
    await Permission.camera.request();
    String barcode = await scanner.scan();  
    if (barcode == null) {
      print('nothing return.');
    } else {
      final http.Response response = await http.get( domainname + '/api/document-in/' + barcode + "/search", // url to get login api
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': tokenkey,
      },
    );
    var item = json.decode(response.body);
    if(item !=null)
    {
      setState(() {   
        doctype = "1";
        doctextnameheader = "ឯកសារចូល";
        doctextdatehead="ថ្ងៃខែ ឯកសារ​ចូល";
        cards = item['data'];
        issearch = 0;
      });
      //Navigator.push( context,MaterialPageRoute(builder: (context) => Signdoc(docid:item['data'][0]['id'].toString(),doctype: "1")));
    }  
    }
  }

  Widget dashboardCard(){

    return dashboraddata != null ? ListView(
      children: [      
          Padding(
          padding: EdgeInsets.all(10),
            child: Container(
              child: Card(                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                             padding: EdgeInsets.all(5),
                              child: Text("ឯកសារចូល ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                          ),    
                          Container(
                            padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                    Text("ថ្ងៃនេះមានចំនួន ",style: TextStyle(color: Colors.grey),),
                                    Text(dashboraddata['document_in']['today'].toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                ],
                              ) 
                          ),
                          Container(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                   Text("ខែនេះមានចំនួន ",style: TextStyle(color: Colors.grey),),
                                   Text(dashboraddata['document_in']['this_month'].toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                ],
                              ),
                          ),
                           Container(
                                padding: EdgeInsets.fromLTRB(5,5,5,10),
                                child: Row(
                                 children: [
                                   Text("ឆ្នាំនេះមានចំនួន ",style: TextStyle(color: Colors.grey),),
                                   Text(dashboraddata['document_in']['this_year'].toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                 ],
                               ),
                          ),                                                                                                                                         
                        ],
                      ),
                       Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Image.asset("assets/images/doc-in.png",width: 90,height: 90,color: Colors.grey[350],),
                        ),
                      ),
                    ],
                  )
                ),
            ),
          ),
          Padding(
          padding: EdgeInsets.all(10),
            child: Container(
              child: Card(                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                           Container(
                             padding: EdgeInsets.all(5),
                              child: Text("ឯកសារចេញ ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                          ),  
                          Container(
                            padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Text("ថ្ងៃនេះមានចំនួន ",style: TextStyle(color: Colors.grey),),
                                   Text(dashboraddata['document_out']['today'].toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                ],
                              ),
                          ),
                          Container(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Text("ខែនេះមានចំនួន ",style: TextStyle(color: Colors.grey),),
                                   Text(dashboraddata['document_out']['this_month'].toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                ],
                              ),
                          ),
                           Container(
                              padding: EdgeInsets.fromLTRB(5,5,5,10),
                              child: Row(
                                children: [
                                  Text("ឆ្នាំនេះមានចំនួន ",style: TextStyle(color: Colors.grey),),
                                  Text(dashboraddata['document_out']['this_year'].toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                ],
                              ),
                          ),                                                                                                                                         
                        ],
                      ),
                       Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Image.asset("assets/images/doc-out.png",width: 90,height: 90,color: Colors.grey[350],),
                        ),
                      ),
                    ],
                  )
                ),
            ),
          ),
          Padding(
          padding: EdgeInsets.all(10),
            child: Container(
              child: Card(                  
                  child: Row( 
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,            
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Container(
                             padding: EdgeInsets.all(5),
                              child: Text("ឯកសារផ្ទៃក្នុង ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Text("ថ្ងៃនេះមានចំនួន ",style: TextStyle(color: Colors.grey),),
                                  Text(dashboraddata['document_internal']['today'].toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                ],
                              ),
                          ),
                          Container(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                   Text("ខែនេះមានចំនួន ",style: TextStyle(color: Colors.grey),),
                                   Text(dashboraddata['document_internal']['this_month'].toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                ],
                              ),
                          ),
                           Container(
                              padding: EdgeInsets.fromLTRB(5,5,5,10),
                              child: Row(
                                children: [
                                  Text("ឆ្នាំនេះមានចំនួន ",style: TextStyle(color: Colors.grey),),
                                   Text(dashboraddata['document_internal']['this_year'].toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                ],
                              ),
                          ), 
                                                                                                                                                            
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Image.asset("assets/images/doc-internal.png",width: 90,height: 90,color: Colors.grey[350],),
                        ),
                      ),
                    ],
                  )
                ),
            ),
          )
      ],
    ): Container();
  }

  getDocumentdetail(curdocid,curdoccode) async {      
    String   url; 
     url = domainname + "/api/document-in/" + curdocid; 
     final http.Response response = await http.get( url, // url to get login api
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': tokenkey,
      },
    );
    var item = json.decode(response.body)['data'][0];
    showAlertDialog(context,item,curdoccode,curdocid); 
    }

    showAlertDialog(BuildContext context,item,doccode,docid) {
      if (item['doc_confirm_note'] == null)
      {
          iscomment = "";
          commenttext = TextEditingController(text: '');
      }else
      {
          iscomment = "1";
          commenttext = TextEditingController(text: item['doc_confirm_note']['note_title'].toString());
      }
      // set up the buttons
      Widget cancelButton = TextButton(
        child: Text("ចាកចេញ"),
        onPressed:  () {
          Navigator.pop(context);
        },
      );
      Widget continueButton = TextButton(
        child: Text("រក្សាទុក"),
        onPressed:  () async {
          if(commenttext.text != ''){
            if (iscomment == "1")
            {
              final http.Response response = await http.post(domainname + '/api/document-in/give-comment', // url to get login api
              headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': tokenkey,
              },
              body: jsonEncode(<String, String>{                        
                "id" :  item['doc_confirm_note']['id'].toString(),                
                "dc_id": item['doc_confirm_note']['dc_id'].toString(),
                "note_title": commenttext.text.toString(),
              }),                        
              ); 
              var success = jsonDecode(response.body);
              if(success['message'] == 'success')
              {
                  Navigator.pop(context);      
              }
            }else
            {
              final http.Response response = await http.post(domainname + '/api/document-in/give-comment', // url to get login api
              headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': tokenkey,
              },
              body: jsonEncode(<String, String>{                        
                "dc_id": item['id'].toString(),
                "note_title": commenttext.text.toString(),
              }),                        
              ); 
              var success = jsonDecode(response.body);
              if(success['message'] == 'success')
              {
                  Navigator.pop(context);      
              }
            }        
          }  
        },
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Center(child: Text("ផ្តល់ចំណារ")),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Container(child : Center(child: Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,10),
                child: Text('លេខចូល : ' + doccode),
              ))),
              TextFormField(
              minLines: 7,
              maxLines: 7,
              controller: commenttext,
                  decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  // labelText: 'វាយ បញ្ចូលលេខយោងឯកសារ',   
                 //errorText: _isvalidate ? 'ចំណារមិនអាចទទេ' : null,                                                                  
               ),
            )
            ],
          ),
        ) ,         
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
}