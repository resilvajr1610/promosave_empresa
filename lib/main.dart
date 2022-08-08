import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'Utils/export.dart';
import 'Utils/routes.dart';

void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  String route = '/splash';
  initializeDateFormatting();
  Intl.defaultLocale = 'pt_BR';

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    //home: SplashScreen(),
    initialRoute:route,
    onGenerateRoute: Routes.generateRoute,
  ));
}