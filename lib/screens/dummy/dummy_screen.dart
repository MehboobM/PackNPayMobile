import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_pay/screens/dummy/widgets/details_upload_dialog.dart';
import 'package:pack_n_pay/screens/dummy/widgets/expense_popup.dart';
import 'package:pack_n_pay/screens/dummy/widgets/staff_labour_popup.dart';
import 'package:pack_n_pay/screens/dummy/widgets/vehicle_details.dart';
import '../../utils/app_colors.dart';

class DummyExpenseScreen extends ConsumerWidget {
  const DummyExpenseScreen({super.key});

  /// 📌 Expenses Popup
  void _showExpensesPopup(BuildContext context) {
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   barrierColor: Colors.black.withOpacity(0.5),
    //   builder: (context) => const ExpensesPopup(),
    // );
  }
  void _showVehiclePopup(BuildContext context) {
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   barrierColor: Colors.black.withOpacity(0.5),
    //   builder: (context) => const VehicleDetailsPopup(),
    // );
  }
  void _showStaff(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ManagePeoplePopup(
        title: "Manage Staff",
        people: [
          {"name": "Rakesh singh", "role": "Manager"},
        ],
      ),
    );
  }

  void _showLabour(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ManagePeoplePopup(
        title: "Manage Labours",
        people: [
          {"name": "Rakesh singh", "role": "Labour"},
          {"name": "David Elson", "role": "Labour"},
        ],
      ),
    );
  }

  /// 📌 Packing & Unpacking Details Popup
  void _showDetailsPopup(BuildContext context, String title) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => DetailsUploadPopup(
        title: title,
        hintText: "Enter a description...",
        onSave: (description, images) {
          debugPrint("Title: $title");
          debugPrint("Description: $description");
          debugPrint("Images Count: ${images.length}");
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bodysecondry,
      appBar: AppBar(
        title: const Text("Dummy Expense Screen"),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// 📦 Packing Details Button
            ElevatedButton.icon(
              onPressed: () =>
                  _showDetailsPopup(context, "Packing Details"),
              icon: const Icon(Icons.inventory_2_outlined),
              label: const Text("Packing Details"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
              ),
            ),

            const SizedBox(height: 12),

            /// 📦 Unpacking Details Button
            ElevatedButton.icon(
              onPressed: () =>
                  _showDetailsPopup(context, "Unpacking Details"),
              icon: const Icon(Icons.unarchive_outlined),
              label: const Text("Unpacking Details"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
              ),
            ),

            const SizedBox(height: 12),

            /// 💰 Expenses Button
            ElevatedButton.icon(
              onPressed: () => _showExpensesPopup(context),
              icon: const Icon(Icons.receipt_long),
              label: const Text("Add Expenses"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _showVehiclePopup(context),
              icon: const Icon(Icons.local_shipping_outlined),
              label: const Text("Vehicle Details"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _showStaff(context),
              icon: const Icon(Icons.people_alt_outlined),
              label: const Text("Manage Staff"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
              ),
            ),

            const SizedBox(height: 10),

            /// LABOUR
            ElevatedButton.icon(
              onPressed: () => _showLabour(context),
              icon: const Icon(Icons.engineering_outlined),
              label: const Text("Manage Labours"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}