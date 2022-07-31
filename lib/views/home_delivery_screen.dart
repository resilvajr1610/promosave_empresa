import '../Utils/colors.dart';
import '../Utils/export.dart';
import '../Utils/text_const.dart';

class HomeDeliveryScreen extends StatefulWidget {
  const HomeDeliveryScreen({Key? key}) : super(key: key);

  @override
  _HomeDeliveryScreenState createState() => _HomeDeliveryScreenState();
}

class _HomeDeliveryScreenState extends State<HomeDeliveryScreen> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  List _allResultsReady=[];

  data()async{
    var data = await db.collection("shopping")
        .where('status', isEqualTo: TextConst.ORDERAREADY)
        .get();

    setState(() {
      _allResultsReady = data.docs;
    });
  }

  _showDialog() {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: 'Dialog',
        pageBuilder: (_,__,___){
          return ShowDialog(
            idRequest: '0025478',
            date: '08/06/2022 17:30',
            shipping: 'R\$ 5,00',
            enterprise: 'Empresa',
            enterpriseAddress: 'Itapetininga',
            client: 'Cliente',
            clientAddress: 'Itapetininga',
            list: [
              ButtonCustom(
                text: 'Aceitar',
                colorText: PaletteColor.white,
                colorBorder: PaletteColor.primaryColor,
                heightCustom: 0.05,
                widthCustom: 0.2,
                onPressed: () =>Navigator.pop(context),
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
    data();
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
                            style: TextStyle(fontSize: 16,color: PaletteColor.primaryColor),)
                      );
                    }else{

                      return item['addressClient']!='Retirada no local'?ContainerDelivery(
                        photo: item['logoUrl'],
                        enterprise: item['nameEnterprise'].toString().toUpperCase(),
                        address: item['addressClient'],
                        shipping: 'R\$ 5,00',
                        onTap: () => _showDialog(),
                      ):Container();
                    }
                  }
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: width,
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
              child: ListView(
                children: [
                  ContainerDelivery(
                    photo: FirebaseAuth.instance.currentUser!.photoURL,
                    enterprise: 'Empresa',
                    address: 'Itapetininga',
                    shipping: 'R\$ 5,00',
                    onTap: () => _showDialog(),
                  ),
                  ContainerDelivery(
                    photo: FirebaseAuth.instance.currentUser!.photoURL,
                    enterprise: 'Empresa',
                    address: 'Itapetininga',
                    shipping: 'R\$ 5,00',
                    onTap: () => _showDialog(),
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
