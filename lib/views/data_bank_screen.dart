import '../Utils/export.dart';

class DataBankScreen extends StatefulWidget {

  @override
  _DataBankScreenState createState() => _DataBankScreenState();
}

class _DataBankScreenState extends State<DataBankScreen> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  final _controllerBank = TextEditingController();
  final _controllerAgency = TextEditingController();
  final _controllerAcount = TextEditingController();
  final _controllerDigit = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BankModel _bankModel = BankModel();
  String _error="";
  String name="";

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
    => Navigator.pushReplacementNamed(context, "/splash"));
  }

  _dataEnterprise()async{
    DocumentSnapshot snapshot = await db.collection("enterprise")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    Map<String,dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    setState(() {
      name = data?["name"];
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
      drawer: DrawerCustom(enterprise: name,photo: 'assets/image/logo.png',),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: PaletteColor.primaryColor,
        title: TextCustom(text: 'Dados bancários',size: 24.0,color: PaletteColor.white,fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
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
                child: TextCustom(text: 'Falta pouco, vamos cadastrar seus dados bancários!',color: PaletteColor.grey,size: 16.0,fontWeight: FontWeight.bold,textAlign: TextAlign.start,),
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
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextCustom(text: 'Conta',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start,),
                      ),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextCustom(text: 'Digito',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start,),
                      ),
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
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonCustom(
                  widthCustom: 0.8,
                  heightCustom: 0.07,
                  onPressed: ()=>_verification(),
                  text: "Salvar",
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
