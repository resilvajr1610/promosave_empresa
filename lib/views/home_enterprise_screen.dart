import '../utils/export.dart';

class HomeEnterpriseScreen extends StatefulWidget {
  const HomeEnterpriseScreen({Key? key}) : super(key: key);

  @override
  _HomeEnterpriseScreenState createState() => _HomeEnterpriseScreenState();
}

class _HomeEnterpriseScreenState extends State<HomeEnterpriseScreen> {

  final _controllerSearch = TextEditingController();
  var _controllerAddress = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  List _resultsList = [];
  List _allResults = [];

  _data() async {
    Stream<QuerySnapshot> stream = db.collection("user").where('idUser',isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots();
    stream.listen((data) {
      _controllerAddress.add(data);
    });

    var data = await db.collection("items").get();

    setState(() {
      _allResults = data.docs;
    });
    resultSearchList();
    return "complete";
  }
  _search() {
    resultSearchList();
  }
  resultSearchList() {
    var showResults = [];

    if (_controllerSearch.text != "") {
      for (var items in _allResults) {
        var brands = SearchModel.fromSnapshot(items).name.toLowerCase();

        if (brands.contains(_controllerSearch.text.toLowerCase())) {
          showResults.add(items);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  @override
  void initState() {
    super.initState();
    _data();
    _controllerSearch.addListener(_search);
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: DrawerCustom(),
      backgroundColor: PaletteColor.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: PaletteColor.primaryColor,
        title: Image.asset('assets/image/logo.png',height: 100,),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(12),
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              TextCustom(text: 'NOME DA EMPRESA',size: 16.0,color: PaletteColor.grey,fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
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
                            )
                        ),
                        child: Center(child: TextCustom(text: '2', size: 24.0, color: PaletteColor.white, fontWeight: FontWeight.w500,textAlign: TextAlign.center,)),
                      ),
                      TextCustom(text: 'Sacolas\nvendidas', size: 12.0, color: PaletteColor.primaryColor, fontWeight: FontWeight.normal,textAlign: TextAlign.center,),
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
                            )
                        ),
                        child: Center(child: TextCustom(text: '4', size: 24.0, color: PaletteColor.white, fontWeight: FontWeight.w500,textAlign: TextAlign.center,)),
                      ),
                      TextCustom(text: 'Alimentos\nsalvos', size: 12.0, color: PaletteColor.primaryColor, fontWeight: FontWeight.normal,textAlign: TextAlign.center,),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: PaletteColor.primaryColor,minimumSize: Size(width*0.5, 40),maximumSize: Size(width*0.7,40)),
                  onPressed: (){},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Pedidos',style: TextStyle(color: PaletteColor.white,fontSize: 14,fontFamily: 'Nunito',fontWeight: FontWeight.bold)),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding: EdgeInsets.symmetric(horizontal: 8,vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: PaletteColor.white
                        ),
                        child: Text('2',style: TextStyle(color: PaletteColor.primaryColor,fontSize: 14,fontFamily: 'Nunito',fontWeight: FontWeight.bold),),
                      )
                    ],
                  )
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: width,
                alignment: Alignment.centerLeft,
                child: TextCustom(fontWeight: FontWeight.bold,color: PaletteColor.primaryColor, text: 'Meus Produtos', size: 16.0,textAlign: TextAlign.center,)),
              Container(
                height: height*0.5,
                child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(_resultsList.length+1, (index) {

                    if(index == 0){
                      return Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(4),
                        color: PaletteColor.greyInput,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle,color: PaletteColor.white,size: 30),
                            SizedBox(height: 10),
                            TextCustom(fontWeight: FontWeight.bold,color: PaletteColor.white, text: 'Adicionar novo\nproduto', size: 12.0,textAlign: TextAlign.center,),
                          ],
                        ));
                    }

                    DocumentSnapshot item = _resultsList[index-1];

                    String name = item["name"];
                    final photo = item["photo"];
                    final price = item["price"];

                    return CardHome(image: photo,name: name.toUpperCase(),price: price.toStringAsFixed(2).replaceAll(".", ","));
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
