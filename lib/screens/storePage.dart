import 'package:case_store/components/my_button.dart';
import 'package:case_store/components/textbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

final _firestore = FirebaseFirestore.instance;
late User signInUser; //this give us the email

class StorePage extends StatefulWidget {
  const StorePage({super.key});
  static const String screenRoute = "StorePage";
  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  // final _auth = FirebaseAuth.instance; //to Connect To the firebase by email
  String? picUrl; //this give us the URL for the pic
  String? picPrice; //this give us the Pricefor the pic
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: ((context) {
                return AlertPage();
              }));
        },
      ),
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
            child: Column(
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
                  boxShadow: [
                    BoxShadow(
                        blurStyle: BlurStyle.outer,
                        color: Colors.black,
                        blurRadius: 25.0,
                        spreadRadius: 5.0,
                        offset: Offset.zero)
                  ],
                  border: Border.all(
                    width: 3,
                    strokeAlign: StrokeAlign.center,
                  ),
                ),
                child: Hero(
                  tag: "Image",
                  child: Image.network(
                    "https://cdn.cliqueinc.com/posts/294899/designer-phone-cases-294899-1650040053070-main.1200x0c.jpg?interlace=true&quality=70",
                    height: double.maxFinite,
                    width: double.maxFinite,
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                storeButtton(myicon: Icons.favorite, onpressed: () {}),
                Divider(
                  indent: 10,
                  thickness: 0,
                ),
                storeButtton(myicon: Icons.info, onpressed: () {}),
                Divider(
                  indent: 10,
                  thickness: 0,
                ),
                SizedBox(
                  height: 20,
                ),
                storeButtton(myicon: Icons.add_shopping_cart, onpressed: () {}),
              ],
            )
          ],
        )),
      ),
    );
  }
}

class AlertPage extends StatelessWidget {
  AlertPage({
    Key? key,
  }) : super(key: key);
  final imageUrlControl = TextEditingController();
  final priceConrol = TextEditingController();
  @override
  String? picUrl; //this give us the URL for the pic
  String? picPrice; //this give us the Pricefor the pic
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: [
          MyTextBox(
              onChanged: (value) {
                picUrl = value;
              },
              contlr: imageUrlControl,
              hintText: "Image URL",
              scureText: false),
          MyTextBox(
              onChanged: (value) {
                picUrl = value;
              },
              contlr: priceConrol,
              hintText: "Price",
              scureText: false),
          MyButton(
              color: Colors.green,
              onPressed: (() {
                print(signInUser);
                imageUrlControl.clear();
                priceConrol.clear();
                _firestore.collection("stuff").add(
                  {
                    "price": picPrice,
                    "url": picUrl,
                  },
                );
              }),
              title: "Add to store")
        ],
      ),
    );
  }
}
