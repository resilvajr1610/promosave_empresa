class UserModel{

  String idUser="";
  String name="";
  String email="";
  String cpf="";
  String phone="";
  String address="";
  String status="";
  String type="";
  double lat=0.0;
  double lng=0.0;
  String city="";
  String street="";
  String village="";
  DateTime? date;

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "idUser"  : this.idUser,
      "name"    : this.name,
      "email"   : this.email,
      "cpf"     : this.cpf,
      "phone"   : this.phone,
      "address" : this.address,
      "status"  : this.status,
      "lat"     : this.lat,
      "lng"     : this.lng,
      "city"    : this.city,
      "street"  : this.street,
      "village" : this.village,
      "type"    : this.type,
      "date"    : this.date,
    };
    return map;
  }
}