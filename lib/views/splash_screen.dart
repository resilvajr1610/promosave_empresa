import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:promosave_empresa/models/notification_model.dart';

import '../Utils/colors.dart';
import '../Utils/export.dart';
import '../Utils/text_const.dart';
import '../service/local_push_notitication.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  storeNotificationToken()async{
    String token = (await FirebaseMessaging.instance.getToken())!;
    FirebaseFirestore.instance.collection('enterprise').doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'token' : token
    },SetOptions(merge: true)).then((value){
      // sendNotification('Empresa', 'Promo save', token);
    });
    print('token : $token');
  }

  verification()async{
    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentSnapshot snapshot = await db.collection("enterprise")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    Map<String,dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    final status = data?["status"];
    final type = data?["type"];
    final bank = data?["bank"];
    final urlPhotoCnh = data?["urlPhotoCnh"];
    final urlPhotoProfile = data?["urlPhotoProfile"];

    if(status==TextConst.APPROVED){
      if(type==TextConst.ENTERPRISE){
        if(bank!=null){
          await Future.delayed(Duration(seconds: 3),(){
            Navigator.pushReplacementNamed(context, '/home_enterprise');
          });
        }else{
          await Future.delayed(Duration(seconds: 3),(){
            Navigator.pushReplacementNamed(context, '/registerBank');
          });
        }
      }else if (type==TextConst.DELIVERYMAN){
        if(urlPhotoCnh!=null && urlPhotoProfile!=null){
          if(bank!=null){
            await Future.delayed(Duration(seconds: 3),(){
              Navigator.pushReplacementNamed(context, '/home_delivery');
            });
          }else{
            await Future.delayed(Duration(seconds: 3),(){
              Navigator.pushReplacementNamed(context, '/registerBank');
            });
          }
        }else{
          await Future.delayed(Duration(seconds: 3),(){
            Navigator.pushReplacementNamed(context, '/cnh');
          });
        }
      }else{
        await Future.delayed(Duration(seconds: 3),(){
          Navigator.pushReplacementNamed(context, '/login');
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

    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });

    _mockCheckForSession();
    storeNotificationToken();
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
