
class Document
{
  int id;
  String ordernumber;
  String organizationid;
  String receiverid;
  String documenttypeid;
  String documentstatusid;
  String submitterid;
  String isCommanderid;
  String arrivaldate;
  String isneednote;
  String objective;
  String createdat;
  String updatedat;
  String isneedreply;
  String documentrefcode;

  Document({this.ordernumber,this.organizationid,this.receiverid,this.documenttypeid,this.documentstatusid,
            this.submitterid,this.isCommanderid,this.arrivaldate,this.isneednote,this.objective,
            this.createdat,this.updatedat,this.isneedreply,this.documentrefcode});

   factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      ordernumber: json['order_number'],
      organizationid: json['organization_id'],
      receiverid: json['receiver_id'],
      documenttypeid: json['document_type_id'],
      documentstatusid : json['document_status_id'],
      submitterid: json['submitter_id'],
      isCommanderid:   json['isCommander_id'],
      arrivaldate: json['arrival_date'],
      isneednote: json['is_need_note'],
      objective: json['objective'],
      createdat: json['created_at'],
      updatedat: json['updated_at'],
      isneedreply: json['is_need_reply'],
      documentrefcode: json['document_ref_code']
    );
  }
}