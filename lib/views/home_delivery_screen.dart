import '../Utils/colors.dart';
import '../Utils/export.dart';

class HomeDeliveryScreen extends StatefulWidget {
  const HomeDeliveryScreen({Key? key}) : super(key: key);

  @override
  _HomeDeliveryScreenState createState() => _HomeDeliveryScreenState();
}

class _HomeDeliveryScreenState extends State<HomeDeliveryScreen> {
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
        child: Container(
          height: height * 0.85,
          padding: EdgeInsets.all(12),
          alignment: Alignment.topCenter,
          child: ListView(
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
              ContainerDelivery(
                photo: FirebaseAuth.instance.currentUser!.photoURL,
                enterprise: 'Empresa',
                address: 'Itapetininga',
                shipping: 'R\$ 5,00',
                onTap: () => _showDialog(),
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
      ),
    );
  }
}
