import '../Utils/export.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({Key? key}) : super(key: key);

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final _controllerSearch = TextEditingController();
  bool showAnswer=false;

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
        title: TextCustom(
          text: 'Perguntas frequentes',
          size: 24.0,
          color: PaletteColor.white,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              InputHome(
                  widget: Container(
                alignment: Alignment.centerLeft,
                width: width * 0.8,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controllerSearch,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.text,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          color: PaletteColor.grey,
                          fontSize: 16.0,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Pesquisar',
                            hintStyle: TextStyle(
                              color: PaletteColor.greyInput,
                              fontSize: 16.0,
                            )),
                      ),
                    ),
                    Icon(
                      Icons.search,
                      size: 25,
                      color: PaletteColor.primaryColor,
                    ),
                  ],
                ),
              )),
              SizedBox(height: 20),
              Container(
                height: height*0.67,
                child: ListView(
                  children: [
                    ContainerQuestion(
                      showAnswer: showAnswer,
                      question: 'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint?',
                      answer: 'Nulla Lorem mollit cupidatat irure. Laborum magna nulla duis ullamco cillum dolor. Voluptate exercitation incididunt aliquip deserunt reprehenderit elit laborum.',
                      onTap: (){
                        setState(() {
                          if(showAnswer==false){
                            showAnswer=true;
                            print(showAnswer);
                          }else{
                            showAnswer=false;
                            print(showAnswer);
                          }
                        });
                      },
                    ),
                    ContainerQuestion(
                      showAnswer: showAnswer,
                      question: 'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint?',
                      answer: 'Nulla Lorem mollit cupidatat irure. Laborum magna nulla duis ullamco cillum dolor. Voluptate exercitation incididunt aliquip deserunt reprehenderit elit laborum.',
                      onTap: (){
                        setState(() {
                          if(showAnswer==false){
                            showAnswer=true;
                            print(showAnswer);
                          }else{
                            showAnswer=false;
                            print(showAnswer);
                          }
                        });
                      },
                    ),
                    ContainerQuestion(
                      showAnswer: showAnswer,
                      question: 'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint?',
                      answer: 'Nulla Lorem mollit cupidatat irure. Laborum magna nulla duis ullamco cillum dolor. Voluptate exercitation incididunt aliquip deserunt reprehenderit elit laborum.',
                      onTap: (){
                        setState(() {
                          if(showAnswer==false){
                            showAnswer=true;
                            print(showAnswer);
                          }else{
                            showAnswer=false;
                            print(showAnswer);
                          }
                        });
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
