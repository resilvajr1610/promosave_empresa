import '../Utils/export.dart';

class InputRegister extends StatelessWidget {

  final controller;
  final hint;
  final fonts;
  final keyboardType;
  final width;
  List<TextInputFormatter>? inputFormatters=[];
  final sizeIcon;
  final icons;
  final colorBorder;
  final background;
  int? maxline = 1;

  InputRegister({
    required this.controller,
    required this.hint,
    required this.fonts,
    required this.keyboardType,
    required this.width,
    this.inputFormatters,
    this.maxline,
    required this.sizeIcon,
    required this.icons,
    required this.colorBorder,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      alignment: Alignment.topCenter,
      width: this.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: colorBorder)
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: this.controller,
              textAlign: TextAlign.start,
              keyboardType: this.keyboardType,
              textAlignVertical: TextAlignVertical.center,
              maxLines: maxline,
              style: TextStyle(
                color: Colors.black54,
                fontSize: this.fonts,
              ),
              inputFormatters:this.inputFormatters,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: this.hint,
                  hintStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: this.fonts,
                  ),
              ),
            ),
          ),
          Icon(icons,size: sizeIcon),
        ],
      ),
    );
  }
}
