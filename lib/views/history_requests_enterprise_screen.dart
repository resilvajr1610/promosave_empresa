import 'package:intl/intl.dart';

import '../Utils/colors.dart';
import '../Utils/export.dart';
import '../Utils/text_const.dart';
import '../models/requests_model.dart';

class HistoryRequestsEnterpriseScreen extends StatefulWidget {

  @override
  _HistoryRequestsEnterpriseScreenState createState() => _HistoryRequestsEnterpriseScreenState();
}

class _HistoryRequestsEnterpriseScreenState extends State<HistoryRequestsEnterpriseScreen> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  final _itemsPeriod = ['últimos 7 dias','últimos 15 dias','últimos 30 dias'];
  String? _selectedPediod;
  List<RequestsModel> listRequests=[];
  List _allResults = [];
  Map<String,dynamic>? data;

  DropdownMenuItem<String>  buildMenuItem(String item)=>DropdownMenuItem(
    value: item,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: TextCustom(text: item,size: 16.0,textAlign: TextAlign.center,color: PaletteColor.grey, fontWeight: FontWeight.normal,),
    ),
  );

  dataDelivery(var dataUser)async{
    var data = await  db.collection("shopping")
                        .where(dataUser?["type"]==TextConst.DELIVERYMAN?'idDelivery':'idEnterprise', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .where('status', isEqualTo: TextConst.ORDERFINISHED)
                        .get();

    setState(() {
      _allResults = data.docs;
    });
  }
  dataUser()async{
    DocumentSnapshot snapshot = await  db.collection("enterprise").doc(FirebaseAuth.instance.currentUser!.uid).get();

    data = snapshot.data() as Map<String, dynamic>?;
    dataDelivery(data);
  }

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'pt_BR';
    dataUser();
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
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                width: width,
                child: TextCustom(
                    text: 'Histórico de ${data?["type"]==TextConst.DELIVERYMAN?'Entregas':'Pedidos'}',color: PaletteColor.grey,size: 16.0,fontWeight: FontWeight.bold,textAlign: TextAlign.center
                )
            ),
            Container(
              height: height*0.07,
              width: width*0.45,
              decoration: BoxDecoration(
                color: PaletteColor.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: PaletteColor.greyInput)
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  iconEnabledColor: PaletteColor.greyInput,
                  alignment: Alignment.center,
                  value: _selectedPediod,
                  hint: TextCustom(text: "últimos 7 dias",size: 16.0,textAlign: TextAlign.center,color: PaletteColor.grey, fontWeight: FontWeight.normal,),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12
                  ),
                  items: _itemsPeriod.map(buildMenuItem).toList(),
                  onChanged: (value) => setState(() => _selectedPediod = value.toString()),
                ),
              ),
            ),
            Container(
              height: height*0.65,
              child: ListView.builder(
              itemCount: _allResults.length,
              itemBuilder:(context,index) {
                DocumentSnapshot item = _allResults[index];

                if (_allResults.length == 0) {
                  return Center(
                      child: Text('Nenhum pedido encontrado',
                        style: TextStyle(fontSize: 16, color: PaletteColor.primaryColor),)
                  );
                } else {
                  listRequests.add(
                      RequestsModel(
                          showRequests: false
                      )
                  );
                  return ContainerRequestsEnterprise(
                    typeDelivery: data?["type"],
                    totalFees: item['totalFees'],
                    screen: 'history',
                    priceMixed: item['priceMista'],
                    priceSalt : item['priceSalgada'],
                    priceSweet: item['priceDoce'],
                    idRequests: item['order'],
                    date: DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(item['hourRequest'])),
                    client: item['nameClient'].toString().toUpperCase(),
                    enterprise: item['nameEnterprise'].toString().toUpperCase(),
                    contMixed: item['quantMista'],
                    contSalt: item['quantSalgada'],
                    contSweet: item['quantDoce'],
                    type: 'Para entrega',
                    textButton: 'Aceitar',
                    showDetailsRequests: listRequests[index].showRequests,
                    onTapIcon: () {
                      setState(() {
                        listRequests[index].showRequests?listRequests[index].showRequests=false:listRequests[index].showRequests=true;
                      });
                    },
                    onTapButtom: () {},
                  );
                }
              }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
