import '../Utils/export.dart';

class TextCustom extends StatelessWidget {

  final text;
  final size;
  final color;
  final fontWeight;
  final textAlign;
  final maxLines;

  TextCustom({
    required this.text,
    this.size = 16.0,
    required this.color,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.start,
    this.maxLines=2
  });

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
