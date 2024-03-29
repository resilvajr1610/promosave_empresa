import 'package:promosave_empresa/models/product_model.dart';

import '../Utils/colors.dart';
import '../models/alert_model.dart';
import '../utils/export.dart';

class AddProductScreen extends StatefulWidget {
  final text;
  final buttonText;
  final id;

  AddProductScreen({required this.text, required this.buttonText,required this.id});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  var controllerDescription = TextEditingController();
  var controllerAvailable = TextEditingController();
  var controllerQuantBag = TextEditingController();
  var controllerPer = TextEditingController();
  var controllerIn = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List titleRadio=['Salgada','Doce','Mista'];
  String selectedText="Salgada";
  String _urlPhoto="";
  File? picture;
  bool _sending = false;
  int selectedRadioButton=0;
  ProductModel _productModel = ProductModel();
  Map<String,dynamic>? data;
  int products = 0;

  verification(){
    if(controllerDescription.text.isNotEmpty){
      if(controllerQuantBag.text.isNotEmpty){
        if(controllerIn.text.isNotEmpty){
          if(controllerPer.text.isNotEmpty){
            if(controllerAvailable.text.isNotEmpty){
                _saveFirebase();
            }else{
              showSnackBar(context,'Defina a quantidade de sacolas disponíveis ',_scaffoldKey);
            }
          }else{
            showSnackBar(context,'Defina o preço "Por" ',_scaffoldKey);
          }
        }else{
          showSnackBar(context,'Defina o preço "De" ',_scaffoldKey);
        }
      }else{
        showSnackBar(context,'Verifique a quantidade de alimentos na sacola',_scaffoldKey);
      }
    }else{
      showSnackBar(context,'Verifique a descrição',_scaffoldKey);
    }
  }

  _saveFirebase(){
    _productModel.idUser = FirebaseAuth.instance.currentUser!.uid;
    _productModel.product = selectedText;
    _productModel.available = int.parse(controllerAvailable.text);
    _productModel.inPrice = controllerIn.text;
    _productModel.byPrice = controllerPer.text;
    _productModel.description = controllerDescription.text;
    _productModel.quantBag =  int.parse(controllerQuantBag.text);

    if(widget.text == 'Alterar Produto'){
      _productModel.idProduct = widget.id;

      db.collection('enterprise').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'products' : products
      });

