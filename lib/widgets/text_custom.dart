import '../Utils/export.dart';

class TextCustom extends StatelessWidget {

  final text;
  final size;
  final color;
  final fontWeight;
  final textAlign;
  int? maxLines=2;

  TextCustom({required this.text, required this.size,required this.color,required this.fontWeight, required this.textAlign,this.maxLines});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(text,
        textAlign: textAlign,
        style: TextStyle(fontFamily: 'Nunito',color: color,fontSize: size,fontWeight: fontWeight,),
        minFontSize: 10,
        maxLines: maxLines,
    );
  }
}
