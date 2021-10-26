import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


 TextStyle mystyle = TextStyle(
     fontSize: 18,
     color: Colors.grey,
     fontFamily: "Khmer OS",
     
   );

   
 Widget docnote(filein)
  {
    DateTime mydatetime = DateTime.parse(filein['updated_at'].toString());
    String mydate = DateFormat('dd-MM-yyyy').format(mydatetime);
    return Padding(
          padding: EdgeInsets.all(10) ,
          child: Container(
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
          //  height: 350,
            child: Container(
              child:  Column(
                 children: <Widget>[
                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container( 
                                alignment: Alignment.centerLeft,    
                               child: Text("កាលបរិច្ឆេទនៃកំណត់ត្រា" ,style: mystyle,),                    
                              ) 
                            ), 
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerLeft,  
                              child: Text(' : ' + mydate,style: mystyle,)
                            )
                          ) 
                      ],
                   ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(     
                               child: Text("ប្រភេទលំហូរ" ,style: mystyle,),                    
                              ) 
                            ),
                          Expanded(                                 
                          flex: 1,
                          child: Container(   
                            alignment: Alignment.centerLeft,                              
                            child: Text(filein['document_process_result_status'] != null ? ' : ' + filein['document_process_result_status']['name_kh'].toString():" : មិនមាន",style: mystyle,),                         
                          ) 
                        ), 
                      ],
                   ),
                    ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(     
                               child: Text("កន្លែងមុខការបន្ត" ,style: mystyle,),                    
                              ) 
                            ),
                          Expanded(                                 
                          flex: 1,
                          child: Container(   
                            alignment: Alignment.centerLeft,                              
                           child: Text(filein['office'] != null ? ' : ' + filein['office']['title'].toString():" : មិនមាន",style: mystyle,),                    
                          ) 
                        ), 
                      ],
                     ),
                   ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(     
                               child: Text("អ្នកមុខការ" ,style: mystyle,),                    
                              ) 
                            ),
                          Expanded(                                 
                          flex: 1,
                          child: Container(   
                            alignment: Alignment.centerLeft,                              
                            child: Text(filein['receiver'].toString() == 'null' ? ' : មិនមាន': ' : ' + filein['receiver'].toString(),style: mystyle,),                
                          ) 
                        ), 
                      ],
                   ),
                    ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(     
                               child: Text("ថ្ងៃខែឆ្នាំប្រគល់/ទទួល" ,style: mystyle,),                    
                              ) 
                            ),
                          Expanded(                                 
                          flex: 1,
                          child: Container(   
                            alignment: Alignment.centerLeft,                              
                             child: Text(filein['submitted_date'] == null ? ' : មិនមាន' : ' : ' + filein['submitted_date'].toString(),style: mystyle,),           
                          ) 
                        ), 
                    ],
                   ),
                  ),
                  filein['ended_process'] == "0" ? Container() : checkendedprocess(filein), 
                 ],
              ),
            ),
          ),
    );
  }

  Widget checkendedprocess(filein)
  {
    DateTime mydatetime = DateTime.parse(filein['ended_process_date'].toString());
    String mydate = DateFormat('dd-MM-yyyy').format(mydatetime);
    return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(     
                        child: Text("ឯកសារ បានបញ្ចប់រួចរាល់" ,style: mystyle,),                    
                      ) 
                    ),
                  Expanded(                                 
                  flex: 2,
                  child: Container(   
                    alignment: Alignment.centerLeft,                              
                      child: Text(' : ' + mydate,style: mystyle,),           
                  ) 
                ), 
              ],
            ),
        );
  }