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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.search_rounded, color: Colors.black),
                Text(
                  "Home",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
                NotificationButton(),
              ],
            ),
          ),
        ),
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
