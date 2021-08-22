import 'package:arcadia/screens/Auction/auction_overview.dart';
import 'package:arcadia/screens/Player/formPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Player/player_dashboard.dart';

class Wrapper extends StatefulWidget {
  static const routeName = '/wrapper';

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isAdmin = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isData = false;
  bool isLoading = true;

  void initiate() async {
    var uid = auth.currentUser!.uid.toString();
    await FirebaseFirestore.instance.collection('Player').doc(uid).get().then(
      (value) {
        if (value.exists) {
          setState(() {
            isData = true;
            isAdmin = value.data()!['isAdmin'];
            isLoading = false;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initiate();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (isData) {
      return isAdmin ? AuctionOverview() : PlayerDashBoard();
    } else {
      return PlayerForm();
    }
  }
}
