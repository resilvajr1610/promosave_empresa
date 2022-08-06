import '../Utils/colors.dart';
import '../Utils/export.dart';

class ContainerFinance extends StatelessWidget {
  final date;
  final onTapPrevius;
  final onTapNext;
  final sales;
  final fees;
  final status;

  ContainerFinance({
    required this.date,
    required this.onTapPrevius,
    required this.onTapNext,
    required this.status,
    required this.sales,
    required this.fees,
});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onTapPrevius,
              child: Icon(Icons.arrow_left,color: PaletteColor.greyInput,size: 30,)),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: TextCustom(text: '$date',color: PaletteColor.primaryColor,size: 16.0,fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
            ),
            GestureDetector(
              onTap: onTapNext,
              child: Icon(Icons.arrow_right,color: PaletteColor.greyInput,size: 30)),
          ],
        ),
        SizedBox(height: 10),
        Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextCustom(text: 'Total de vendas',
                color: PaletteColor.grey,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start,),
              TextCustom(text: 'R\$ ${sales.toStringAsFixed(2).replaceAll('.',',')}',
                color: PaletteColor.green,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start,),
            ],
          ),
        ),
        Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextCustom(text: 'Taxas do app',
                color: PaletteColor.grey,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start,),
              TextCustom(text: '-R\$ ${fees.toStringAsFixed(2).replaceAll('.',',')}',
                color: PaletteColor.red,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start,),
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextCustom(text: 'Total a receber',
                color: PaletteColor.grey,size: 14.0,fontWeight: FontWeight.bold,textAlign: TextAlign.start,),
              TextCustom(text: 'R\$ ${(sales-fees).toStringAsFixed(2).replaceAll('.',',')}',
                color: PaletteColor.grey,size: 14.0,fontWeight: FontWeight.bold,textAlign: TextAlign.start,),
            ],
          ),
        ),
        SizedBox(height: 30),
        status==''?Container():Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: status=='Pendente'?PaletteColor.greyInput:PaletteColor.green
          ),
          child: TextCustom(text: status,
            color: PaletteColor.white,size: 14.0,fontWeight: FontWeight.bold,textAlign: TextAlign.start,),
        ),
      ],
    );
  }
}
