import '../Utils/colors.dart';
import '../Utils/export.dart';

class ShowDialog extends StatelessWidget {

  final String idRequest;
  final String date;
  final String enterprise;
  final String enterpriseAddress;
  final String client;
  final String clientAddress;
  final String shipping;
  final List<Widget> list;

  ShowDialog({
    required this.idRequest,
    required this.date,
    required this.enterprise,
    required this.enterpriseAddress,
    required this.client,
    required this.clientAddress,
    required this.shipping,
    required this.list,
});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextCustom(
            text: 'Pedido n° '+ idRequest,
            size: 13.0,
            color: PaletteColor.grey,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
          TextCustom(
            text: date,
            size: 13.0,
            color: PaletteColor.grey,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
        ],
      )),
      titleTextStyle: TextStyle(color: PaletteColor.grey,fontSize: 14),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              TextCustom(
                text: enterprise,
                size: 13.0,
                color: PaletteColor.grey,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              TextCustom(
                text:' - '+ enterpriseAddress,
                size: 13.0,
                color: PaletteColor.grey,
                fontWeight: FontWeight.normal,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Row(
            children: [
              TextCustom(
                text: client,
                size: 13.0,
                color: PaletteColor.grey,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              TextCustom(
                text:' - '+ clientAddress,
                size: 13.0,
                color: PaletteColor.grey,
                fontWeight: FontWeight.normal,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextCustom(
                text: 'Taxa de entrega',
                size: 13.0,
                color: PaletteColor.grey,
                fontWeight: FontWeight.normal,
                textAlign: TextAlign.center,
              ),
              TextCustom(
                text:shipping,
                size: 13.0,
                color: PaletteColor.grey,
                fontWeight: FontWeight.normal,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 5,vertical: 0),
      actionsAlignment: MainAxisAlignment.center,
      titlePadding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
      actions: this.list,
    );
  }
}
