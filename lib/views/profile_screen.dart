import 'package:google_place/google_place.dart';
import '../Utils/colors.dart';
import '../Utils/text_const.dart';
import '../models/alert_model.dart';
import '../utils/export.dart';

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
  String type="";
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
  String city="";
  String village="";
  String street="";
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions=[];
  String apikey='AIzaSyBrOfzJKgCwsbPxmc9cSQ6DptcQvluZQFQ';
  var result;
  Timer? _debounce;
  DetailsResult? startPosition;
  late FocusNode? startFocusNode;
  double lat = 0.0;
  double lng = 0.0;

  void autoCompleteSearch(String value)async{
    result = await googlePlace.autocomplete.get(value);
    if(result!= null && result.predictions !=null && mounted){
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  _dataEnterprise()async{
    DocumentSnapshot snapshot = await db.collection("enterprise")
        .doc(FirebaseAuth.instance.currentUser!.uid).get();

    Map<String,dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    setState(() {
      type = data?["type"];
      name = data?["name"];
      cnpj = data?["cpf"];
      email = data?["email"];
      phone = data?["phone"];
      address = data?["address"];
      urlPhotoProfile = data?["urlPhotoProfile"]??'';
      urlPhotoBanner = data?["urlPhotoBanner"]??"";
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

  Future _savePhoto(String name,String type) async {
    final image;
    try {
      if(type=='camera'){
        image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 100);
      }else{
        image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
      }
      if (image == null) return;

      Navigator.of(context).pop();

      final imageTemporary = File(image.path);
      setState(() {
        this.picture = imageTemporary;
        setState(() {
          urlPhotoProfile='';
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
      "phone"           :_controllerPhone.text,
      "address"         :_controllerAddress.text,
      "street"          :street,
      "village"         :village,
      "city"            :city,
      "lat"             :lat,
      "lng"             :lng,
      "startHours"      :_controllerStartHours.text,
      "finishHours"     :_controllerFinishHours.text,
      "checkMonday"     :checkMonday,
      "checkTuesday"    :checkTuesday,
      "checkWednesday"  :checkWednesday,
      "checkThursday"   :checkThursday,
      "checkFriday"     :checkFriday,
      "checkSaturday"   :checkSaturday,
      "checkSunday"     :checkSunday,
    }).then((value){
      if(type==TextConst.ENTERPRISE){
        db.collection('cities').doc(city).set({
          "city":city,
        }).then((value) => Navigator.pushReplacementNamed(context, "/splash"));
      }else{
        Navigator.pushReplacementNamed(context, "/splash");
      }
    });
  }

  _verification(){

    if(type==TextConst.ENTERPRISE? _controllerStartHours.text.length==5:_controllerStartHours.text.isEmpty){
      if (type==TextConst.ENTERPRISE? _controllerFinishHours.text.length==5:_controllerFinishHours.text.isEmpty) {
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
    googlePlace = GooglePlace(apikey);
    startFocusNode=FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    startFocusNode?.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerCustom(
        enterprise: FirebaseAuth.instance.currentUser!.displayName!=null?FirebaseAuth.instance.currentUser!.displayName!:'',
        photo: FirebaseAuth.instance.currentUser!.photoURL,
      ),
      backgroundColor: PaletteColor.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: PaletteColor.primaryColor
        ),
        centerTitle: true,
        backgroundColor: PaletteColor.white,
        elevation: 0,
        title: TextCustom(text: 'Perfil',size: 24.0,color: PaletteColor.primaryColor,fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              urlPhotoProfile!="" ? Padding(
                padding: const EdgeInsets.all(8.0),
                child:GestureDetector(
                  onTap: ()=>AlertModel().alert('Perfil !', 'Escolha uma opção para \nselecionar sua foto', PaletteColor.grey, PaletteColor.grey, context,
                    [
                      ButtonCustom(
                        onPressed: () => _savePhoto('urlPhotoProfile','camera'),
                        text: 'Câmera',
                        colorBorder: PaletteColor.greyInput,
                        colorButton: PaletteColor.greyInput,
                        colorText: PaletteColor.white,
                        size: 14.0,
                        heightCustom: 0.07,
                        widthCustom: 0.7,
                      ),
                      ButtonCustom(
                        onPressed: () => _savePhoto('urlPhotoProfile','gallery'),
                        text: 'Galeria',
                        colorBorder: PaletteColor.greyInput,
                        colorButton: PaletteColor.greyInput,
                        colorText: PaletteColor.white,
                        size: 14.0,
                        heightCustom: 0.07,
                        widthCustom: 0.7,
                      ),
                    ]),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: PaletteColor.grey,
                    backgroundImage: NetworkImage(urlPhotoProfile),
                  ),
                ),
              ):GestureDetector(
                onTap: ()=>AlertModel().alert('Perfil !', 'Escolha uma opção para \nselecionar sua foto', PaletteColor.grey, PaletteColor.grey, context,
                  [
                    ButtonCustom(
                      onPressed: () => _savePhoto('urlPhotoProfile','camera'),
                      text: 'Câmera',
                      colorBorder: PaletteColor.greyInput,
                      colorButton: PaletteColor.greyInput,
                      colorText: PaletteColor.white,
                      size: 14.0,
                      heightCustom: 0.07,
                      widthCustom: 0.7,
                    ),
                    ButtonCustom(
                      onPressed: () => _savePhoto('urlPhotoProfile','gallery'),
                      text: 'Galeria',
                      colorBorder: PaletteColor.greyInput,
                      colorButton: PaletteColor.greyInput,
                      colorText: PaletteColor.white,
                      size: 14.0,
                      heightCustom: 0.07,
                      widthCustom: 0.7,
                    ),
                  ]),
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
              type==TextConst.ENTERPRISE?TextCustom(text: 'CNPJ $cnpj', size: 14.0, color: PaletteColor.greyInput, fontWeight: FontWeight.bold,textAlign: TextAlign.center,):Container(),
              TextCustom(text: email, size: 14.0, color: PaletteColor.greyInput, fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
              type==TextConst.ENTERPRISE?Column(
                children: [
                  Container(
                      width: width,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(8),
                      child: TextCustom(text: 'Foto banner', size: 16.0, color: PaletteColor.grey, fontWeight: FontWeight.bold,textAlign: TextAlign.center,)
                  ),
                  urlPhotoBanner!=""?GestureDetector(
                    onTap: ()=>AlertModel().alert('Perfil !', 'Escolha uma opção para \nselecionar sua foto', PaletteColor.grey, PaletteColor.grey, context,
                        [
                          ButtonCustom(
                            onPressed: () => _savePhoto('urlPhotoBanner','camera'),
                            text: 'Câmera',
                            colorBorder: PaletteColor.greyInput,
                            colorButton: PaletteColor.greyInput,
                            colorText: PaletteColor.white,
                            size: 14.0,
                            heightCustom: 0.07,
                            widthCustom: 0.7,
                          ),
                          ButtonCustom(
                            onPressed: () => _savePhoto('urlPhotoBanner','gallery'),
                            text: 'Galeria',
                            colorBorder: PaletteColor.greyInput,
                            colorButton: PaletteColor.greyInput,
                            colorText: PaletteColor.white,
                            size: 14.0,
                            heightCustom: 0.07,
                            widthCustom: 0.7,
                          ),
                        ]),
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
                    onTap: ()=>AlertModel().alert('Perfil !', 'Escolha uma opção para \nselecionar sua foto', PaletteColor.grey, PaletteColor.grey, context,
                        [
                          ButtonCustom(
                            onPressed: () => _savePhoto('urlPhotoBanner','camera'),
                            text: 'Câmera',
                            colorBorder: PaletteColor.greyInput,
                            colorButton: PaletteColor.greyInput,
                            colorText: PaletteColor.white,
                            size: 14.0,
                            heightCustom: 0.08,
                            widthCustom: 0.7,
                          ),
                          ButtonCustom(
                            onPressed: () => _savePhoto('urlPhotoBanner','gallery'),
                            text: 'Galeria',
                            colorBorder: PaletteColor.greyInput,
                            colorButton: PaletteColor.greyInput,
                            colorText: PaletteColor.white,
                            size: 14.0,
                            heightCustom: 0.08,
                            widthCustom: 0.7,
                          ),
                        ]),
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
                ],
              ):Container(),
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
              Container(
                alignment: Alignment.topCenter,
                width: width*0.9,
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                decoration: BoxDecoration(
                    color: PaletteColor.greyLight,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: PaletteColor.greyLight,)
                ),
                child: TextFormField(
                  controller: _controllerAddress,
                  focusNode: startFocusNode,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.text,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14.0,
                  ),
                  onChanged:(value){
                    if(value.isNotEmpty){
                      autoCompleteSearch(value);
                    }
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Rua, Avenida, etc',
                    hintStyle: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: predictions.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      leading: Icon(Icons.location_on,color: PaletteColor.primaryColor,),
                      title: Text(predictions[index].description.toString()),
                      onTap: ()async{
                        final placeId = predictions[index].placeId;
                        final details = await googlePlace.details.get(placeId!);
                        if(details!=null && details.result !=null && mounted){
                          setState(() {
                            startPosition = details.result;
                            _controllerAddress.text = details.result!.name!;
                            lat = startPosition!.geometry!.location!.lat!;
                            lng = startPosition!.geometry!.location!.lng!;
                            final completeAddress = startPosition!.adrAddress!;
                            final splittedStart = completeAddress.split('>');
                            street = splittedStart[1].replaceAll('</span', '');
                            village = splittedStart[3].replaceAll('</span', '');
                            city = splittedStart[5].replaceAll('</span', '');

                            print("Street :     " + street.toString());
                            print("village :  " + village);
                            print("city :    " + city);
                            predictions=[];
                          });
                        }
                      },
                    );
              }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonCustom(
                  onPressed: ()=>_verification(),
                  heightCustom: 0.07,
                  widthCustom: 0.9,
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
