class UserModel{

  String idUser="";
  String name="";
  String email="";
  String cpf="";
  String phone="";
  String address="";
  String status="";
  String type="";

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "idUser"  : this.idUser,
      "name"    : this.name,
      "email"   : this.email,
      "cpf"     : this.cpf,
      "phone"   : this.phone,
      "address" : this.address,
      "status"  : this.status,
      "type"    : this.type,
    };
    return map;
  }
}