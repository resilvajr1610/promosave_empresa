import '../Utils/colors.dart';
import '../Utils/export.dart';

class HistoryRequestsEnterpriseScreen extends StatefulWidget {

  @override
  _HistoryRequestsEnterpriseScreenState createState() => _HistoryRequestsEnterpriseScreenState();
}

class _HistoryRequestsEnterpriseScreenState extends State<HistoryRequestsEnterpriseScreen> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  bool showDetailsRequests1=false;
  bool showDetailsRequests2=false;
  bool showDetailsRequests3=false;
  bool showDetailsRequests4=false;
  bool showDetailsRequests5=false;
  bool showDetailsRequests6=false;
  final _itemsPeriod = ['últimos 7 dias','últimos 15 dias','últimos 30 dias'];
  String? _selectedPediod;

  DropdownMenuItem<String>  buildMenuItem(String item)=>DropdownMenuItem(
    value: item,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: TextCustom(text: item,size: 16.0,textAlign: TextAlign.center,color: PaletteColor.grey, fontWeight: FontWeight.normal,),
    ),
  );

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
                    text: 'Histórico de pedidos',color: PaletteColor.grey,size: 16.0,fontWeight: FontWeight.bold,textAlign: TextAlign.center
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
              child: ListView(
                children: [
                  ContainerRequestsEnterprise(
                    screen: 'history',
                    idRequests: 0001,
                    date: '03/06/2022',
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
                    onTapButtom: (){},
                  ),
                  ContainerRequestsEnterprise(
                    screen: 'history',
                    showDetailsRequests: showDetailsRequests2,
                    idRequests: 0002,
                    date: '03/06/2022',
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
                    onTapButtom: (){},
                  ),
                  ContainerRequestsEnterprise(
                    screen: 'history',
                    idRequests: 0003,
                    date: '03/06/2022',
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
                    onTapButtom: (){},
                  ),
                  ContainerRequestsEnterprise(
                    screen: 'history',
                    showDetailsRequests: showDetailsRequests4,
                    idRequests: 0004,
                    date: '03/06/2022',
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
                    onTapButtom: (){},
                  ),
                  ContainerRequestsEnterprise(
                    screen: 'history',
                    idRequests: 0005,
                    date: '03/06/2022',
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
                    onTapButtom: (){},
                  ),
                  ContainerRequestsEnterprise(
                    screen: 'history',
                    showDetailsRequests: showDetailsRequests6,
                    idRequests: 0006,
                    date: '03/06/2022',
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
                    onTapButtom: (){},
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
