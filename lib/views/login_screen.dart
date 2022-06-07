import '../Utils/export.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  bool visibiblePassword = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _error="";

  _signFirebase()async{

    if (_controllerEmail.text.isNotEmpty) {
      setState(() {
        _error = "";
      });

      try{
        await _auth.signInWithEmailAndPassword(
            email: _controllerEmail.text.trim(),
            password: _controllerPassword.text.trim()
        ).then((auth)async{
          Navigator.pushReplacementNamed(context, "/splash");
        });
      }on FirebaseAuthException catch (e) {
        if(e.code =="unknown"){
          setState(() {
            _error = "A senha está vazia!";
            showSnackBar(context, _error,_scaffoldKey);
          });
        }else if(e.code =="invalid-email"){
          setState(() {
            _error = "Digite um e-mail válido!";
            showSnackBar(context, _error,_scaffoldKey);
          });
        }else{
          setState(() {
            _error = e.code;
            showSnackBar(context, _error,_scaffoldKey);
          });
        }
      }
    } else {
      setState(() {
        _error = "Preencha seu email";
        showSnackBar(context, _error,_scaffoldKey);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: PaletteColor.white,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height*0.03),
                SizedBox(
                  height: height*0.3,
                  width: height*0.3,
                  child:Image.asset("assets/image/logo_light.png"),
                ),
                SizedBox(height: height*0.02),
                TextCustom(
                    text: 'BEM VINDO!',
                    size: 16.0,
                    color: PaletteColor.grey,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                ),
                SizedBox(height: height*0.02),
                TextCustom(
                    text:'“Juntos contra o desperdício”',
                    size: 16.0,
                    color: PaletteColor.grey,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                ),
                SizedBox(height: height*0.06),
                Container(
                  alignment: Alignment.centerLeft,
                  width: width*0.8,
                  child: TextCustom(text: 'E - mail',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.center,),
                ),
                InputRegister(
                  icons: Icons.height,
                  sizeIcon: 0.0,
                  width: width*0.8,
                  controller: _controllerEmail,
                  hint:'E - mail',
                  fonts: 14.0,
                  keyboardType: TextInputType.text,
                  colorBorder: PaletteColor.greyLight,
                  background: PaletteColor.greyLight,
                ),
                SizedBox(height: height*0.02),
                Container(
                  alignment: Alignment.centerLeft,
                  width: width*0.8,
                  child: TextCustom(text: 'Senha',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.center,),
                ),
                InputPassword(
                  showPassword: visibiblePassword,
                  icons: Icons.height,
                  colorIcon: Colors.white,
                  width: width*0.8,
                  obscure: visibiblePassword,
                  controller: _controllerPassword,
                  hint: 'Senha',
                  fonts: 14,
                  keyboardType: TextInputType.visiblePassword,
                  onPressed: (){
                    setState(() {
                      if(visibiblePassword==false){
                        visibiblePassword=true;
                      }else{
                        visibiblePassword=false;
                      }
                    });
                  },
                ),
                SizedBox(height: height*0.03),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonCustom(
                    widthCustom: 0.75,
                    heightCustom: 0.07,
                    onPressed:()=>_signFirebase(),
                    text: "Entrar",
                    size: 14,
                    colorButton: PaletteColor.primaryColor,
                    colorText: PaletteColor.white,
                    colorBorder:PaletteColor.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
