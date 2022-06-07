import '../Utils/export.dart';

class FinanceScreen extends StatefulWidget {

  @override
  _FinanceScreenState createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  String name="";

  _dataEnterprise()async{
    DocumentSnapshot snapshot = await db.collection("enterprise")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    Map<String,dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    setState(() {
      name = data?["name"];
    });
  }

  @override
  void initState() {
    super.initState();
    _dataEnterprise();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: PaletteColor.white,
      drawer: DrawerCustom(enterprise: name,photo: 'assets/image/logo.png',),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: PaletteColor.primaryColor,
        title: TextCustom(text: 'Quem Somos',size: 24.0,color: PaletteColor.white,fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
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
                month: 'Maio',
                year: '2022',
                sales: 500,
                fees: 46,
                status: 'Pendente',
                onTapNext: (){},
                onTapPrevius: (){},
              )
            ],
          ),
        ),
      ),
    );
  }
}
