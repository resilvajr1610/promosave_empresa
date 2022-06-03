import '../utils/export.dart';

class AddProductScreen extends StatefulWidget {
  final text;
  final buttonText;

  AddProductScreen({required this.text, required this.buttonText});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  String selectedText="";
  int selectedRadioButton=0;
  List titleRadio=['Salgada','Doce','Mista'];
  final controllerDescription = TextEditingController();
  final controllerIn = TextEditingController();
  final controllerPer = TextEditingController();

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    setSelectedRadio(int value){
      setState(() {
        selectedRadioButton = value;
        selectedText = titleRadio[value];
        print(selectedText);
      });
    }

    return Scaffold(
      backgroundColor: PaletteColor.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: PaletteColor.primaryColor,
        title: Image.asset('assets/image/logo.png',height: 100,),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                  width: width,
                  child: TextCustom(
                    text: widget.text,color: PaletteColor.grey,size: 16.0,fontWeight: FontWeight.bold,textAlign: TextAlign.center
                  )
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  width: width,
                  child: TextCustom(
                      text: 'Tipo de sacola:',color: PaletteColor.primaryColor,size: 16.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: height*0.2,
                    width: width*0.6,
                    child: ListView.builder(
                        itemCount:titleRadio.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 35,
                            child: RadioListTile(
                              value: index,
                              groupValue: selectedRadioButton,
                              activeColor: PaletteColor.primaryColor,
                              title: Container(
                                  height: 20,
                                  margin: const EdgeInsets.only(top: 15.0),
                                  child: TextCustom(text: titleRadio[index],color: PaletteColor.grey,size: 16.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start)
                              ),
                              subtitle: Text(''),
                              onChanged: (value){
                                setSelectedRadio(int.parse(value.toString()));
                              },
                            ),
                          );
                        }
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    height: height*0.15,
                    width: height*0.15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: PaletteColor.greyInput
                    ),
                    child: Icon(Icons.camera_alt,color: PaletteColor.white,size: 40,),
                  )
                ],
              ),
              SizedBox(height: 10),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  width: width,
                  child: TextCustom(
                      text: 'Descrição',color: PaletteColor.primaryColor,size: 16.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  )
              ),
              InputRegister(
                  controller: controllerDescription,
                  hint: 'Descreva o que pode conter na sacola',
                  fonts: 13.0,
                  keyboardType: TextInputType.text,
                  width: width*0.8,
                  sizeIcon: 0.0,
                  icons: Icons.camera_alt,
                  colorBorder: PaletteColor.greyLight,
                  background: PaletteColor.greyLight,
                  maxline: 3,
              ),
              SizedBox(height: 10),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  width: width,
                  child: TextCustom(
                      text: 'Preço do produto',color: PaletteColor.primaryColor,size: 16.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  )
              ),
              Row(
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 20),
                      child: TextCustom(
                          text: 'De',color: PaletteColor.grey,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                      )
                  ),
                  InputRegister(
                    controller: controllerIn,
                    hint: 'R\$ 00,00',
                    fonts: 13.0,
                    keyboardType: TextInputType.text,
                    width: width*0.25,
                    sizeIcon: 0.0,
                    icons: Icons.camera_alt,
                    colorBorder: PaletteColor.greyLight,
                    background: PaletteColor.greyLight,
                  ),
                  Spacer(),
                  TextCustom(
                      text: 'Por',color: PaletteColor.grey,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: InputRegister(
                      controller: controllerPer,
                      hint: 'R\$ 00,00',
                      fonts: 13.0,
                      keyboardType: TextInputType.text,
                      width: width*0.25,
                      sizeIcon: 0.0,
                      icons: Icons.camera_alt,
                      colorBorder: PaletteColor.greyLight,
                      background: PaletteColor.greyLight,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  width: width,
                  child: TextCustom(
                      text: 'Quantidade disponível',color: PaletteColor.primaryColor,size: 16.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  )
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: InputRegister(
                  controller: controllerIn,
                  hint: '00',
                  fonts: 13.0,
                  keyboardType: TextInputType.text,
                  width: width*0.3,
                  sizeIcon: 0.0,
                  icons: Icons.camera_alt,
                  colorBorder: PaletteColor.greyLight,
                  background: PaletteColor.greyLight,
                ),
              ),
              SizedBox(height: 10),
              ButtonCustom(
                  onPressed: ()=>Navigator.pushReplacementNamed(context, '/home_enterprise'),
                  widthCustom: 0.75,
                  heightCustom: 0.07,
                  text:  widget.buttonText,
                  size: 14,
                  colorButton: PaletteColor.primaryColor,
                  colorText: PaletteColor.white,
                  colorBorder: PaletteColor.primaryColor
              )
            ],
          ),
        ),
      ),
    );
  }
}
