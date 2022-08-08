import 'package:intl/intl.dart';
import 'package:promosave_empresa/Utils/text_const.dart';

import '../Utils/colors.dart';
import '../Utils/export.dart';
import '../models/error_double_model.dart';
import '../models/requests_model.dart';

class RequestsEnterpriseScreen extends StatefulWidget {

  @override
  _RequestsEnterpriseScreenState createState() => _RequestsEnterpriseScreenState();
}

class _RequestsEnterpriseScreenState extends State<RequestsEnterpriseScreen> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  List<RequestsModel> listRequests=[];
  List _resultsRequestORDERCREATED = [];
  List _resultsRequestORDERACCEPTED = [];
  List _resultsRequestORDERAREADY = [];
  bool showAccept = false;
  bool showWaiting = false;
  bool showDelivery = false;
  double feesProduct = 0.0;
  double totalProductFinance = 0.0;
  double totalDiscountFinance = 0.0;
  double totalRequest = 0.0;
  Map<String,dynamic>? data;

  dataORDERCREATED()async{
    var data = await db.collection("shopping")
        .where('idEnterprise', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('status', isEqualTo: TextConst.ORDERCREATED)
        .get();

    setState(() {
      _resultsRequestORDERCREATED = data.docs;
    });
  }

  dataORDERACCEPTED()async{
    var data = await db.collection("shopping")
        .where('idEnterprise', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('status', isEqualTo: TextConst.ORDERACCEPTED)
        .get();

    setState(() {
      _resultsRequestORDERACCEPTED = data.docs;
    });
  }

  dataORDERAREADY()async{
    var data = await db.collection("shopping")
        .where('idEnterprise', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('status', isEqualTo: TextConst.ORDERAREADY)
        .get();

    setState(() {
      _resultsRequestORDERAREADY = data.docs;
    });
  }

  dataFees()async{
    DocumentSnapshot snapshot = await db.collection('fees').doc('fees').get();
    data = snapshot.data() as Map<String, dynamic>?;
    feesProduct = double.parse(data?['feesProduct']);
    print(feesProduct);
  }

  dataFinance()async{

    var year = DateTime.now().year;
    var month = DateTime.now().month;

    DocumentSnapshot snapshot = await db.collection('financeEnterprise').doc(FirebaseAuth.instance.currentUser!.uid).get();
    data = snapshot.data() as Map<String, dynamic>?;
    totalProductFinance = ErrorDoubleModel(snapshot,'totalProduct$month$year') ;
    totalDiscountFinance = ErrorDoubleModel(snapshot,'totalDiscount$month$year');
    totalRequest = ErrorDoubleModel(snapshot,'totalRequest$month$year');
    print('totalFeesFinance $totalProductFinance');
    print('totalDiscountFinance $totalDiscountFinance');
    print('totalRequest $totalRequest');
  }

  @override
  void initState() {
    super.initState();
    dataORDERCREATED();
    dataORDERACCEPTED();
    dataORDERAREADY();
    dataFees();
    dataFinance();
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
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  width: width,
                  child: TextCustom(
                      text: 'Pedidos em andamento',color: PaletteColor.grey,size: 16.0,fontWeight: FontWeight.bold,textAlign: TextAlign.center
                  )
              ),
              TextButton(
                onPressed: (){
                  setState(() {
                    showAccept?showAccept=false:showAccept=true;
                  });
                },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24,),
                    width: width,
                    child: Row(
                      children: [
                        TextCustom(
                            text: 'Para aceitar',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                        ),
                        SizedBox(width: 10,),
                        Icon(showAccept?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up,color: PaletteColor.primaryColor,size: 30,)
                      ],
                    )
                ),
              ),
              showAccept?Container(
                      height: height*0.5,
                      child: ListView.builder(
                          itemCount: _resultsRequestORDERCREATED.length,
                          itemBuilder:(context,index){

                            DocumentSnapshot item = _resultsRequestORDERCREATED[index];

                            if(_resultsRequestORDERCREATED.length == 0){
                              return Center(
                                  child: Text('Nenhum pedido encontrado',
                                    style: TextStyle(fontSize: 16,color: PaletteColor.primaryColor),)
                              );
                            }else{
                              listRequests.add(
                                  RequestsModel(
                                      showRequests: false
                                  )
                              );
                              return ContainerRequestsEnterprise(
                                typeDelivery: TextConst.ENTERPRISE,
                                totalFees: item['totalFees'],
                                priceMixed: item['priceMista'],
                                priceSalt : item['priceSalgada'],
                                priceSweet: item['priceDoce'],
                                screen: 'request',
                                idRequests: item['order'],
                                date: DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(item['hourRequest'])),
                                client: item['nameClient'],
                                enterprise: item['nameEnterprise'],
                                contMixed: item['quantMista'],
                                contSalt: item['quantSalgada'],
                                contSweet: item['quantDoce'],
                                type: item['type'],
                                textButton: 'Aceitar',
                                showDetailsRequests: listRequests[index].showRequests,
                                onTapButtom: (){
                                  db.collection('shopping').doc(item['idShopping']).update({'status':TextConst.ORDERACCEPTED})
                                      .then((value) => Navigator.pushReplacementNamed(context, '/requests_enterprise'));
                                },
                                onTapIcon: (){
                                  setState(() {
                                    listRequests[index].showRequests?listRequests[index].showRequests=false:listRequests[index].showRequests=true;
                                  });
                                },
                              );
                            }
                          }
                      ),
                    ):Container(),
              TextButton(
                onPressed: (){
                  setState(() {
                    showWaiting?showWaiting=false:showWaiting=true;
                  });
                },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24,),
                    width: width,
                    child: Row(
                      children: [
                        TextCustom(
                            text: 'Aguardando preparo',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                        ),
                        SizedBox(width: 10,),
                        Icon(showWaiting?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up,color: PaletteColor.primaryColor,size: 30,)
                      ],
                    )
                ),
              ),
              showWaiting?Container(
                height: height*0.5,
                child: ListView.builder(
                    itemCount: _resultsRequestORDERACCEPTED.length,
                    itemBuilder:(context,index){

                      DocumentSnapshot item = _resultsRequestORDERACCEPTED[index];

                      if(_resultsRequestORDERACCEPTED.length == 0){
                        return Center(
                            child: Text('Nenhum pedido encontrado',
                              style: TextStyle(fontSize: 16,color: PaletteColor.primaryColor),)
                        );
                      }else{
                        listRequests.add(
                            RequestsModel(
                                showRequests: false
                            )
                        );

                        var year = DateTime.now().year;
                        var month = DateTime.now().month;

                        return ContainerRequestsEnterprise(
                          typeDelivery: TextConst.ENTERPRISE,
                          totalFees: item['totalFees'],
                          priceMixed: item['priceMista'],
                          priceSalt : item['priceSalgada'],
                          priceSweet: item['priceDoce'],
                          screen: 'request',
                          idRequests: item['order'],
                          date: DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(item['hourRequest'])),
                          client: item['nameClient'],
                          enterprise: item['nameEnterprise'],
                          contMixed: item['quantMista'],
                          contSalt: item['quantSalgada'],
                          contSweet: item['quantDoce'],
                          type: item['type'],
                          textButton: 'Pronto',
                          showDetailsRequests: listRequests[index].showRequests,
                          onTapButtom: (){
                            db.collection('shopping').doc(item['idShopping']).update({'status':TextConst.ORDERAREADY})
                                .then((value){
                              db.collection('financeEnterprise').doc(FirebaseAuth.instance.currentUser!.uid).set({
                                'idUser' : FirebaseAuth.instance.currentUser!.uid,
                                'photoURL$month$year' : FirebaseAuth.instance.currentUser!.photoURL!=null
                                    ?FirebaseAuth.instance.currentUser!.photoURL:TextConst.LOGO,
                                'name$month$year' : FirebaseAuth.instance.currentUser!.displayName,
                                'totalFees$month$year': totalProductFinance+item['priceMista']+item['priceSalgada']+item['priceDoce'],
                                'totalDiscount$month$year': (totalDiscountFinance+(item['priceMista']+item['priceSalgada']+item['priceDoce'])) * (feesProduct/100),
                                'totalRequest$month$year': totalRequest+1
                              }).then((value) => Navigator.pushReplacementNamed(context, '/requests_enterprise'));
                            });
                          },
                          onTapIcon: (){
                            setState(() {
                              listRequests[index].showRequests?listRequests[index].showRequests=false:listRequests[index].showRequests=true;
                            });
                          },
                        );
                      }
                    }
                ),
              ):Container(),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 24,),
                  width: width,
                  child: TextButton(
                    onPressed:(){
                      setState(() {
                        showDelivery?showDelivery=false:showDelivery=true;
                      });
                    },
                    child: Row(
                      children: [
                        TextCustom(
                            text: 'Aguardando entrega',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                        ),
                        SizedBox(width: 10,),
                        Icon(showDelivery?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up,color: PaletteColor.primaryColor,size: 30,)
                      ],
                    ),
                  )
              ),
              showDelivery?Container(
                height: height*0.5,
                child: ListView.builder(
                    itemCount: _resultsRequestORDERAREADY.length,
                    itemBuilder:(context,index){

                      DocumentSnapshot item = _resultsRequestORDERAREADY[index];

                      if(_resultsRequestORDERAREADY.length == 0){
                        return Center(
                            child: Text('Nenhum pedido encontrado',
                              style: TextStyle(fontSize: 16,color: PaletteColor.primaryColor),)
                        );
                      }else{
                        listRequests.add(
                            RequestsModel(
                                showRequests: false
                            )
                        );
                        return ContainerRequestsEnterprise(
                          typeDelivery: TextConst.ENTERPRISE,
                          totalFees: item['totalFees'],
                          priceMixed: item['priceMista'],
                          priceSalt : item['priceSalgada'],
                          priceSweet: item['priceDoce'],
                          screen: 'request',
                          idRequests: item['order'],
                          date: DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(item['hourRequest'])),
                          client: item['nameClient'],
                          enterprise: item['nameEnterprise'],
                          contMixed: item['quantMista'],
                          contSalt: item['quantSalgada'],
                          contSweet: item['quantDoce'],
                          type: item['type'],
                          textButton: 'Confirmar retirada',
                          showDetailsRequests: listRequests[index].showRequests,
                          onTapButtom: (){
                            db.collection('shopping').doc(item['idShopping']).update({'status':TextConst.ORDERAREADY})
                                .then((value) => Navigator.pushReplacementNamed(context, '/requests_enterprise'));
                          },
                          onTapIcon: (){
                            setState(() {
                              listRequests[index].showRequests?listRequests[index].showRequests=false:listRequests[index].showRequests=true;
                            });
                          },
                        );
                      }
                    }
                ),
              ):Container()
            ],
          ),
        ),
      ),
    );
  }
}
