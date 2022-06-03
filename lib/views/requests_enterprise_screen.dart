import '../utils/export.dart';

class RequestsEnterpriseScreen extends StatefulWidget {

  @override
  _RequestsEnterpriseScreenState createState() => _RequestsEnterpriseScreenState();
}

class _RequestsEnterpriseScreenState extends State<RequestsEnterpriseScreen> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  String name="";
  bool showDetailsRequests1=false;
  bool showDetailsRequests2=false;
  bool showDetailsRequests3=false;
  bool showDetailsRequests4=false;
  bool showDetailsRequests5=false;
  bool showDetailsRequests6=false;

  _dataEnterprise()async{
    DocumentSnapshot snapshot = await db.collection("enterprise")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    Map<String,dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    name = data?["name"];
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
      drawer: DrawerCustom(enterprise: name,photo: 'assets/image/logo.png',),
      backgroundColor: PaletteColor.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: PaletteColor.primaryColor,
        title: Image.asset('assets/image/logo.png',height: 100,),
      ),
      body: Container(
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
            Container(
              height: height*0.7,
              child: ListView(
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      width: width,
                      child: TextCustom(
                          text: 'Para aceitar',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                      )
                  ),
                  ContainerRequestsEnterprise(
                    idRequests: 0001,
                    date: '03/06/2022',
                    time: '18:00',
                    client: 'Carlos Silva',
                    contMixed: 3,
                    contSalt: 0,
                    contSweet: 3,
                    type: 'Para entrega',
                    textButton: 'Aceitar',
                    showDetailsRequests: showDetailsRequests1,
                    onTapIcon: (){
                      setState(() {
                        if(showDetailsRequests1==false){
                          showDetailsRequests1=true;
                        }else{
                          showDetailsRequests1=false;
                        }
                      });
                    },
                  ),
                  ContainerRequestsEnterprise(
                    showDetailsRequests: showDetailsRequests2,
                    idRequests: 0002,
                    date: '03/06/2022',
                    time: '21:00',
                    client: 'Maria Almeida',
                    contMixed: 1,
                    contSalt: 3,
                    contSweet: 0,
                    type: 'Retirada do cliente',
                    textButton: 'Pronto',
                    onTapIcon: (){
                      setState(() {
                        if(showDetailsRequests2==false){
                          showDetailsRequests2=true;
                        }else{
                          showDetailsRequests2=false;
                        }
                      });
                    },
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 24,vertical: 10),
                      width: width,
                      child: TextCustom(
                          text: 'Aguardando preparo',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                      )
                  ),
                  ContainerRequestsEnterprise(
                    idRequests: 0003,
                    date: '03/06/2022',
                    time: '18:00',
                    client: 'Carlos Silva',
                    contMixed: 2,
                    contSalt: 0,
                    contSweet: 3,
                    type: 'Para entrega',
                    textButton: 'Pronto',
                    showDetailsRequests: showDetailsRequests3,
                    onTapIcon: (){
                      setState(() {
                        if(showDetailsRequests3==false){
                          showDetailsRequests3=true;
                        }else{
                          showDetailsRequests3=false;
                        }
                      });
                    },
                  ),
                  ContainerRequestsEnterprise(
                    showDetailsRequests: showDetailsRequests4,
                    idRequests: 0004,
                    date: '03/06/2022',
                    time: '21:00',
                    client: 'Maria Almeida',
                    contMixed: 1,
                    contSalt: 1,
                    contSweet: 1,
                    type: 'Retirada do cliente',
                    textButton: 'Pronto',
                    onTapIcon: (){
                      setState(() {
                        if(showDetailsRequests4==false){
                          showDetailsRequests4=true;
                        }else{
                          showDetailsRequests4=false;
                        }
                      });
                    },
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 24,vertical: 10),
                      width: width,
                      child: TextCustom(
                          text: 'Aguardando entrega',color: PaletteColor.primaryColor,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                      )
                  ),
                  ContainerRequestsEnterprise(
                    idRequests: 0005,
                    date: '03/06/2022',
                    time: '18:00',
                    client: 'Carlos Silva',
                    contMixed: 2,
                    contSalt: 0,
                    contSweet: 1,
                    type: 'Para entrega',
                    textButton: 'Confirmar retirada',
                    showDetailsRequests: showDetailsRequests5,
                    onTapIcon: (){
                      setState(() {
                        if(showDetailsRequests5==false){
                          showDetailsRequests5=true;
                        }else{
                          showDetailsRequests5=false;
                        }
                      });
                    },
                  ),
                  ContainerRequestsEnterprise(
                    showDetailsRequests: showDetailsRequests6,
                    idRequests: 0006,
                    date: '03/06/2022',
                    time: '21:00',
                    client: 'Maria Almeida',
                    contMixed: 1,
                    contSalt: 1,
                    contSweet: 2,
                    type: 'Retirada do cliente',
                    textButton: 'A caminho',
                    onTapIcon: (){
                      setState(() {
                        if(showDetailsRequests6==false){
                          showDetailsRequests6=true;
                        }else{
                          showDetailsRequests6=false;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
