import 'package:promosave_empresa/models/product_model.dart';

import '../Utils/colors.dart';
import '../utils/export.dart';

class ShowDialogAlert extends StatelessWidget {

  final String title;
  final colorTextTitle;
  final colorTextContent;
  final String content;
  List<Widget> listActions;

  ShowDialogAlert({
    required this.title,
    required this.content,
    required this.listActions,
    this.colorTextTitle = Colors.red,
    this.colorTextContent = Colors.red,
});

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return AlertDialog(
      title: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: width*0.4,
            height: height*0.05,
            child: TextCustom(text: title,color: colorTextTitle,size: 18.0,fontWeight: FontWeight.bold,)
          ),
        ],
      ),
      titleTextStyle: TextStyle(color: PaletteColor.primaryColor,fontSize: 15),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            width: width*0.4,
            height: height*0.15,
            child: TextCustom(
              textAlign: TextAlign.center,
              text: content,
              color: colorTextContent,
              maxLines: 5,
              size: 15.0,
            ),
          ),
          SizedBox(
            height: height*0.1*listActions.length,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: listActions,
            ),
          )
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      // actions: listActions,
    );
  }
}
