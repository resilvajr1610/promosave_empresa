import 'package:promosave_empresa/models/product_model.dart';

import '../Utils/export.dart';

class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  var _controllerPhone = TextEditingController();
  var _controllerAddress = TextEditingController();
  var _controllerStartHours = TextEditingController();
  var _controllerFinishHours = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String name="";
  String cnpj="";
  String email="";
  String phone="";
  String address="";
  String urlPhotoProfile="";
  String urlPhotoBanner="";
  String startHours="";
  String finishHours="";
  bool checkMonday=false;
  bool checkTuesday=false;
  bool checkWednesday=false;
  bool checkThursday=false;
  bool checkFriday=false;
  bool checkSaturday=false;
  bool checkSunday=false;
  File? picture;
  bool _sending = false;

  _dataEnterprise()async{
    DocumentSnapshot snapshot = await db.collection("enterprise")
        .doc(FirebaseAuth.instance.currentUser!.uid).get();

    Map<String,dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    setState(() {
      name = data?["name"];
      cnpj = data?["cpf"];
      email = data?["email"];
      phone = data?["phone"];
      address = data?["address"];
      urlPhotoProfile = data?["urlPhotoProfile"];
      urlPhotoBanner = data?["urlPhotoBanner"];
      startHours = data?["startHours"]??"";
      finishHours = data?["finishHours"]??"";
      checkMonday = data?["checkMonday"]??false;
      checkTuesday = data?["checkTuesday"]??false;
      checkWednesday = data?["checkWednesday"]??false;
      checkThursday = data?["checkThursday"]??false;
      checkFriday = data?["checkFriday"]??false;
      checkSaturday = data?["checkSaturday"]??false;
      checkSunday = data?["checkSunday"]??false;

      _controllerPhone = TextEditingController(text:phone);
      _controllerAddress = TextEditingController(text:address);
      _controllerStartHours = TextEditingController(text: startHours);
      _controllerFinishHours = TextEditingController(text: finishHours);
    });
  }

  Future _savePhoto(String name) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 100);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.picture = imageTemporary;
        setState(() {
          _sending = true;
        });
        _uploadImage(name);
      });
    } on PlatformException catch (e) {
      print('Error : $e');
    }
  }

  Future _uploadImage(String name) async {
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz.child("profile").child(name+"_"+DateTime.now().toString()+".jpg");

    UploadTask task = arquivo.putFile(picture!);

    Future.delayed(const Duration(seconds: 5), () async {
      String urlImage = await task.snapshot.ref.getDownloadURL();
      if (urlImage != null) {
        setState(() {
          if(name=='urlPhotoProfile'){
            urlPhotoProfile = urlImage;
            User? user = FirebaseAuth.instance.currentUser;
            user?.updatePhotoURL(urlPhotoProfile);
          }else{
            urlPhotoBanner = urlImage;
          }
        });
        _urlImageFirestore(urlImage,name);
      }
    });
  }

  _urlImageFirestore(String url,String name) {

    Map<String, dynamic> dateUpdate = {
      name: url,
    };

    db
        .collection("enterprise")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(dateUpdate)
        .then((value) {
          setState(() {
            _sending = false;
          });
    });
  }

  _saveData(){
    db.collection("enterprise").doc(FirebaseAuth.instance.currentUser!.uid).update({

    "phone"           :phone,
    "address"         :address,
    "startHours"      :_controllerStartHours.text,
    "finishHours"     :_controllerFinishHours.text,
    "checkMonday"     :checkMonday,
    "checkTuesday"    :checkTuesday,
    "checkWednesday"  :checkWednesday,
    "checkThursday"   :checkThursday,
    "checkFriday"     :checkFriday,
    "checkSaturday"   :checkSaturday,
    "checkSunday"     :checkSunday,

    }).then((_)
    => Navigator.pushReplacementNamed(context, "/splash"));
  }

  _verification(){

    if(_controllerStartHours.text.length==5){
      if (_controllerFinishHours.text.length==5) {
        if(_controllerPhone.text.length>10){
          if(_controllerAddress.text.isNotEmpty){

            _saveData();

          }else{
            setState(() {
              showSnackBar(context, 'verifique seu endereço', _scaffoldKey);
            });
          }
        }else{
          setState(() {
            showSnackBar(context, 'Verifique seu telefone',_scaffoldKey);
          });
        }
      } else {
        setState(() {
          showSnackBar(context,  'Verifique o horário de fechamento do estabelecimento',_scaffoldKey);
        });
      }
    }else{
      setState(() {
        showSnackBar(context, 'Verifique o horário de abertura do estabelecimento',_scaffoldKey);
      });
    }
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
      drawer: DrawerCustom(
        enterprise: FirebaseAuth.instance.currentUser!.displayName!,
        photo: FirebaseAuth.instance.currentUser!.photoURL,
      ),
      backgroundColor: PaletteColor.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: PaletteColor.primaryColor,
        title: TextCustom(text: 'Perfil',size: 24.0,color: PaletteColor.white,fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              urlPhotoProfile!=""? Padding(
                padding: const EdgeInsets.all(8.0),
                child:GestureDetector(
                  onTap: ()=>_savePhoto('urlPhotoProfile'),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: PaletteColor.grey,
                    backgroundImage: NetworkImage(urlPhotoProfile),
                  ),
                ),
              ):GestureDetector(
                onTap: ()=>_savePhoto('urlPhotoProfile'),
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: PaletteColor.greyInput
                  ),
                  child: Icon(Icons.camera_alt,color: PaletteColor.white,size: 50,),
                ),
              ),
              _sending==true?Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: PaletteColor.primaryColor),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextCustom(text: 'Enviando', size: 14.0, color: PaletteColor.primaryColor, fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
                  ),
                ],
              ):Container(),
              TextCustom(text: name.toUpperCase(), size: 14.0, color: PaletteColor.greyInput, fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
              TextCustom(text: 'CNPJ $cnpj', size: 14.0, color: PaletteColor.greyInput, fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
              TextCustom(text: email, size: 14.0, color: PaletteColor.greyInput, fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
              Container(
                  width: width,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(8),
                  child: TextCustom(text: 'Foto banner', size: 16.0, color: PaletteColor.grey, fontWeight: FontWeight.bold,textAlign: TextAlign.center,)
              ),
              urlPhotoBanner!=""?GestureDetector(
                onTap: ()=>_savePhoto('urlPhotoBanner'),
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  height: 90,
                  width: width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: PaletteColor.greyInput,
                      image: DecorationImage(
                      image: NetworkImage(urlPhotoBanner), fit: BoxFit.cover),
                  ),
                ),
              ): GestureDetector(
                onTap: ()=>_savePhoto('urlPhotoBanner'),
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  height: 90,
                  width: width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: PaletteColor.greyInput
                  ),
                  child: Icon(Icons.camera_alt,color: PaletteColor.white,size: 50,),
                ),
              ),
              Container(
                  width: width,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(8),
                  child: TextCustom(text: 'Horário de funcionamento:', size: 16.0, color: PaletteColor.grey, fontWeight: FontWeight.bold,textAlign: TextAlign.center,)
              ),
              Row(
                children: [
                  CheckDays(
                    check: checkMonday,
                    onChanged: (value){
                      setState(() {
                        checkMonday=value!;
                      });
                    }
                  ),
                  TextCustom(text: 'Seg',size: 14.0,color: PaletteColor.grey,fontWeight: FontWeight.normal,textAlign: TextAlign.center,),
                  CheckDays(
                      check: checkTuesday,
                      onChanged: (value){
                        setState(() {
                          checkTuesday=value!;
                        });
                      }
                  ),
                  TextCustom(text: 'Ter',size: 14.0,color: PaletteColor.grey,fontWeight: FontWeight.normal,textAlign: TextAlign.center,),
                  CheckDays(
                      check: checkWednesday,
                      onChanged: (value){
                        setState(() {
                          checkWednesday=value!;
                        });
                      }
                  ),
                  TextCustom(text: 'Qua',size: 14.0,color: PaletteColor.grey,fontWeight: FontWeight.normal,textAlign: TextAlign.center,),
                  CheckDays(
                      check: checkThursday,
                      onChanged: (value){
                        setState(() {
                          checkThursday=value!;
                        });
                      }
                  ),
                  TextCustom(text: 'Qui',size: 14.0,color: PaletteColor.grey,fontWeight: FontWeight.normal,textAlign: TextAlign.center,),
                ],
              ),
              Row(
                children: [
                  CheckDays(
                      check: checkFriday,
                      onChanged: (value){
                        setState(() {
                          checkFriday=value!;
                        });
                      }
                  ),
                  TextCustom(text: 'Sex',size: 14.0,color: PaletteColor.grey,fontWeight: FontWeight.normal,textAlign: TextAlign.center,),
                  CheckDays(
                      check: checkSaturday,
                      onChanged: (value){
                        setState(() {
                          checkSaturday=value!;
                        });
                      }
                  ),
                  TextCustom(text: 'Sáb',size: 14.0,color: PaletteColor.grey,fontWeight: FontWeight.normal,textAlign: TextAlign.center,),
                  CheckDays(
                      check: checkSunday,
                      onChanged: (value){
                        setState(() {
                          checkSunday=value!;
                        });
                      }
                  ),
                  TextCustom(text: 'Dom',size: 14.0,color: PaletteColor.grey,fontWeight: FontWeight.normal,textAlign: TextAlign.center,),
                ],
              ),
              Row(
                children: [
                  InputRegister(
                    icons: Icons.height,
                    sizeIcon: 0.0,
                    width: width*0.2,
                    controller: _controllerStartHours,
                    hint: '07:00',
                    fonts: 14.0,
                    keyboardType: TextInputType.number,
                    colorBorder: PaletteColor.greyLight,
                    background: PaletteColor.greyLight,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      HoraInputFormatter(),
                    ],
                  ),
                  TextCustom(text: 'ás',size: 14.0,color: PaletteColor.grey,fontWeight: FontWeight.normal,textAlign: TextAlign.center,),
                  InputRegister(
                    icons: Icons.height,
                    sizeIcon: 0.0,
                    width: width*0.2,
                    controller: _controllerFinishHours,
                    hint: '18:00',
                    fonts: 14.0,
                    keyboardType: TextInputType.number,
                    colorBorder: PaletteColor.greyLight,
                    background: PaletteColor.greyLight,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      HoraInputFormatter(),
                    ],
                  ),
                ],
              ),
              Container(
                width: width,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(8),
                child: TextCustom(text: 'Alterar dados :', size: 16.0, color: PaletteColor.grey, fontWeight: FontWeight.bold,textAlign: TextAlign.center,)
              ),
              Container(
                  width: width,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextCustom(text: 'Telefone', size: 14.0, color: PaletteColor.primaryColor, fontWeight: FontWeight.normal,textAlign: TextAlign.center,)
              ),
              InputRegister(
                icons: Icons.height,
                sizeIcon: 0.0,
                width: width*0.85,
                controller: _controllerPhone,
                hint: '(XX) XXXXX-XXXX',
                fonts: 14.0,
                keyboardType: TextInputType.number,
                colorBorder: PaletteColor.greyLight,
                background: PaletteColor.greyLight,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter()
                ],
              ),
              Container(
                  width: width,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                  child: TextCustom(text: 'Endereço', size: 14.0, color: PaletteColor.primaryColor, fontWeight: FontWeight.normal,textAlign: TextAlign.center,)
              ),
              InputRegister(
                icons: Icons.height,
                sizeIcon: 0.0,
                width: width*0.85,
                controller: _controllerAddress,
                hint: 'Rua, Avenida, etc',
                fonts: 14.0,
                keyboardType: TextInputType.text,
                colorBorder: PaletteColor.greyLight,
                background: PaletteColor.greyLight,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonCustom(
                  onPressed: ()=>_verification(),
                  heightCustom: 0.07,
                  widthCustom: 0.8,
                  text: phone!=""?"Atualizar":"Salvar",
                  size: 14.0,
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
