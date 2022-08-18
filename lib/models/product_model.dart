import 'package:cloud_firestore/cloud_firestore.dart';
export '../Utils/export.dart';

class ProductModel{

  String product="";
  String idProduct="";
  String idUser="";
  int available=0;
  String inPrice="";
  String byPrice="";
  String description="";
  int quantBag=0;

  ProductModel();

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "product"    : this.product,
      "idUser"    : this.idUser,
      "available"  : this.available,
      "inPrice"    : this.inPrice,
      "byPrice"    : this.byPrice,
      "description": this.description,
      "quantBag"   : this.quantBag,
      "idProduct"   : this.idProduct,
    };
    return map;
  }

  ProductModel.createId(){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference create = db.collection("products");
    this.idProduct = create.doc().id;
  }
}