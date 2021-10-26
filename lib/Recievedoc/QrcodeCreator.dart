//import 'dart:typed_data';
//import 'dart:io';
//import 'dart:typed_data';
//import 'dart:ui';

//import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class QrCreate extends StatefulWidget {
  final  code;
  final  phone;
  
  @override
  _QrCreateState createState() => _QrCreateState();
  QrCreate(this.code,this.phone);
}

class _QrCreateState extends State<QrCreate> {   
  @override
  Widget build(BuildContext context) {
     final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: Center(
      child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: QrImage(
                        data: widget.code,
                        size: 0.3 * bodyHeight, 
                        )
                    ), 
                Container(
                  child:  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("លេខកូដយោង",style: TextStyle(fontSize: 25)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(widget.code,style: TextStyle(fontSize: 25)),
                      ),
                    ],
                  )
                ),    
                Container(
                  child:  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                       child: Text("ឈ្មោះអ្នកដាក់/លេខទូរស័ព្ទ",style: TextStyle(fontSize: 25)),  
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(widget.phone != null ? widget.phone : "",style: TextStyle(fontSize: 25)),
                      ),
                    ],
                  )
                ),                                                         
              ],
          ),
           
        ],
      ),
    )
    ) ;   
  }

}