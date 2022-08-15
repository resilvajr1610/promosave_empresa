import '../utils/export.dart';
import '../widgets/show_dialog_alert.dart';

class AlertModel{

  alert(String title, String content,final colorTextTitle, final colorTextContent, BuildContext context, List<Widget> listActions){
    showDialog(
        context: context,
        builder: (context) {

          return ShowDialogAlert(
              title: title,
              content: content,
              colorTextContent: colorTextContent,
              colorTextTitle: colorTextTitle,
              listActions: listActions
          );
        });
  }
}