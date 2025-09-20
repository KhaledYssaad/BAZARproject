import 'package:app/widgets/notification.dart';
import 'package:flutter/material.dart';
import 'package:app/home/homescreen/authors.dart';
import 'package:app/home/homescreen/special_offter.dart';
import 'package:app/home/homescreen/top_of_week.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onSeeAll;
  const HomeScreen({super.key, this.onSeeAll});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text(
          "Home",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Icon(Icons.search_rounded, color: Colors.black),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: NotificationButton(),
          ),
        ],
        toolbarHeight: 60, 
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpecialOffer(),
            const SizedBox(height: 20),
            TopOfWeek(onSeeAll: widget.onSeeAll),
            const SizedBox(height: 20),
            const Authors(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
