import 'package:barcodescanner/scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:barcodescanner/post.dart';

class Home extends  StatefulWidget{
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home>  {

  var _nameController = new TextEditingController();
   String strImei, strSerial, strName,StrUrl;


  Future<void> ImeiscanBarcodeNormal() async {
    String StrImeibarcodeScanRes;
    try {
      StrImeibarcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel Imei Scan', true, ScanMode.BARCODE);
      print(StrImeibarcodeScanRes);
    } on PlatformException {
      StrImeibarcodeScanRes = 'Failed to get platform version.';
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      strImei=StrImeibarcodeScanRes;
    });
    SerialscanBarcodeNormal();
  }

  Future<void> SerialscanBarcodeNormal() async {
    String StrSerialbarcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      StrSerialbarcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6667', 'Cancel Serial Scan', true, ScanMode.BARCODE);
      print(StrSerialbarcodeScanRes);
    } on PlatformException {
      StrSerialbarcodeScanRes = 'Failed to get platform version.';
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      strSerial=StrSerialbarcodeScanRes;
    });
    scanQR();
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

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      StrUrl=barcodeScanRes;
    });

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: new Text('Barcode Scanner'),
      ),
      body: new Container(
        child: new Center(
          child: Column(
            children: <Widget>[

              Padding(
                child: new Text(
                  ' Barcode Scanner(1.Imei 2. Serial. 3. Url-QR)',
                  style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),
                  textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.only(bottom: 20.0),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Device name'),
                controller: _nameController,
              ),
              ElevatedButton(onPressed: (){
                ImeiscanBarcodeNormal();
              }, child: Text('Start Scanning')),
           _nameController.text!=null && strImei!= null && strSerial !=null?
              ElevatedButton(onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                        Post(name: _nameController.text,
                            imei: strImei,
                            serial: strSerial,
                            url: StrUrl)));
              }, child: Text('Proceed to Post on Database'))
            :
            ElevatedButton(onPressed: () {

            }, child: Text('Please Scan To Proceed'))

            ],
          ),
        ),
      ),
    );
  }
}


class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        body: new Home(),
      ),
    );
  }
}

void main() => runApp(new MyScanner());

