
import 'package:promosave_empresa/Utils/text_const.dart';

import '../Utils/colors.dart';
import '../Utils/export.dart';
import '../models/error_int_model.dart';

class HomeEnterpriseScreen extends StatefulWidget {
  const HomeEnterpriseScreen({Key? key}) : super(key: key);

  @override
  _HomeEnterpriseScreenState createState() => _HomeEnterpriseScreenState();
}

class _HomeEnterpriseScreenState extends State<HomeEnterpriseScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List _resultsList = [];
  int requests=0;
  int contBags = 0;
  int contSave = 0;

  _data() async {
    StreamSubscription<QuerySnapshot> listener = await db
      .collection("products")
      .where('idUser', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots().listen((query) {
        setState(() {
          _resultsList = query.docs;
        });
    });

    return "complete";
  }
  _contRequests()async{
    var data = await db
        .collection("shopping")
        .where('idEnterprise', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('status', isNotEqualTo: TextConst.ORDERFINISHED)
        .get();

    setState(() {
      requests = data.docs.length;
    });
    return "complete";
  }

  _moneySaved()async{

    List _allMoney = [];
    int acumulacontBags =0;

    var data = await db.collection("shopping")
        .where('idEnterprise', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    _allMoney = data.docs;
    if(_allMoney.length != 0){
      List<DocumentSnapshot> movimentacoes = data.docs.toList();

      for (int i=0;i<_allMoney.length;i++){
        DocumentSnapshot item = movimentacoes[i];
        int bags = ErrorIntModel(item, "quantBagDoce") + ErrorIntModel(item, "quantBagSalgada") + ErrorIntModel(item, "quantBagMista");
        acumulacontBags += bags;
      }
      setState(() {
        contBags = acumulacontBags;
        contSave = _allMoney.length;
      });
    }else{
      setState(() {
        contBags = 0;
      });
    }
    print(contBags);
  }

  @override
  void initState() {
    super.initState();
    _data();
    _contRequests();
    _moneySaved();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: DrawerCustom(
        enterprise: FirebaseAuth.instance.currentUser!.displayName!,
        photo: FirebaseAuth.instance.currentUser!.photoURL,
      ),
      backgroundColor: PaletteColor.white,
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
          height: height * 0.9,
          padding: EdgeInsets.all(12),
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              TextCustom(
                text: FirebaseAuth.instance.currentUser!.displayName!.toUpperCase(),
                size: 16.0,
                color: PaletteColor.grey,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xffF15622),
                                Color(0xffF8A78B),
                              ],
                            )),
                        child: Center(
                            child: TextCustom(
                          text: contSave.toString(),
                          size: 24.0,
                          color: PaletteColor.white,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                        )),
                      ),
                      TextCustom(
                        text: 'Sacolas\nvendidas',
                        size: 12.0,
                        color: PaletteColor.primaryColor,
                        fontWeight: FontWeight.normal,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xffF15622),
                                Color(0xffF8A78B),
                              ],
                            )),
                        child: Center(
                            child: TextCustom(
                          text: contBags.toString(),
                          size: 24.0,
                          color: PaletteColor.white,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                        )),
                      ),
                      TextCustom(
                        text: 'Alimentos\nsalvos',
                        size: 12.0,
                        color: PaletteColor.primaryColor,
                        fontWeight: FontWeight.normal,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: PaletteColor.primaryColor,
                      minimumSize: Size(width * 0.5, 40),
                      maximumSize: Size(width * 0.7, 40)),
                  onPressed: () => Navigator.pushReplacementNamed(
                      context, '/requests_enterprise'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Pedidos',
                          style: TextStyle(
                              color: PaletteColor.white,
                              fontSize: 14,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.bold)),
                      requests!=0?Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: PaletteColor.white),
                        child: Text(
                          requests.toString(),
                          style: TextStyle(
                              color: PaletteColor.primaryColor,
                              fontSize: 14,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.bold),
                        ),
                      ):Container()
                    ],
                  )),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  width: width,
                  alignment: Alignment.centerLeft,
                  child: TextCustom(
                    fontWeight: FontWeight.bold,
                    color: PaletteColor.primaryColor,
                    text: 'Meus Produtos',
                    size: 16.0,
                    textAlign: TextAlign.center,
                  )),
              Container(
                height: height * 0.45,
                child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(_resultsList.length + 1, (index) {
                    if (index == 0) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AddProductScreen(
                                        text: 'Adicionar Produto',
                                        buttonText: 'Adicionar',
                                        id: '',
                                      )));
                        },
                        child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(4),
                            color: PaletteColor.greyInput,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle,
                                    color: PaletteColor.white, size: 30),
                                SizedBox(height: 10),
                                TextCustom(
                                  fontWeight: FontWeight.bold,
                                  color: PaletteColor.white,
                                  text: 'Adicionar novo\nproduto',
                                  size: 12.0,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )),
                      );
                    }

                    DocumentSnapshot item = _resultsList[index - 1];

                    String product = item["product"];
                    final photo = item["photoUrl"];
                    final available = item["available"];
                    final inPrice = item["inPrice"];
                    final byPrice = item["byPrice"];

                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AddProductScreen(
                                        text: 'Alterar Produto',
                                        buttonText: 'Alterar',
                                        id: item["idProduct"],
                                      )));
                        },
                        child: CardHome(
                          image: photo,
                          product: 'Sacola '+ product,
                          available: available,
                          inPrice: inPrice,
                          byPrice: byPrice,
                        ));
                  }),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
