import '../Utils/export.dart';

class Routes{
    static Route<dynamic>? generateRoute(RouteSettings settings){
      final args = settings.arguments;

      switch(settings.name){
        case "/splash" :
          return MaterialPageRoute(
              builder: (_) => SplashScreen()
          );
        case "/initial" :
          return MaterialPageRoute(
              builder: (_) => InitialScreen()
          );
        case "/register" :
          return MaterialPageRoute(
              builder: (_) => RegisterScreen(type: args as String,)
          );
        case "/login" :
          return MaterialPageRoute(
              builder: (_) => LoginScreen()
          );
        case "/cnh" :
          return MaterialPageRoute(
              builder: (_) => CnhScreen()
          );
        case "/home_enterprise" :
          return MaterialPageRoute(
              builder: (_) => HomeEnterpriseScreen()
          );
        case "/home_delivery" :
          return MaterialPageRoute(
              builder: (_) => HomeDeliveryScreen()
          );
        case "/requests_enterprise" :
          return MaterialPageRoute(
              builder: (_) => RequestsEnterpriseScreen()
          );
        case "/profile" :
          return MaterialPageRoute(
              builder: (_) => ProfileScreen()
          );
        case "/definition" :
          return MaterialPageRoute(
              builder: (_) => DefinitionScreen()
          );
        case "/waiting" :
          return MaterialPageRoute(
              builder: (_) => WaitingScreen()
          );
        case "/registerBank" :
          return MaterialPageRoute(
              builder: (_) => RegisterBankScreen()
          );
        case "/dataBank" :
          return MaterialPageRoute(
              builder: (_) => DataBankScreen()
          );
        case "/who" :
          return MaterialPageRoute(
              builder: (_) => WhoWeAreScreen()
          );
        case "/finance" :
          return MaterialPageRoute(
              builder: (_) => FinanceScreen()
          );
        case "/history_requests" :
          return MaterialPageRoute(
              builder: (_) => HistoryRequestsEnterpriseScreen()
          );
        default :
          _erroRota();
      }
    }
    static  Route <dynamic> _erroRota(){
      return MaterialPageRoute(
          builder:(_){
            return Scaffold(
              appBar: AppBar(
                title: Text("Tela em desenvolvimento"),
              ),
              body: Center(
                child: Text("Tela em desenvolvimento"),
              ),
            );
          });
    }
  }