class LoginModels {
  int code;
  String message;
  String accesstoken;
  String tokentype;
  var data;

  LoginModels(Map<String, dynamic> json){
      this.code = json['code'];
      this.message = json['message'];
      this.accesstoken = json['access_token'];
      this.tokentype = json['token_type'];
      this.data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> userobjdata = new Map<String, dynamic>();
    userobjdata['code'] = this.code;
    userobjdata['message'] = this.message;
    userobjdata['access_token']= this.accesstoken;
    userobjdata['token_type']= this.tokentype;
    userobjdata['data']= this.data;
    return userobjdata;
  }
}
