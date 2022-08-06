import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:promosave_empresa/Utils/text_const.dart';

import '../Utils/colors.dart';
import '../Utils/export.dart';
import '../models/error_double_model.dart';

class FinanceScreen extends StatefulWidget {

  @override
  _FinanceScreenState createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  double totalFees = 0.0;
  double totalDiscount = 0.0;
  DocumentSnapshot? snapshot;
  int month = DateTime.now().month;
  int year = DateTime.now().year;
  var today = DateTime.now();
  final f = DateFormat('MMMM yyyy');

  _dataFees(var data)async{

     snapshot = await db.collection(data?["type"]==TextConst.DELIVERYMAN?"financeDelivery":'financeEnterprise').doc(FirebaseAuth.instance.currentUser!.uid).get();

    setState(() {

      totalFees = ErrorDoubleModel(snapshot,'totalFees${month}${year}');
      totalDiscount = ErrorDoubleModel(snapshot,'totalDiscount${month}${year}');

    });
  }

  _dataUser()async{
    DocumentSnapshot snapshot = await db.collection("enterprise")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    Map<String,dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    _dataFees(data);
  }

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'pt_BR';
    _dataUser();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: PaletteColor.white,
      drawer: DrawerCustom(
        enterprise: FirebaseAuth.instance.currentUser!.displayName!,
        photo: FirebaseAuth.instance.currentUser!.photoURL,
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: PaletteColor.primaryColor
        ),
        centerTitle: true,
        backgroundColor: PaletteColor.white,
        elevation: 0,
        title: Image.asset(
          'assets/image/logo_light.png',
          height: 60,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height*0.85,
          padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: TextCustom(text: 'Minhas Finanças',color: PaletteColor.grey,size: 16.0,fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
              ),
              SizedBox(height: 10),
              ContainerFinance(
                date: f.format(today),
                sales: totalFees,
                fees : totalDiscount,
                status: totalFees == 0.0
                    ?'': totalFees != 0.0 && ErrorStringModel(snapshot,'status${month}${year}')==''?'Pendente':'Pago',
                onTapNext: (){
                  setState(() {
                    today = today.add(Duration(days: 30));
                    month++;
                    if(month>12){
                      year++;
                      month=1;
                    }
                    totalFees = ErrorDoubleModel(snapshot,'totalFees${month}${year}');
                    totalDiscount = ErrorDoubleModel(snapshot,'totalDiscount${month}${year}');
                    print('$month $year');
                  });
                },
                onTapPrevius: (){
                 setState(() {
                   today = today.subtract(Duration(days: 30));
                   month--;
                   if(month<01){
                     year--;
                     month=12;
                   }
                   totalFees = ErrorDoubleModel(snapshot,'totalFees${month}${year}');
                   totalDiscount = ErrorDoubleModel(snapshot,'totalDiscount${month}${year}');
                   print('$month $year');
                 });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
