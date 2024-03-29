import 'package:promosave_empresa/models/product_model.dart';

import '../Utils/colors.dart';
import '../Utils/export.dart';
import '../models/alert_model.dart';

class DataBankScreen extends StatefulWidget {

  @override
  _DataBankScreenState createState() => _DataBankScreenState();
}

class _DataBankScreenState extends State<DataBankScreen> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  var _controllerBank = TextEditingController();
  var _controllerAgency = TextEditingController();
  var _controllerAcount = TextEditingController();
  var _controllerDigit = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BankModel _bankModel = BankModel();
  String _error="";

  _verification(){

    if(_controllerBank.text.isNotEmpty){
      if (_controllerAgency.text.length>2) {
        if(_controllerAcount.text.length>3){
          if(_controllerDigit.text.isNotEmpty){

            User user = FirebaseAuth.instance.currentUser!;
            final idUser = user.uid;

            _bankModel.bank = _controllerBank.text;
            _bankModel.agency = int.parse(_controllerAgency.text);
            _bankModel.acount = int.parse(_controllerAcount.text);
            _bankModel.digit = int.parse(_controllerDigit.text);

            _saveData(_bankModel,idUser);

          }else{
            setState(() {
              _error='Confira o digito';
              showSnackBar(context, _error, _scaffoldKey);
            });
          }
        }else{
          setState(() {
            _error = 'Confira o número da conta';
            showSnackBar(context, _error,_scaffoldKey);
          });
        }
      } else {
        setState(() {
          _error = "Confira o número da agência";
          showSnackBar(context, _error,_scaffoldKey);
        });
      }
    }else{
      setState(() {
        _error = "Confira o nome do banco";
        showSnackBar(context, _error,_scaffoldKey);
      });
    }
  }

  _saveData(BankModel bankModel,final idUser){
    db.collection("enterprise").doc(idUser).update(_bankModel.toMap()).then((_)
    => AlertModel().alert('Sucesso!', 'Seu seus dados foram atualizados!', PaletteColor.green, PaletteColor.grey, context,[
      SizedBox(
        height: 30,
        width: 100,
        child: ButtonCustom(
          size: 15.0,
          onPressed: ()=>  Navigator.pushReplacementNamed(context, "/splash"),
          text: 'OK',
        ),
      )
    ]));
  }

  _dataEnterprise()async{
    DocumentSnapshot snapshot = await db.collection("enterprise")
        .doc(FirebaseAuth.instance.currentUser!.uid).get();

    Map<String,dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    setState(() {
      final bank   = data?["bank"];
      final agency = data?["agency"];
      final acount = data?["acount"];
      final digit  = data?["digit"];
      _controllerBank = TextEditingController(text: bank.toString());
      _controllerAgency = TextEditingController(text: agency.toString());
      _controllerAcount = TextEditingController(text: acount.toString());
      _controllerDigit = TextEditingController(text: digit.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    _dataEnterprise();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: PaletteColor.white,
      drawer: DrawerCustom(
        enterprise: FirebaseAuth.instance.currentUser!.displayName!=null?FirebaseAuth.instance.currentUser!.displayName!:'',
        photo: FirebaseAuth.instance.currentUser!.photoURL,
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: PaletteColor.primaryColor
        ),
        centerTitle: true,
        backgroundColor: PaletteColor.white,
        elevation: 0,
        title: TextCustom(text: 'Dados bancários',size: 24.0,color: PaletteColor.primaryColor,fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height*0.85,
          padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: TextCustom(text: 'Alterar dados bancários!',color: PaletteColor.grey,size: 16.0,fontWeight: FontWeight.bold,textAlign: TextAlign.start,),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextCustom(text: 'A conta deve estar cadastrada em seu CPF.',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start,),
              ),
              SizedBox(height: 10),
              Container(
                width: width,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextCustom(text: 'Banco',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start,),
              ),
              InputRegister(
                icons: Icons.height,
                sizeIcon: 0.0,
                width: width*0.8,
                controller: _controllerBank,
                hint: 'Nome da instituição bancária',
                fonts: 14.0,
                keyboardType: TextInputType.text,
                colorBorder: PaletteColor.primaryColor,
                background: PaletteColor.white,
              ),
              SizedBox(height: 10),
              Container(
                width: width,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextCustom(text: 'Agência',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start,),
              ),
              InputRegister(
                icons: Icons.height,
                sizeIcon: 0.0,
                width: width*0.8,
                controller: _controllerAgency,
                hint: '0001',
                fonts: 14.0,
                keyboardType: TextInputType.number,
                colorBorder: PaletteColor.primaryColor,
                background: PaletteColor.white,
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(text: 'Conta',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start,),
                        InputRegister(
                          icons: Icons.height,
                          sizeIcon: 0.0,
                          width: width*0.55,
                          controller: _controllerAcount,
                          hint: '00000000',
                          fonts: 14.0,
                          keyboardType: TextInputType.number,
                          colorBorder: PaletteColor.primaryColor,
                          background: PaletteColor.white,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(text: 'Digito',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start,),
                        InputRegister(
                          icons: Icons.height,
                          sizeIcon: 0.0,
                          width: width*0.19,
                          controller: _controllerDigit,
                          hint: '1',
                          fonts: 14.0,
                          keyboardType: TextInputType.number,
                          colorBorder: PaletteColor.primaryColor,
                          background: PaletteColor.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonCustom(
                  widthCustom: 0.8,
                  heightCustom: 0.07,
                  onPressed: ()=>_verification(),
                  text: "Atualizar",
                  size: 14,
                  colorButton: PaletteColor.primaryColor,
                  colorText: PaletteColor.white,
                  colorBorder: PaletteColor.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
