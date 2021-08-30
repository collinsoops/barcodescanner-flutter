import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class MyScanner extends StatefulWidget {
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

class MyAppScreenMode extends State<MyScanner> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Scanner'),
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
  Future<void> ImeiscanBarcodeNormal() async {
    String StrImeibarcodeScanRes;
    try {
      StrImeibarcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel Imei Scan', true, ScanMode.BARCODE);
      print(StrImeibarcodeScanRes);
    } on PlatformException {
      StrImeibarcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      data.imei=StrImeibarcodeScanRes;
      data.imei="676yuiui66786869yui";
    });
  }

  Future<void> SerialscanBarcodeNormal() async {
    String StrSerialbarcodeScanRes;
    try {
      StrSerialbarcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6667', 'Cancel Serial Scan', true, ScanMode.BARCODE);
      print(StrSerialbarcodeScanRes);
    } on PlatformException {
      StrSerialbarcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      data.serial=StrSerialbarcodeScanRes;
      data.serial="65757657657657657";
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
        print("Name: ${data.name}");
        print("Imei: ${data.imei}");
        print("Serial: ${data.serial}");
        print("Url: ${data.url}");

        showDialog(
            context: context,
            builder:  (BuildContext context) {
              return  AlertDialog(
                title: new Text("Details"),
                //content: new Text("Hello World"),
                content: new SingleChildScrollView(
                  child: new ListBody(
                    children: <Widget>[
                      new Text("Name : " + data.name),
                      new Text("Imei : " + data.imei),
                      new Text("Serial : " + data.serial),
                      new Text("URl : " + data.url),
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text('OK'),
                    onPressed: () {
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
          child: new Form(
            key: _formKey,
            child: new ListView(children: <Widget>[
              new Stepper(
                steps:  [
                  new Step(
                      title: const Text('Device name'),
                      //subtitle: const Text('Enter your name'),
                      isActive: true,
                      //state: StepState.error,
                      state: StepState.indexed,
                      content: new TextFormField(
                        focusNode: _focusNode,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        /*onSaved: (String value) {
                          data.name = value;
                        },*/
                        maxLines: 1,
                        validator: (value) {
                          if (value.isEmpty || value.length < 1) {
                            return 'Please enter name';
                          }
                        },
                        decoration: new InputDecoration(
                            labelText: 'Enter your name',
                            hintText: 'Enter a name',
                            //filled: true,
                            icon: const Icon(Icons.edit),
                            labelStyle:
                            new TextStyle(decorationStyle: TextDecorationStyle.solid)),
                      )),
                  new Step(
                      title: const Text('Imei'),
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
                        validator: (value) {
                          if (value.isEmpty || value.length < 10) {
                            return 'The imei is Wrong';
                          }
                        },
                      /*  onSaved: (String value) {
                          data.imei = value;
                        },*/
                        maxLines: 1,
                        decoration: new InputDecoration(
                            labelText: 'Enter Imei',
                            hintText: 'Enter Imei',
                            icon: const Icon(Icons.edit),
                            labelStyle:
                            new TextStyle(decorationStyle: TextDecorationStyle.solid)),
                      )),
                  Step(
                      title: const Text('Serial'),
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
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'The Serial is Invalid';
                          }
                        },
                      /*  onSaved: (String value) {
                          data.serial = value;
                        },*/
                        maxLines: 1,
                        decoration: new InputDecoration(
                            labelText: 'Enter your serial',
                            hintText: 'Enter serial',
                            icon: const Icon(Icons.edit),
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
                          if (value.isEmpty || value.length > 2 || !value.contains("http")) {
                            return 'Please enter a valid URl';
                          }
                        },
                        maxLines: 1,
                        onSaved: (String value) {
                          data.url = value;
                        },
                        decoration: new InputDecoration(
                            labelText: 'Enter your url',
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
                    if (currStep < 3 ) {
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
              new RaisedButton(
                child: new Text(
                  'Save details',
                  style: new TextStyle(color: Colors.white),
                ),
                onPressed: _submitDetails,
                color: Colors.blue,
              ),
            ]),
          ),
        ));
  }
}