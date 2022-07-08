import '../Utils/colors.dart';
import '../Utils/export.dart';

class TitleDrawer extends StatelessWidget {
  IconData icon;
  final title;
  final onTap;

  TitleDrawer({required this.title,required this.icon,required this.onTap});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 3.0,horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon,color: PaletteColor.grey),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title,style: TextStyle(color: PaletteColor.grey,fontSize: 14,fontFamily: 'Barlow'),),
                )
              ],
            ),
            Divider(color: PaletteColor.greyLight,thickness: 1)
          ],
        ),
      ),
    );
  }
}