      db
          .collection("products")
          .doc(widget.id)
          .set(_productModel.toMap(),SetOptions(merge: true))
          .then((value)=>AlertModel().alert('Sucesso!', 'Seu Produtudo foi atualizado!', PaletteColor.green, PaletteColor.grey, context, [
        SizedBox(
          height: 30,
          width: 100,
          child: ButtonCustom(
            size: 15.0,
            onPressed: ()=> Navigator.pushReplacementNamed(context, '/home_enterprise'),
            text: 'OK',
          ),
        )
      ]));
    }else{
      print('id : ${_productModel.idProduct}');

      db.collection('enterprise').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'products' : products+1
      });

      db
          .collection("products")
          .doc(_productModel.idProduct)
          .set(_productModel.toMap(),SetOptions(merge: true))
          .then((value)=>AlertModel().alert('Sucesso!', 'Novo produto criado!', PaletteColor.green, PaletteColor.grey, context, [
        SizedBox(
          height: 30,
          width: 100,
          child: ButtonCustom(
            size: 15.0,
            onPressed: ()=> Navigator.pushReplacementNamed(context, '/home_enterprise'),
            text: 'OK',
          ),
        )
      ]));
    }
  }

  Future _savePhoto() async {
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
        _uploadImage();
      });
    } on PlatformException catch (e) {
      print('Error : $e');
    }
  }

  Future _uploadImage() async {
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz.child("products").child(selectedText+"_"+DateTime.now().toString()+".jpg");

    UploadTask task = arquivo.putFile(picture!);

    Future.delayed(const Duration(seconds: 5), () async {
      String urlImage = await task.snapshot.ref.getDownloadURL();
      if (urlImage != null) {
        setState(() {
          _urlPhoto = urlImage;
        });
        _urlImageFirestore(urlImage);
      }
    });
  }

  _urlImageFirestore(String url) {

    if(widget.id==''){
      Map<String, dynamic> dateUpdate = {
        'photoUrl': url,
        'idProduct' : _productModel.idProduct
      };

        db.collection("products")
          .doc(_productModel.idProduct)
          .set(dateUpdate)
          .then((value) {
        setState(() {
          _sending = false;
        });
      });
    }else{
      Map<String, dynamic> dateUpdate = {
        'photoUrl': url,
        'idProduct' : widget.id
      };

      db.collection("products")
          .doc(widget.id)
          .set(dateUpdate,SetOptions(merge: true))
          .then((value) {
        setState(() {
          _sending = false;
        });
      });
    }
  }

  _data()async{
    DocumentSnapshot snapshot = await db.collection('products').doc(widget.id).get();
    data = snapshot.data() as Map<String, dynamic>?;
    setState(() {
      controllerDescription = TextEditingController(text: data?['description']);
      controllerAvailable = TextEditingController(text: data?['available'].toString());
      controllerQuantBag = TextEditingController(text: data?['quantBag'].toString());
      controllerPer = TextEditingController(text: data?['byPrice']);
      controllerIn = TextEditingController(text: data?['inPrice']);
      _urlPhoto = data?['photoUrl']??'';
      selectedText = data?['product'];
      if(selectedText == 'Salgada'){
      setState(() {
        selectedRadioButton = 0;
      });
      }else if(selectedText == 'Doce'){
        setState(() {
          selectedRadioButton = 1;
        });
      }else{
        setState(() {
          selectedRadioButton = 2;
        });
      }
    });
  }

  _contProducts()async{
    DocumentSnapshot snapshot = await db.collection('enterprise').doc(FirebaseAuth.instance.currentUser!.uid).get();
    data = snapshot.data() as Map<String, dynamic>?;
    setState(() {
      products = data?['products']??0;
    });
  }

  @override
  void initState() {
    super.initState();
    _contProducts();
    if(widget.id==''){
      _productModel = ProductModel.createId();
    }
    if(widget.text == 'Alterar Produto'){
      _data();
    }
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    setSelectedRadio(int value){
      setState(() {
        selectedRadioButton = value;
        selectedText = titleRadio[value];
        print(selectedText);
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: PaletteColor.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: PaletteColor.primaryColor
        ),
        centerTitle: true,
        backgroundColor: PaletteColor.white,
        elevation: 0,
        title: Image.asset(
          'assets/image/logo_light.png',
          height: 60,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                  width: width,
                  child: TextCustom(
                    text: widget.text,color: PaletteColor.grey,size: 16.0,fontWeight: FontWeight.bold,textAlign: TextAlign.center
                  )
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  width: width,
                  child: TextCustom(
                      text: 'Tipo de sacola:',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: height*0.2,
                    width: width*0.6,
                    child: ListView.builder(
                        itemCount:titleRadio.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 35,
                            child: RadioListTile(
                              value: index,
                              groupValue: selectedRadioButton,
                              activeColor: PaletteColor.primaryColor,
                              title: Container(
                                  height: 20,
                                  margin: const EdgeInsets.only(top: 15.0),
                                  child: TextCustom(text: titleRadio[index],color: PaletteColor.grey,size: 16.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start)
                              ),
                              subtitle: Text(''),
                              onChanged: (value){
                                setSelectedRadio(int.parse(value.toString()));
                              },
                            ),
                          );
                        }
                    ),
                  ),
                  _sending==false? GestureDetector(
                    onTap: ()=>_savePhoto(),
                    child: _urlPhoto ==""?Container(
                      margin: EdgeInsets.only(right: 10),
                      height: height*0.15,
                      width: height*0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: PaletteColor.greyInput,
                      ),
                      child: Icon(Icons.camera_alt,color: PaletteColor.white,size: 40,),
                    ):Container(
                      width: height*0.15,
                      height: height*0.15,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: PaletteColor.grey,
                          image: DecorationImage(
                              image: NetworkImage(_urlPhoto), fit: BoxFit.cover)),
                    ),
                  ):Container(
                    margin: EdgeInsets.only(right: 10),
                    height: height*0.15,
                    width: height*0.15,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(color: PaletteColor.primaryColor),
                        ),
                        TextCustom(text: 'Enviando', size: 12.0, color: PaletteColor.primaryColor, fontWeight: FontWeight.normal, textAlign: TextAlign.center)
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  width: width,
                  child: TextCustom(
                      text: 'Descrição',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  )
              ),
              InputRegister(
                  controller: controllerDescription,
                  hint: 'Descreva o que pode conter na sacola',
                  fonts: 13.0,
                  keyboardType: TextInputType.text,
                  width: width*0.8,
                  sizeIcon: 0.0,
                  icons: Icons.camera_alt,
                  colorBorder: PaletteColor.greyLight,
                  background: PaletteColor.greyLight,
                  maxline: 3,
              ),
              SizedBox(height: 10),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  width: width,
                  child: TextCustom(
                      text: 'Quantidade de alimentos na sacola',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  )
              ),
              InputRegister(
                controller: controllerQuantBag,
                hint: '00',
                fonts: 13.0,
                keyboardType: TextInputType.number,
                width: width*0.8,
                sizeIcon: 0.0,
                icons: Icons.camera_alt,
                colorBorder: PaletteColor.greyLight,
                background: PaletteColor.greyLight,
                maxline: 1,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  width: width,
                  child: TextCustom(
                      text: 'Preço do produto',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  )
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                width: width,
                child: Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 30,
                          child: TextCustom(
                              text: 'De',color: PaletteColor.grey,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                          ),
                        ),
                        InputRegister(
                          controller: controllerIn,
                          hint: 'R\$ 00,00',
                          fonts: 13.0,
                          keyboardType: TextInputType.number,
                          width: width*0.25,
                          sizeIcon: 0.0,
                          icons: Icons.camera_alt,
                          colorBorder: PaletteColor.greyLight,
                          background: PaletteColor.greyLight,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CentavosInputFormatter(moeda: true),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Container(
                          width: 30,
                          child: TextCustom(
                              text: 'Por',color: PaletteColor.grey,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                          ),
                        ),
                        InputRegister(
                          controller: controllerPer,
                          hint: 'R\$ 00,00',
                          fonts: 13.0,
                          keyboardType: TextInputType.number,
                          width: width*0.25,
                          sizeIcon: 0.0,
                          icons: Icons.camera_alt,
                          colorBorder: PaletteColor.greyLight,
                          background: PaletteColor.greyLight,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CentavosInputFormatter(moeda: true),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  width: width,
                  child: TextCustom(
                      text: 'Quantidade de sacolas disponíveis',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  )
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: InputRegister(
                  controller: controllerAvailable,
                  hint: '00',
                  fonts: 13.0,
                  keyboardType: TextInputType.number,
                  width: width*0.3,
                  sizeIcon: 0.0,
                  icons: Icons.camera_alt,
                  colorBorder: PaletteColor.greyLight,
                  background: PaletteColor.greyLight,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: ButtonCustom(
                    onPressed: ()=> verification(),
                    widthCustom: 0.85,
                    heightCustom: 0.07,
                    text:  widget.buttonText,
                    size: 14,
                    colorButton: PaletteColor.primaryColor,
                    colorText: PaletteColor.white,
                    colorBorder: PaletteColor.primaryColor
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
