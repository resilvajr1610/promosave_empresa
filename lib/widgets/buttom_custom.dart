import 'package:promosave_empresa/Utils/colors.dart';

import '../Utils/export.dart';

class ButtonCustom extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double size;
  final Color colorButton;
  final Color colorText;
  final Color colorBorder;
  final widthCustom;
  final heightCustom;

  ButtonCustom({
    required this.onPressed,
    required this.text,
    this.size = 30.0,
    this.colorButton = PaletteColor.primaryColor,
    this.colorText = PaletteColor.white,
    this.colorBorder = PaletteColor.primaryColor,
    this.widthCustom = 1.0,
    this.heightCustom = 1.0
  });

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: this.colorButton,
            minimumSize: Size(width*widthCustom!, height*heightCustom!),
            side: BorderSide(width: 3,color: colorBorder),
          ),
        onPressed: onPressed,
        child: Text(text,
            style: TextStyle(fontFamily: 'Nunito',color: colorText,fontSize: size,fontWeight: FontWeight.bold)
        )
    );
  }
}
