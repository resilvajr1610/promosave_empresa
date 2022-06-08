import 'package:promosave_empresa/models/product_model.dart';

import '../Utils/export.dart';

class ContainerDelivery extends StatelessWidget {
  final photo;
  final enterprise;
  final address;
  final shipping;
  final onTap;

  ContainerDelivery({
    required this.photo,
    required this.enterprise,
    required this.address,
    required this.shipping,
    required this.onTap,
});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: PaletteColor.greyLight,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: photo==null ? CircleAvatar(
                        backgroundColor: PaletteColor.primaryColor,
                        backgroundImage: AssetImage('assets/image/logo.png')
                    ):CircleAvatar(
                      backgroundColor: PaletteColor.primaryColor,
                      backgroundImage: NetworkImage(photo),
                    ),
                  ),
                  TextCustom(
                    text: enterprise,
                    size: 12.0,
                    color: PaletteColor.grey,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start,
                  ),
                  Spacer(),
                  TextCustom(
                    text: shipping,
                    size: 12.0,
                    color: PaletteColor.grey,
                    fontWeight: FontWeight.normal,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                width: width,
                child: TextCustom(
                  text: 'Para : '+address,
                  size: 12.0,
                  color: PaletteColor.grey,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
