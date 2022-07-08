import '../Utils/colors.dart';
import '../Utils/export.dart';

class CnhScreen extends StatefulWidget {
  const CnhScreen({Key? key}) : super(key: key);

  @override
  _CnhScreenState createState() => _CnhScreenState();
}

class _CnhScreenState extends State<CnhScreen> {

  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _sending =false;
  String _urlPhotoCnh ="";
  String _urlPhotoProfile ="";
  File? picture;

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
    Reference arquivo = pastaRaiz.child("products").child(name+"_"+DateTime.now().toString()+".jpg");

    UploadTask task = arquivo.putFile(picture!);

    Future.delayed(const Duration(seconds: 5), () async {
      String urlImage = await task.snapshot.ref.getDownloadURL();
      if (urlImage != null) {
        setState(() {
          if(name == 'urlPhotoCnh'){
            _urlPhotoCnh = urlImage;
          }else{
            _urlPhotoProfile = urlImage;
          }
        });
        _urlImageFirestore(urlImage,name);
      }
    });
  }

  _urlImageFirestore(String url, String name) {

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

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: PaletteColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: PaletteColor.primaryColor,
        title: TextCustom(text: 'Cadastro',size: 24.0,color: PaletteColor.white,fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width,
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
            child: TextCustom(text: 'Fotos e documentos',
              color: PaletteColor.grey,size: 16.0,fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextCustom(text:'Foto da CNH',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.center,),
          ),
          _sending==false? GestureDetector(
            onTap: ()=>_savePhoto('urlPhotoCnh'),
            child: _urlPhotoCnh ==""?Container(
              margin: EdgeInsets.all(10),
              height: height*0.22,
              width: height*0.22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: PaletteColor.greyInput,
              ),
              child: Icon(Icons.camera_alt,color: PaletteColor.white,size: 50,),
            ):Container(
              width: height*0.22,
              height: height*0.22,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: PaletteColor.grey,
                  image: DecorationImage(
                      image: NetworkImage(_urlPhotoCnh), fit: BoxFit.cover)),
            ),
          ):Container(
            margin: EdgeInsets.all(10),
            height: height*0.22,
            width: height*0.22,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(color: PaletteColor.primaryColor),
                ),
                TextCustom(text: 'Enviando', size: 12.0, color: PaletteColor.primaryColor, fontWeight: FontWeight.normal, textAlign: TextAlign.center)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextCustom(text:'Foto do rosto',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.center,),
          ),
          _sending==false? GestureDetector(
            onTap: ()=>_savePhoto('urlPhotoProfile'),
            child: _urlPhotoProfile ==""?Container(
              margin: EdgeInsets.all(10),
              height: height*0.22,
              width: height*0.22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: PaletteColor.greyInput,
              ),
              child: Icon(Icons.camera_alt,color: PaletteColor.white,size: 50,),
            ):Container(
              width: height*0.22,
              height: height*0.22,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: PaletteColor.grey,
                  image: DecorationImage(
                      image: NetworkImage(_urlPhotoProfile), fit: BoxFit.cover)),
            ),
          ):Container(
            margin: EdgeInsets.all(10),
            height: height*0.22,
            width: height*0.22,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(color: PaletteColor.primaryColor),
                ),
                TextCustom(text: 'Enviando', size: 12.0, color: PaletteColor.primaryColor, fontWeight: FontWeight.normal, textAlign: TextAlign.center)
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: TextCustom(text:'Confira se as fotos estão nítidas.',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.center,),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonCustom(
                onPressed: (){
                  if(_urlPhotoCnh!="" && _urlPhotoProfile!=""){
                      Navigator.pushReplacementNamed(context, '/home_delivery');
                  }else{
                    showSnackBar(context, "Registre as duas fotos para serem avaliadas posteriormente", _scaffoldKey);
                  }
                },
                widthCustom: 0.75,
                heightCustom: 0.07,
                text:  'Cadastre-se',
                size: 14,
                colorButton: PaletteColor.primaryColor,
                colorText: PaletteColor.white,
                colorBorder: PaletteColor.primaryColor
            ),
          )
        ],
      ),
    );
  }
}
