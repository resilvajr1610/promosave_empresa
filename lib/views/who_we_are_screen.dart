import '../Utils/export.dart';

class WhoWeAreScreen extends StatefulWidget {

  @override
  _WhoWeAreScreenState createState() => _WhoWeAreScreenState();
}

class _WhoWeAreScreenState extends State<WhoWeAreScreen> {

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: PaletteColor.white,
      drawer: DrawerCustom(
        enterprise: FirebaseAuth.instance.currentUser!.displayName!,
        photo: FirebaseAuth.instance.currentUser!.photoURL,
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: PaletteColor.primaryColor,
        title: TextCustom(text: 'Quem Somos',size: 24.0,color: PaletteColor.white,fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height*0.85,
          padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: TextCustom(text: 'Quem somos',color: PaletteColor.primaryColor,size: 16.0,fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextCustom(text: 'Nulla Lorem mollit cupidatat irure. Laborum magna nulla duis ullamco cillum dolor. Voluptate exercitation incididunt aliquip deserunt reprehenderit elit laborum. ',
                  color: PaletteColor.grey,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start,),
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: TextCustom(text: 'Nossa causa',color: PaletteColor.primaryColor,size: 16.0,fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextCustom(text: 'Nulla Lorem mollit cupidatat irure. Laborum magna nulla duis ullamco cillum dolor. Voluptate exercitation incididunt aliquip deserunt reprehenderit elit laborum. ',
                  color: PaletteColor.grey,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start,),
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: TextCustom(text: 'Nos siga nas redes sociais',color: PaletteColor.primaryColor,size: 16.0,fontWeight: FontWeight.bold,textAlign: TextAlign.center,),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(FontAwesomeIcons.twitterSquare,color: PaletteColor.grey,size: 0,),
                  Icon(FontAwesomeIcons.twitterSquare,color: PaletteColor.grey,size: 40,),
                  Icon(FontAwesomeIcons.facebookSquare,color: PaletteColor.grey,size: 40,),
                  Icon(FontAwesomeIcons.instagramSquare,color: PaletteColor.grey,size: 40,),
                  Icon(FontAwesomeIcons.twitterSquare,color: PaletteColor.grey,size: 0,),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
