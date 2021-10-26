import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:mydocinoutproject/api/pdf_api.dart';
import 'package:mydocinoutproject/mydefined.dart';
import 'package:path/path.dart' as p;
import 'package:path/path.dart';

// ignore: must_be_immutable
class Imageviewer extends StatefulWidget {
  var docfiles;
  var doctype;

  @override
  _ImageviewerState createState() => _ImageviewerState();
  Imageviewer(this.docfiles, this.doctype);
}

class _ImageviewerState extends State<Imageviewer> {
  var ext;
  String filepath;
  bool _isLoading = true;
  File file;
  var name;
  var text;
  PDFViewController controller;
  int pages = 0;
  int indexPage = 0;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    var objfile;
    String fullurl;
    if (widget.doctype == "1") {
      if (widget.docfiles['document_upload'].length == 0) {
        filepath = "";
        fullurl = "";
      } else {
        setState(() {
          objfile = widget.docfiles['document_upload'][0];
          fullurl = domainname + '/storage/' + objfile['path'];
        });
      }
    } else if (widget.doctype == "2") {
      if (widget.docfiles['files'].length == 0) {
        filepath = "";
        fullurl = "";
      } else {
        setState(() {
          objfile = widget.docfiles['files'][0];
          fullurl = domainname + '/storage/' + objfile['path'];
        });
      }
    } else {
      if (widget.docfiles['document_upload'].length == 0) {
        filepath = "";
        fullurl = "";
      } else {
        setState(() {
          objfile = widget.docfiles['document_upload'][0];
          fullurl = domainname + '/storage/' + objfile['path'];
        });
      }
    }
    filepath = fullurl;
    if (filepath == "") {
      loademptyfile();
    } else {
      ext = p.extension(fullurl);
      if (ext == '.pdf') {
        loadDocument(fullurl);
      } else {
        //filepath = fullurl;
        name = p.basename(fullurl).toString();
      }
    }
  }

  loademptyfile() async {
    file = null;
    setState(() {
      _isLoading = false;
    });
  }

  loadDocument(value) async {
    file = await PDFApi.loadNetwork(value);
    name = basename(file.path);

    // mydocument = await PDFDocument.fromURL(value);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : file == null
                ? Center(
                    child: Text("មិនមានឯកសារ"),
                  )
                : Center(
                    child: viewallimage(),
                  ));
  }

  Widget viewallimage() {
    text = '${indexPage + 1} of $pages';
    return ext == '.pdf'
        ? Scaffold(
            appBar: AppBar(
              title: Text(name),
              actions: pages >= 2
                  ? [
                      Center(child: Text(text)),
                      IconButton(
                        icon: Icon(Icons.chevron_left, size: 32),
                        onPressed: () {
                          final page = indexPage == 0 ? pages : indexPage - 1;
                          controller.setPage(page);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.chevron_right, size: 32),
                        onPressed: () {
                          final page =
                              indexPage == pages - 1 ? 0 : indexPage + 1;
                          controller.setPage(page);
                        },
                      ),
                    ]
                  : null,
            ),
            body: PDFView(
              filePath: file.path,
              // autoSpacing: false,
              // swipeHorizontal: true,
              // pageSnap: false,
              // pageFling: false,
              onRender: (pages) => setState(() => this.pages = pages),
              onViewCreated: (controller) =>
                  setState(() => this.controller = controller),
              onPageChanged: (indexPage, _) =>
                  setState(() => this.indexPage = indexPage),
            ),
          )
        : Scaffold(
            appBar: AppBar(title: Text(name)),
            body: Center(
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Image.network(filepath))),
          );
  }
}
