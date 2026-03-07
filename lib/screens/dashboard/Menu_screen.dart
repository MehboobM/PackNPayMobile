import 'package:flutter/material.dart';
import 'package:pack_n_pay/screens/dashboard/widget/Drop_down_items.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      appBar: AppBar(
        title: const Text("Menus"),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children:  [
          MenuDropdown(
            title: "Home",
            icon: "assets/images/Home.png",
            children: [],
          ),

          MenuDropdown(
            title: "Survey List",
            icon: "assets/images/Survey.png",
            children: [
              MenuItem(title: "Survey list", icon: "assets/images/list.png"),
              MenuItem(title: "Add new survey", icon: "assets/images/add.png"),
              MenuItem(title: "Share survey link", icon: "assets/images/share.png"),
              MenuItem(title: "Generic survey link", icon: "assets/images/link.png"),
            ],
          ),

          MenuDropdown(
            title: "Quotation",
            icon: "assets/images/quotation.png",
            children: [],
          ),

          MenuDropdown(
            title: "Orders",
            icon: "assets/images/orders.png",
            children: [],
          ),

          MenuDropdown(
            title: "LR Bilty",
            icon: "assets/images/lr.png",
            children: [],
          ),

          MenuDropdown(
            title: "Money Receipt",
            icon: "assets/images/money.png",
            children: [],
          ),

          MenuDropdown(
            title: "Staffs",
            icon: "assets/images/staff.png",
            children: [],
          ),

          MenuDropdown(
            title: "Expanse Management",
            icon: "assets/images/expense.png",
            children: [],
          ),

          MenuDropdown(
            title: "Letter Head",
            icon: "assets/images/letter.png",
            children: [],
          ),
        ],
      ),
    );
  }
}