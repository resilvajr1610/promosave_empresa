import '../Utils/export.dart';

class DrawerCustom extends StatelessWidget {
  String enterprise;
  final photo;

  DrawerCustom({required this.enterprise, required this.photo});

  var type="";

  data() async {
    var snapshot = await  FirebaseFirestore.instance.collection('enterprise').doc(FirebaseAuth.instance.currentUser!.uid).get();
    Map<String,dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    type = data?["type"];
  }

  test(){
    print(type);
  }

  @override
  Widget build(BuildContext context) {

    data();
    test();

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        width: width*0.7,
        height: height*0.9,
        color: Colors.white,
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            SafeArea(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: photo==null ? CircleAvatar(
                      backgroundColor: PaletteColor.primaryColor,
                      backgroundImage: AssetImage('assets/image/logo.png')
                    ):CircleAvatar(
                      backgroundColor: PaletteColor.primaryColor,
                      backgroundImage: NetworkImage(photo),
                    ),
                  ),
                  TextCustom(text: enterprise.toUpperCase(), size: 16.0, color: PaletteColor.primaryColor, fontWeight: FontWeight.bold,textAlign: TextAlign.center,)
                ],
              ),
            ),
            SizedBox(height: height*0.02),
            TitleDrawer(
              onTap: ()=>Navigator.pushNamed(context, type ==TextConst.ENTERPRISE?'/home_enterprise':'/home_delivery'),
              title: 'home',
              icon: Icons.home_outlined,
            ),
            TitleDrawer(
              onTap: ()=>Navigator.pushNamed(context, '/profile'),
              title: 'Perfil',
              icon: Icons.account_circle_outlined,
            ),
            TitleDrawer(
              onTap: ()=>Navigator.pushNamed(context, '/dataBank'),
              title: 'Dados bancários',
              icon: Icons.credit_card_outlined,
            ),
            TitleDrawer(
              onTap: ()=>Navigator.pushNamed(context, '/finance'),
              title: 'Finanças',
              icon: Icons.attach_money,
            ),
            TitleDrawer(
              onTap: ()=>Navigator.pushNamed(context, '/history_requests'),
              title: type ==TextConst.ENTERPRISE?'Histórico de pedidos':'Histórico de entregas',
              icon: Icons.calendar_today_outlined,
            ),
            TitleDrawer(
              onTap: ()=>Navigator.pushNamed(context, '/questions'),
              title: 'Perguntas frequentes',
              icon: Icons.help_outline,
            ),
            TitleDrawer(
              onTap: ()=>Navigator.pushNamed(context, '/who'),
                title: 'Quem Somos',
                icon: Icons.people_outline,
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Container(
                padding: EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                width: width*0.7,
                child: Icon(Icons.logout,color: PaletteColor.primaryColor)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
