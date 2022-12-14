import 'package:case_store/components/alerts.dart';
import 'package:case_store/components/my_button.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;

class itemPicPrice extends StatelessWidget {
  itemPicPrice({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        StreamBuilder(
            // Read or get item from firestore
            stream: FirebaseFirestore.instance.collection("stuff").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("there is an error");
              }
              if (snapshot.hasData) {
                final stuffs = snapshot.data!.docs;
                List<PicWidget> stuffWidgets = [];
                for (var stuff in stuffs) {
                  final stuffPrice = stuff['price'];
                  final stuffUrl = stuff['url'];
                  final stuffID = stuff['id'];
                  final stuffWidget = PicWidget(
                    picURL: stuffUrl,
                    pricePic: stuffPrice,
                    ID: stuffID,
                  );
                  stuffWidgets.add(stuffWidget);
                }
                return Column(
                  children: stuffWidgets,
                );
              }
              return const CircularProgressIndicator.adaptive();
            }),
      ],
    );
  }
}

class PicWidget extends StatefulWidget {
  PicWidget({super.key, required this.picURL, required this.pricePic, this.ID});
  String? picURL;
  String? pricePic;
  String? ID;
  @override
  State<PicWidget> createState() => _PicWidgetState();
}

class _PicWidgetState extends State<PicWidget> {
  bool like = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border: Border.all(
              width: 0,
              strokeAlign: StrokeAlign.outside,
            ),
            boxShadow: [
              BoxShadow(
                  blurStyle: BlurStyle.outer,
                  color: Colors.black,
                  blurRadius: 25.0,
                  spreadRadius: 10.0,
                  offset: Offset.zero)
            ],
          ),
          child: Image.asset(
            "images/${widget.picURL}.jpg",
            height: double.maxFinite,
            width: double.maxFinite,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          alignment: Alignment.center,
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  blurRadius: 25.0,
                  spreadRadius: 5.0,
                  offset: Offset.zero)
            ],
            border: Border.all(
              width: 0,
              strokeAlign: StrokeAlign.outside,
            ),
          ),
          child: Text(
            "${widget.pricePic}\$",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, color: Colors.black),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            storeButtton(
                myicon: Icons.favorite,
                onpressed: () {
                  setState(() {
                    like = !like;
                  });
                },
                iconColor: like ? Colors.red : Colors.black),
            Divider(
              indent: 10,
              thickness: 0,
            ),
            storeButtton(
                myicon: Icons.delete,
                onpressed: () async {
                  //delete item
                  await _firestore
                      .collection("stuff")
                      .doc(widget.ID)
                      .delete()
                      .then(
                        (doc) => print("Document deleted"),
                        onError: (e) => print("Error deleteing document  "),
                      );
                }),
            Divider(
              indent: 10,
              thickness: 0,
            ),
            SizedBox(
              height: 20,
            ),
            storeButtton(
                myicon: Icons.update,
                onpressed: () async {
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return AlertUpdate(
                          //update item
                          ID: widget.ID,
                        );
                      }));
                }),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
