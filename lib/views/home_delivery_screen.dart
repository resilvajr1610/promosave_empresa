import 'package:intl/intl.dart';

import '../Utils/colors.dart';
import '../Utils/export.dart';
import '../Utils/text_const.dart';
import '../models/error_double_model.dart';
import '../models/notification_model.dart';

class HomeDeliveryScreen extends StatefulWidget {
  const HomeDeliveryScreen({Key? key}) : super(key: key);

  @override
  _HomeDeliveryScreenState createState() => _HomeDeliveryScreenState();
}

class _HomeDeliveryScreenState extends State<HomeDeliveryScreen> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  List _allResultsReady=[];
  List _allResultsDelivery=[];
  Map<String,dynamic>? data;
  double feesDelivery = 0.0;
  double totalFeesFinance = 0.0;
  double totalDiscountFinance = 0.0;
  double totalRequest = 0.0;
  String token = '';
  String tokenClient = '';

  dataShopping()async{
    StreamSubscription<QuerySnapshot> listener = await db.collection("shopping")
      .where('status', isEqualTo: TextConst.ORDERAREADY)
      .snapshots().listen((query) {
        setState(() {
          _allResultsReady = query.docs;
        });
    });
  }

  dataFees()async{
    DocumentSnapshot snapshot = await db.collection('fees').doc('fees').get();
    data = snapshot.data() as Map<String, dynamic>?;
    feesDelivery = double.parse(data?['feesDelivery']);
    print(feesDelivery);
  }

  dataFinance()async{

    var year = DateTime.now().year;
    var month = DateTime.now().month;

    DocumentSnapshot snapshot = await db.collection('financeDelivery').doc(FirebaseAuth.instance.currentUser!.uid).get();
    data = snapshot.data() as Map<String, dynamic>?;
    totalFeesFinance = ErrorDoubleModel(snapshot,'totalFees$month$year') ;
    totalDiscountFinance = ErrorDoubleModel(snapshot,'totalDiscount$month$year');
    totalRequest = ErrorDoubleModel(snapshot,'totalRequest$month$year');
    print('totalFeesFinance $totalFeesFinance');
    print('totalDiscountFinance $totalDiscountFinance');
    print('totalRequest $totalRequest');
  }

  dataDelivery()async{
    StreamSubscription<QuerySnapshot> listener = await db.collection("shopping")
      .where('status', isEqualTo: TextConst.DELIVERYTOHOME)
      .where('idDelivery', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots().listen((query) {
        setState(() {
          _allResultsDelivery = query.docs;
        });
    });
  }

  dataEnterprise(String idEnterprise)async{
    DocumentSnapshot snapshot = await db.collection("enterprise").doc(idEnterprise).get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    setState(() {
      token = data?["token"];
      print(token);
    });
  }

  dataClient(String idClient)async{
    DocumentSnapshot snapshot = await db.collection("user").doc(idClient).get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    setState(() {
      tokenClient = data?["token"];
      print(tokenClient);
    });
  }

  acceptDelivery(String idShopping,String type,double totalFees, String idEnterprise,int order,String idClient)async{

    var year = DateTime.now().year;
    var month = DateTime.now().month;

    if(type!='Aceitar'){
      db.collection('financeDelivery').doc(FirebaseAuth.instance.currentUser!.uid).set({
        'idUser' : FirebaseAuth.instance.currentUser!.uid,
        'photoURL$month$year' : FirebaseAuth.instance.currentUser!.photoURL!=null?FirebaseAuth.instance.currentUser!.photoURL:TextConst.LOGO,
        'name$month$year' : FirebaseAuth.instance.currentUser!.displayName,
        'totalFees$month$year': totalFeesFinance+totalFees,
        'totalDiscount$month$year': totalDiscountFinance+(totalFees * (feesDelivery/100)),
        'totalRequest$month$year': totalRequest+1,
      });
    }

    db.collection('shopping').doc(idShopping).update({
      'idDelivery':FirebaseAuth.instance.currentUser!.uid,
      'nameDelivery':FirebaseAuth.instance.currentUser!.displayName,
      'status':type=='Aceitar'?TextConst.DELIVERYTOHOME:TextConst.ORDERFINISHED
    }).then((value){

      if(token!=''){
        if(type=='Aceitar'){
          dataEnterprise(idEnterprise);
          sendNotification('Entregador: ${FirebaseAuth.instance.currentUser!.displayName} aceitou a entrega!',
              'Pedido nº ${order}',token);
        }else{
          dataClient(idClient);
          sendNotification('Pedido Finalizado!','Pedido n° ${order} foi entregue ao cliente!',token);
          sendNotification('Pedido n° ${order} foi entregue!',
              'Bom Apetite! Aguardamos sua avaliação!',tokenClient);
        }
      }


      Navigator.pushReplacementNamed(context, '/splash');
    });
  }
  
  _showDialog(String idShopping,int order, String hourRequest,String nameClient,String clientAddress, String nameEnterprise,String enterpriseAddress, double totalFees,String type,String idEnterprise,String idClient) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: 'Dialog',
        pageBuilder: (_,__,___){
          return ShowDialog(
            idRequest: order.toString(),
            date: hourRequest,
            shipping: 'R\$ ${totalFees.toStringAsFixed(2).replaceAll('.', ',')}',
            enterprise: nameEnterprise,
            enterpriseAddress: enterpriseAddress,
            client: nameClient,
            clientAddress: clientAddress,
            list: [
              ButtonCustom(
                text: type,
                colorText: PaletteColor.white,
                colorBorder: PaletteColor.primaryColor,
                heightCustom: 0.05,
                widthCustom: 0.2,
                onPressed: () =>acceptDelivery(idShopping,type,totalFees,idEnterprise,order,idClient),
                size: 14.0,
                colorButton: PaletteColor.primaryColor,
              ),
              ButtonCustom(
                text: 'Cancelar',
                colorText: PaletteColor.white,
                colorBorder: PaletteColor.greyInput,
                heightCustom: 0.05,
                widthCustom: 0.2,
                onPressed: () =>Navigator.pop(context),
                size: 14.0,
                colorButton: PaletteColor.greyInput,
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    dataShopping();
    dataDelivery();
    dataFees();
    dataFinance();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: DrawerCustom(
        enterprise: FirebaseAuth.instance.currentUser!.displayName!=null?FirebaseAuth.instance.currentUser!.displayName!:'',
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
        child: Column(
          children: [
            TextCustom(
              text: 'Pedidos',
              size: 16.0,
              color: PaletteColor.grey,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: width,
              child: TextCustom(
                text: 'Pedido prontos - Aguardando entregador',
                size: 14.0,
                color: PaletteColor.primaryColor,
                fontWeight: FontWeight.normal,
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              height: height*0.4,
              child: ListView.builder(
                  itemCount: _allResultsReady.length,
                  itemBuilder:(context,index){

                    DocumentSnapshot item = _allResultsReady[index];

                    if(_allResultsReady.length == 0){
                      return Center(
                          child: Text('Nenhum pedido encontrado',
                            style: TextStyle(fontSize: 16,color: PaletteColor.primaryColor),
                          )
                      );
                    }else{

                      return item['addressClient']!='Retirada no local'?ContainerDelivery(
                        photo: item['logoUrl'],
                        enterprise: item['nameEnterprise'].toString().toUpperCase(),
                        address: item['addressEnterprise'],
                        shipping: 'R\$ ${item['totalFees'].toStringAsFixed(2).replaceAll('.', ',')}',
                        onTap: () => _showDialog(
                          item['idShopping'],
                          item['order'],
                          DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(item['hourRequest'])),
                          item['nameClient'],
                          item['addressClient'],
                          item['nameEnterprise'].toString().toUpperCase(),
                          item['addressEnterprise'],
                          item['totalFees'],
                          'Aceitar',
                          item['idEnterprise'],
                          item['idClient'],
                        ),
                      ):Container();
                    }
                  }
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: width,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextCustom(
                text: 'Confirmar entrega',
                size: 14.0,
                color: PaletteColor.primaryColor,
                fontWeight: FontWeight.normal,
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              height: height * 0.3,
              padding: EdgeInsets.all(12),
              alignment: Alignment.topCenter,
              child: ListView.builder(
                itemCount: _allResultsDelivery.length,
                itemBuilder:(context,index) {
                  DocumentSnapshot item = _allResultsDelivery[index];

                  if (_allResultsDelivery.length == 0) {
                    return Center(
                        child: Text('Nenhum pedido encontrado',
                          style: TextStyle(fontSize: 16, color: PaletteColor.primaryColor),
                        )
                    );
                  } else {
                    return ContainerDelivery(
                      photo: item['logoUrl'],
                      enterprise: item['nameEnterprise'].toString().toUpperCase(),
                      address: item['addressEnterprise'],
                      shipping: 'R\$ ${item['totalFees'].toStringAsFixed(2).replaceAll('.', ',')}',
                      onTap: () =>
                          _showDialog(
                              item['idShopping'],
                              item['order'],
                              DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(item['hourRequest'])),
                              item['nameClient'],
                              item['addressClient'],
                              item['nameEnterprise'].toString().toUpperCase(),
                              item['addressEnterprise'],
                              item['totalFees'],
                              'Confirmar Entrega',
                              item['idEnterprise'],
                              item['idClient'],
                          ),
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
