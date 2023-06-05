

// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:textile_service/Utils/app_constant.dart';

class QRDialog extends StatefulWidget {
  final String id;
  const QRDialog({super.key, required this.id});

  @override
  State<QRDialog> createState() => _QRDialogState();
}

class _QRDialogState extends State<QRDialog> {
  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double statusBarHeight= MediaQuery.of(context).padding.top;



    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: const EdgeInsets.only(top:0),
      backgroundColor: AppConstant.backgroundColor,
      content: Container(
        decoration: BoxDecoration(
            color:  AppConstant.backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(20.0))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(
                  left: 30, right: 30, top: 12, bottom: 10),
              child: Text(
                "QR Code",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(
              color: Colors.grey,
              height: 4.0,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.03, right: width * 0.03, top: width * 0.012, bottom: width * 0.012),
              child: Container(
                height: height * 0.3,
                width: width * 0.3,
                alignment: Alignment.center,
                color: AppConstant.backgroundColor,
                child: QrImage(
                  data: 'TMS${widget.id}',
                  version: QrVersions.auto,
                  foregroundColor: AppConstant.primaryTextDarkColor,
                  dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square),
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
              height: 4.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 10.0, bottom: 10),
              child: GestureDetector(
                onTap: () async {
                    Navigator.pop(context);
                },
                child: Container(
                  height: 42,
                  width: width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(04),
                    color: AppConstant.primaryColor,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Close',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

