class BankModel{

  String bank="";
  int agency=0;
  int acount=0;
  int digit=0;

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "bank"    : this.bank,
      "agency"  : this.agency,
      "acount"  : this.acount,
      "digit"   : this.digit,
    };
    return map;
  }
}