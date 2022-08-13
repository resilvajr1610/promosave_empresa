import 'package:promosave_empresa/models/product_model.dart';

import '../Utils/colors.dart';
import '../Utils/export.dart';
import '../Utils/text_const.dart';

class ContainerRequestsEnterprise extends StatelessWidget {

  final onTapIcon;
  final onTapButtom;
  final showDetailsRequests;
  final idRequests;
  final contMixed;
  final priceMixed;
  final contSalt;
  final priceSalt;
  final int contSweet;
  final priceSweet;
  final date;
  final textButton;
  final client;
  final enterprise;
  final type;
  final screen;
  final typeDelivery;
  final double totalFees;
  final double ratingDouble;
  final String ratingText;

  ContainerRequestsEnterprise({
    required this.onTapIcon,
    required this.onTapButtom,
    required this.showDetailsRequests,
    required this.idRequests,
    required this.date,
    required this.client,
    required this.enterprise,
    required this.contMixed,
    required this.priceMixed,
    required this.contSalt,
    required this.priceSalt,
    required this.contSweet,
    required this.priceSweet,
    required this.textButton,
    required this.type,
    required this.screen,
    required this.typeDelivery,
    required this.totalFees,
    this.ratingDouble = 0.0,
    this.ratingText = '',
  });

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        GestureDetector(
          onTap: onTapIcon,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4),
                width: width*0.45,
                child: TextCustom(
                    text: 'Pedido n° $idRequests',color: PaletteColor.grey,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                ),
              ),
              Spacer(),
              Container(
                width: width*0.35,
                child: TextCustom(
                    text: '$date',color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                ),
              ),
              GestureDetector(
                onTap: onTapIcon,
                child: Icon(
                    showDetailsRequests==true
                        ?Icons.arrow_drop_down:Icons.arrow_right,
                    size: 30,color: PaletteColor.greyInput
                )
              )
            ],
          ),
        ),
        showDetailsRequests==true ?Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4,vertical: 5),
              width: width,
              child: TextCustom(
                  text: 'Cliente : '+client,color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
              ),
            ),
            typeDelivery!= TextConst.DELIVERYMAN?Container():Container(
              padding: EdgeInsets.symmetric(horizontal: 4,vertical: 5),
              width: width,
              child: TextCustom(
                  text: 'Estabelecimento : '+enterprise,color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
              ),
            ),
            contMixed!=0 && typeDelivery!= TextConst.DELIVERYMAN?Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  width: width*0.45,
                  child: TextCustom(
                      text: '$contMixed x Sacola mista',color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  ),
                ),
                Spacer(),
                Container(
                  child: TextCustom(
                      text: 'R\$ ${(contMixed*priceMixed).toStringAsFixed(2).replaceAll('.', ',')}',color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  ),
                ),
              ],
            ):Container(),
            contSalt !=0 && typeDelivery!= TextConst.DELIVERYMAN?Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  width: width*0.45,
                  child: TextCustom(
                      text: '$contSalt x Sacola salgada',color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  ),
                ),
                Spacer(),
                Container(
                  child: TextCustom(
                      text: 'R\$ ${(contSalt*priceSalt).toStringAsFixed(2).replaceAll('.', ',')}',color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  ),
                ),
              ],
            ):Container(),
            contSweet!=0 && typeDelivery!= TextConst.DELIVERYMAN? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  width: width*0.45,
                  child: TextCustom(
                      text: '$contSweet x Sacola Doce',color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  ),
                ),
                Spacer(),
                Container(
                  child: TextCustom(
                      text: 'R\$ ${(contSweet*priceSweet).toStringAsFixed(2).replaceAll('.', ',')}',color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  ),
                ),
              ],
            ):Container(),
            screen !='history'?Container(
              padding: EdgeInsets.symmetric(horizontal: 4,vertical: 5),
              width: width,
              child: TextCustom(
                  text: type,color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.bold,textAlign: TextAlign.start
              ),
            ):Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4,vertical: 5),
                  width: width*0.45,
                  child: TextCustom(
                      text: typeDelivery!= TextConst.DELIVERYMAN?'Total':'Taxa de entrega',color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.bold,textAlign: TextAlign.start
                  ),
                ),
                Spacer(),
                Container(
                  child: typeDelivery!= TextConst.DELIVERYMAN
                      ?TextCustom(
                        text: 'R\$ ${((contSalt*priceSalt) + (contSweet*priceSweet) + (contMixed*priceMixed)).toStringAsFixed(2).replaceAll('.', ',')}',color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.bold,textAlign: TextAlign.start
                      )
                      :TextCustom(
                      text: 'R\$ ${totalFees.toStringAsFixed(2).replaceAll('.', ',')}',color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.bold,textAlign: TextAlign.start
                  ),
                ),
              ],
            ),
            screen !='history'? Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 45),
              child: textButton != 'A caminho'? ButtonCustom(
                  onPressed:onTapButtom,
                  widthCustom: 0.15,
                  heightCustom: 0.05,
                  text:  textButton,
                  size: 12,
                  colorButton: PaletteColor.primaryColor,
                  colorText: PaletteColor.white,
                  colorBorder: PaletteColor.primaryColor
              ):TextCustom(text: textButton,size: 12.0,color: PaletteColor.primaryColor,fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
            ):Container(),
            screen =='history' && typeDelivery!= TextConst.DELIVERYMAN?Container(
              margin: EdgeInsets.only(right: 42),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4,vertical: 5),
                        width: width*0.45,
                        child: TextCustom(
                            text: 'Avalição do cliente',color: PaletteColor.grey,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                        ),
                      ),
                      Spacer(),
                      RatingCustom(rating: ratingDouble)
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    width: width,
                    child: TextCustom(
                        text: 'Comentário do cliente',color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4,vertical: 5),
                    width: width,
                    child: TextCustom(
                      text: ratingText.toUpperCase(),
                      color: PaletteColor.grey,
                      size: 10.0,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.start,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ):Container()
          ],
        ):Container(),
        Divider(color: PaletteColor.greyInput),
      ],
    );
  }
}
