import '../Utils/export.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({Key? key}) : super(key: key);

  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: PaletteColor.white,
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: height*0.03),
                SizedBox(
                  height: height*0.3,
                  width: height*0.3,
                  child:Image.asset("assets/image/logo_light.png"),
                ),
                SizedBox(height: height*0.1),
                ButtonCustom(
                    widthCustom: 0.75,
                    heightCustom: 0.07,
                    onPressed: ()=>Navigator.pushReplacementNamed(context, '/splash'),
                    text: 'Obrigado pelo seu cadastro! Entraremos em contato em até 24 horas para finalizá-lo.\nAtenciosamente,\n\nEquipe PromoSave.',
                    size: 20.0,
                    colorButton: PaletteColor.primaryColor,
                    colorText: PaletteColor.white,
                    colorBorder: PaletteColor.primaryColor
                )
              ],
            ),
          ),
        )
    );
  }
}
