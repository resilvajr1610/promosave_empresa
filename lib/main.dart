import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:promosave_empresa/service/local_push_notitication.dart';
import 'Utils/export.dart';
import 'Utils/routes.dart';

Future<void> _firebaseMessaginBackgroundHandler(RemoteMessage message)async{

}

void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  String route = '/splash';
  initializeDateFormatting();
  Intl.defaultLocale = 'pt_BR';
  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessaginBackgroundHandler);


  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    //home: SplashScreen(),
    initialRoute:route,
    onGenerateRoute: Routes.generateRoute,
  ));
}