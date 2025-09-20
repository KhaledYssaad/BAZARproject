import 'package:app/auth/auth_service.dart';
import 'package:app/constants/colors.dart';
import 'package:app/widgets/fav_cart_book.dart';
import 'package:app/widgets/notification.dart';
import 'package:app/widgets/service_not_available_yet.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<List<dynamic>> _fetchCartBooks() async {
    try {
      final authService = AuthService();
      String? id = authService.getCurrentUserId();
      if (id == null) throw Exception("No user logged in");
      final user = await authService.getUserProfile(id);
      if (user == null) throw Exception("User profile not found");
      List<dynamic> cartData = [];
      if (user['cart'] != null) {
        if (user['cart'] is List) {
          cartData = List.from(user['cart']);
        } else {
          throw Exception("Cart is not a valid JSON array");
        }
      }
      return cartData;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text(
          "My Cart",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Icon(Icons.join_left, color: Colors.white),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: NotificationButton(),
          ),
        ],
        toolbarHeight: 60,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchCartBooks(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error fetching book details",
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "Go add some books!!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            final books = snapshot.data as List<dynamic>;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        children: [
                          for (var book in books) ...[
                            FavCartBook(
                              book: book,
                              isCart: true,
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding, vertical: 16),
                    child: FractionallySizedBox(
                      widthFactor: 1.0,
                      child: FilledButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(AppColors.primaryPurple),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(48),
                            ),
                          ),
                          minimumSize: WidgetStateProperty.all(
                              const Size(double.infinity, 48)),
                        ),
                        onPressed: () {
                          ServiceNotAvailableYet.show(
                            context,
                            "we'll add it by CHARGILY PAY",
                          );
                        },
                        child: const Text(
                          "Buy Now!",
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            height: 1.4,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
