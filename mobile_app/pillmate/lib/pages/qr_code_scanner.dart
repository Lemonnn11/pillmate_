import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillmate/pages/add_drug.dart';
import 'package:pillmate/pages/drug_information.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vibration/vibration.dart';

import '../services/sqlite_service.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({super.key});

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;
  bool isNavigate = false;
  bool editFontsize = false;
  int change = 0;
  late SqliteService _sqliteService;
  RegExp pattern = RegExp(r'^[0-9]+$');

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }


  Future<void> initFontSize() async {
    bool status = await _sqliteService.getEditFontSizeStatus();
    int change = await _sqliteService.getFontSizeChange();
    setState(() {
      editFontsize = status;
      this.change = change;
    });
  }

  @override
  void initState() {
    super.initState();
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
    initFontSize();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff484848),
        automaticallyImplyLeading: false,
        toolbarHeight: 45,
        title: Padding(
          padding: EdgeInsets.only(top: 5, left: screenWidth*0.1),
          child: Text(
            'สแกน QR code',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'PlexSansThaiSm',
                color: Colors.white
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Ionicons.chevron_back_outline, color: Colors.white,), onPressed: () {
            Navigator.pop(context);
        },

        ),
      ),
      body: Center(
        child: Stack(
          children: [
            buildQrView(context),
            Positioned(
              left: screenWidth*0.078,
              top: screenHeight*0.2,
              child: Container(
                width: screenWidth*0.85,
                child: Text('สแกนเพื่อดูข้อมูลยาโดย\nให้ตำแหน่ง QR code อยู่ตรงกลางภาพ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: editFontsize ?  16 + change.toDouble() : 16,
                  fontFamily: 'PlexSansThaiRg',
                  color: Colors.white
                ),),
              ),
            ),
            Positioned(
              bottom: 30,
                left: 20,
                child: GestureDetector(
                  onTap: () async {
                    await controller?.toggleFlash();
                    setState(() {
                    });
                  },
                      child: FutureBuilder<bool?>(
                          future: controller?.getFlashStatus(),
                          builder: (context, snapshot){
                            if(snapshot.data != null){
                              return snapshot.data! ?
                              Column(
                                children: [
                                  Column(
                                    children: [
                                      CircleAvatar(
                                          radius: 19,
                                          backgroundColor: Color(0xff059E78),
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xff484848),
                                        radius: 18,
                                        child: Container(
                                          width: 20,
                                          child: Image.asset(
                                              'icons/flashlight-off.png',
                                          ),
                                        ),
                                      )),
                                      Text(
                                        'เปิดไฟฉาย',
                                        style: TextStyle(
                                            fontSize: editFontsize ?  12 + change.toDouble() : 12,
                                            fontFamily: 'PlexSansThaiRg',
                                            color: Color(0xff059E78)
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ):
                              Column(
                                children: [
                                  CircleAvatar(
                                      radius: 19,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                    backgroundColor: Color(0xff484848),
                                    radius: 18,
                                    child: Container(
                                      width: 20,
                                      child: Image.asset(
                                        'icons/flashlight.png',
                                      ),
                                    ),
                                  )),
                                  Text(
                                    'เปิดไฟฉาย',
                                    style: TextStyle(
                                        fontSize: editFontsize ?  12 + change.toDouble() : 12,
                                        fontFamily: 'PlexSansThaiRg',
                                        color: Colors.white
                                    ),
                                  ),
                                ],
                              );
                            }
                            else{
                              return Container();
                            }
                          },
                        ),
                )
            )
          ],
        ),
      )
    );
  }


  Widget buildQrView(BuildContext context) => QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        cutOutSize: MediaQuery.of(context).size.width * 0.7,
        borderWidth: 6,
        borderLength: 137,
        borderColor: Color(0xff059E78),
        borderRadius: 10,
      ),
  );

  void onQRViewCreated(QRViewController controller){
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((barcode) => {
    if(!isNavigate && barcode != null && !pattern.hasMatch(barcode!.code.toString())){
      isNavigate = true,
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDrug(info: barcode!.code.toString()),
      ),
      ).then((_){
        isNavigate = false;
        controller.dispose();
      })
    }
    });
  }

  void reassemble() async {
    super.reassemble();

    if(Platform.isAndroid){
      await controller!.pauseCamera();
    }
    controller?.resumeCamera();
  }
}
