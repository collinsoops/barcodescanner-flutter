import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Scan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyAppScreenMode();
  }
}

class MyData {
  String name = '';
  String imei = '';
  String serial = '';
  String url = '';
}

class MyAppScreenMode extends State<Scan> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new Scaffold(
          appBar: new AppBar(
            title: Center(child: new Text('Barcode Scanner')),
          ),
          body: new StepperBody(),
        ));
  }
}

class StepperBody extends StatefulWidget {
  @override
  _StepperBodyState createState() => new _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {
  String StrImeibarcodeScanRes="";
  String StrSerialbarcodeScanRes="";
  bool visible = false;


  Future<void> ImeiscanBarcodeNormal() async {
    try {
      StrImeibarcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel Imei Scan', true, ScanMode.BARCODE);
      print(StrImeibarcodeScanRes);
    } on PlatformException {
      StrImeibarcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      data.imei = StrImeibarcodeScanRes;
    });
  }

  Future<void> SerialscanBarcodeNormal() async {
    try {
      StrSerialbarcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6667', 'Cancel Serial Scan', true, ScanMode.BARCODE);
      print(StrSerialbarcodeScanRes);
    } on PlatformException {
      StrSerialbarcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      data.serial= StrSerialbarcodeScanRes;
    });
  }
  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
    // setState(() {
    //   data.=barcodeScanRes;
    // });
  }

  Future webCall() async{
    // Showing CircularProgressIndicator using State.
    setState(() {
      visible = true ;
    });

    // API URL
    // var url = 'https://flutter-examples.000webhostapp.com/submit_data.php';
    Uri url = Uri.parse(data.url);

    // Store all data with Param Name.
    var jsondata = {
      'imei':data.imei,
      'serial':data.serial,
    };

    // Starting Web Call with data.
    var response = await http.post(url, body: json.encode(jsondata));
    // Getting Server response into variable.
    var message = jsonDecode(response.body);
    print ("the message is"+ message);
    // If Web call Success than Hide the CircularProgressIndicator.
    if(response.statusCode == 200){
      setState(() {
        visible = false;
      });
    }
    // Showing Alert Dialog with Response JSON.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(message),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                // Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Scan(),
                ));
              },
            ),
          ],
        );
      },
    );
  }


  int currStep = 0;
  static var _focusNode = new FocusNode();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static MyData data = new MyData();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
      print('Has focus: $_focusNode.hasFocus');
    });
  }

  @override
  void dispose() {
    // _focusNode.dispose();
    //super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    void showSnackBarMessage(String message,
        [MaterialColor color = Colors.red]) {
      Scaffold
          .of(context)
          .showSnackBar(new SnackBar(content: new Text(message)));
    }

    void _submitDetails() {
      final FormState formState = _formKey.currentState;
      if (!formState.validate()) {
        showSnackBarMessage('Please enter correct data');
      } else {
        formState.save();
        print("Imei: ${data.imei}");
        print("Serial: ${data.serial}");
        print("Url: ${data.url}");

        showDialog(
            context: context,
            builder:  (BuildContext context) {
              return AlertDialog(
                title: new Text("Confirm Details", style: TextStyle(fontWeight: FontWeight.bold,),),
                //content: new Text("Hello World"),
                content: new SingleChildScrollView(
                  child: new ListBody(
                    children: <Widget>[
                      Row( children: [Text("Imei:  ",style: TextStyle(fontWeight: FontWeight.bold),), Text(data.imei)],),
                      Row( children: [Text("Serial:  ",style: TextStyle(fontWeight: FontWeight.bold),), Text(data.serial)],),
                      Row( children: [Center(child: Text("URL:  ",style: TextStyle(fontWeight: FontWeight.bold),))]),
                      Text(data.url),
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    color: Colors.black12,
                    child: new Text('Back'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),  new FlatButton(
                    color: Colors.blue,
                    child: visible?     Container(
                            margin: EdgeInsets.only(bottom: 30),
                            child: CircularProgressIndicator()
                        )
                    : new Text('Post',style: TextStyle(fontWeight:FontWeight.bold,)),
                    onPressed: () {
                      //addData();
                      webCall();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
        );
      }
    }
    return new Container(
        child: Padding(
          padding:EdgeInsets.only(top:10),
          child: visible?

          Visibility(
              visible: visible,
              child: Padding(
                padding: EdgeInsets.only(left:10, right:10),
                child: Center(
                  child: Card(
                     // margin: EdgeInsets.only(bottom: 30),
                      child: Column( children: [
                        Text("Please Wait"),
                        LinearProgressIndicator(color: Colors.lightBlueAccent,)
                      ],)
                  ),
                ),
              )
          )
              :new Form(
            key: _formKey,
            child: new ListView(children: <Widget>[
              new Stepper(
                steps:  [
                  new Step(
                      title: const Text('Imei No.'),
                      //subtitle: const Text('Subtitle'),
                      isActive: true,
                      //state: StepState.editing,
                      state: StepState.indexed,
                      content: new TextFormField(
                        onTap: (){
                          ImeiscanBarcodeNormal();

                        },
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        /*  validator: (value) {
                          if (value.isEmpty || value.length < 1) {
                            return 'The imei is Wrong';
                          }
                        },*/
                        /*  onSaved: (String value) {
                          data.imei = value;
                        },*/
                        maxLines: 1,
                        decoration: new InputDecoration(
                            labelText: 'Tap to Scan Imei',
                            hintText: data.imei.isNotEmpty? data.imei : 'Scan Imei',
                            icon: const Icon(Icons.scanner),
                            labelStyle:
                            new TextStyle(decorationStyle: TextDecorationStyle.solid)),
                      )),
                  Step(
                      title: const Text('Serial No.'),
                      // subtitle: const Text('Subtitle'),
                      isActive: true,
                      state: StepState.indexed,
                      // state: StepState.disabled,
                      content: new TextFormField(
                        onTap: (){
                          SerialscanBarcodeNormal();
                        },
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        /*  validator: (value) {
                          if (value.isEmpty) {
                            return 'The Serial is Invalid';
                          }
                        },*/
                        /*  onSaved: (String value) {
                          data.serial = value;
                        },*/
                        maxLines: 1,
                        decoration: new InputDecoration(
                            labelText: 'Tap to Scan Serial No.',
                            hintText: data.serial.isNotEmpty? data.serial: 'Scan Serial',
                            icon: const Icon(Icons.scanner_outlined),
                            labelStyle:
                            new TextStyle(decorationStyle: TextDecorationStyle.solid)),
                      )),
                  new Step(
                      title: const Text('URL'),
                      // subtitle: const Text('Subtitle'),
                      isActive: true,
                      state: StepState.indexed,
                      content: new TextFormField(
                        keyboardType: TextInputType.url,
                        autocorrect: false,
                        validator: (value) {
                          if ( value.length < 5 ){
                            return 'Please enter a valid URl';
                          }
                        },
                        maxLines: 1,
                        onSaved: (String value) {
                          data.url = value;
                        },
                        decoration: new InputDecoration(
                            labelText: 'Enter your url to post',
                            hintText: 'Enter url',
                            icon: const Icon(Icons.http),
                            labelStyle:
                            new TextStyle(decorationStyle: TextDecorationStyle.solid)),
                      )),

                ],
                type: StepperType.vertical,
                currentStep: this.currStep,
                onStepContinue: () {
                  setState(() {
                    if (currStep < 2 ) {
                      currStep = currStep + 1;
                    } else {
                      currStep = 0;
                    }

                  });
                },
                onStepCancel: () {
                  setState(() {
                    if (currStep > 0) {
                      currStep = currStep - 1;
                    } else {
                      currStep = 0;
                    }
                  });
                },
                onStepTapped: (step) {
                  setState(() {
                    currStep = step;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 20,right: 20),
                child: new RaisedButton(
                  child: visible?
                      CircularProgressIndicator(color: Colors.blue,):
    new Text(
                    'Proceed',
                    style: new TextStyle(color: Colors.white),
                  ),
                  onPressed: _submitDetails,
                  color: Colors.blue,
                ),
              ),
            ]),
          ),
        ));
  }
}
