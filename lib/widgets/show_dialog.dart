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

    final width = MediaQuery.of(context).size.width;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextCustom(
            text: 'Estabelecimento : $enterprise',
            size: 13.0,
            color: PaletteColor.grey,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.start,
          ),
          Container(
            width: width*0.7,
            child: TextCustom(
              text: 'Endereço : $enterpriseAddress',
              size: 13.0,
              color: PaletteColor.grey,
              fontWeight: FontWeight.normal,
              textAlign: TextAlign.start,
              maxLines: 3,
            ),
          ),
          TextCustom(
            text: 'Cliente : $client',
            size: 13.0,
            color: PaletteColor.grey,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.start,
          ),
          TextCustom(
            text:'Local entrega : $clientAddress',
            size: 13.0,
            color: PaletteColor.grey,
            fontWeight: FontWeight.normal,
            textAlign: TextAlign.start,
          ),
          TextCustom(
            text: 'Taxa de entrega : $shipping',
            size: 13.0,
            color: PaletteColor.grey,
            fontWeight: FontWeight.normal,
            textAlign: TextAlign.center,
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
