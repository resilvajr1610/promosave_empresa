import 'Utils/export.dart';
import 'Utils/routes.dart';

void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  String route = '/splash';

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    //home: SplashScreen(),
    initialRoute:route,
    onGenerateRoute: Routes.generateRoute,
  ));
}