import '../Utils/export.dart';

class CardHome extends StatelessWidget {

  final image;
  final inPrice;
  final byPrice;
  final product;
  final available;

  CardHome({
    required this.image,
    required this.inPrice,
    required this.byPrice,
    required this.product,
    required this.available,
});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Container(
        alignment: Alignment.bottomRight,
        height: 110,
        width: width*0.5,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(image),
            fit: BoxFit.cover
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(6),
          width: width,
            decoration: BoxDecoration(
              color: PaletteColor.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextCustom(fontWeight: FontWeight.bold,color: PaletteColor.grey, text: product, size: 12.0,textAlign: TextAlign.center,),
                Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(fontWeight: FontWeight.bold,color: PaletteColor.greyInput, text: '$available Disponíveis', size: 10.0,textAlign: TextAlign.center,),
                        TextCustom(fontWeight: FontWeight.bold,color: PaletteColor.greyInput, text: '', size: 10.0,textAlign: TextAlign.center,),
                      ],
                    ),
                    Spacer(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('de $inPrice',style: TextStyle(
                          decoration: TextDecoration.lineThrough,decorationColor: PaletteColor.grey,
                          fontFamily: 'Nunito',color: PaletteColor.grey,fontSize: 10.0,fontWeight: FontWeight.normal,)
                        ),
                        TextCustom(fontWeight: FontWeight.bold,color: PaletteColor.green, text: 'por $byPrice', size: 10.0,textAlign: TextAlign.center,),
                      ],
                    ),
                  ],
                ),
              ],
            )
        ),
      ),
    );
  }
}
