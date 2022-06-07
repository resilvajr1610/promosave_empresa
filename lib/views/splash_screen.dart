import '../Utils/export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  verification()async{
    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentSnapshot snapshot = await db.collection("enterprise")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    Map<String,dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    final status = data?["status"];
    final type = data?["type"];
    final bank = data?["bank"];

    if(status==TextConst.APPROVED){
      if(bank!=null){
        if(type==TextConst.ENTERPRISE){
          await Future.delayed(Duration(seconds: 3),(){
            Navigator.pushReplacementNamed(context, '/home_enterprise');
          });
        }else{
          await Future.delayed(Duration(seconds: 3),(){
            Navigator.pushReplacementNamed(context, '/home_delivery');
          });
        }
      }else{
        await Future.delayed(Duration(seconds: 3),(){
          Navigator.pushReplacementNamed(context, '/registerBank');
        });
      }
    }else{
      await Future.delayed(Duration(seconds: 3),(){
        Navigator.pushReplacementNamed(context, '/waiting');
      });
    }
  }

  _mockCheckForSession()async{

    if(FirebaseAuth.instance.currentUser!=null){
      verification();
    }else{
      await Future.delayed(Duration(seconds: 3),(){
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: ( BuildContext context) => InitialScreen()
            )
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _mockCheckForSession();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: PaletteColor.primaryColor,
        body: Center(
          child: SizedBox(
            height: height*0.5,
            width: height*0.5,
            child:Image.asset("assets/image/logo.png"),
          ),
        )
    );
  }
}
