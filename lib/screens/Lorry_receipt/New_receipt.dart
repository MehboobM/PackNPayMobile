import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_pay/screens/Lorry_receipt/widgets/InsuranceForm.dart';
import 'package:pack_n_pay/screens/Lorry_receipt/widgets/Lr_stepper.dart';
import 'package:pack_n_pay/screens/Lorry_receipt/widgets/PackagePaymentForm.dart';
import 'package:pack_n_pay/screens/Lorry_receipt/widgets/consignorForm.dart';
import 'package:pack_n_pay/screens/Lorry_receipt/widgets/lr-details.dart';
import 'package:pack_n_pay/notifier/lr_provider.dart';

import '../../notifier/lorry_receiptnotifier.dart';
import '../../utils/m_font_styles.dart';

class NewLorryReceiptScreen extends ConsumerStatefulWidget {
  final String? uid;
  final bool isEdit;

  const NewLorryReceiptScreen({
    super.key,
    this.uid,
    this.isEdit = false,
  });

  @override
  ConsumerState<NewLorryReceiptScreen> createState() =>
      _NewLorryReceiptScreenState();
}

class _NewLorryReceiptScreenState
    extends ConsumerState<NewLorryReceiptScreen> {
  int currentStep = 0;

  late final List<Widget> steps;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (widget.isEdit && widget.uid != null) {
        try {
          final data = await ref
              .read(lorryReceiptProvider.notifier)
              .getLorryReceiptByUid(widget.uid!);

          ref.read(lrFormDataProvider.notifier).state = data;
        } catch (e) {
          debugPrint("Prefill failed: $e");
        }
      } else {
        ref.read(lrFormDataProvider.notifier).state = {};
      }
    });

    steps = [
      LRDetailsForm(onNext: goToNextStep),
      ConsignorForm(onNext: goToNextStep, onBack: goToPreviousStep),
      PackagePaymentForm(
          onNext: goToNextStep, onBack: goToPreviousStep),
      InsuranceForm(onNext: goToNextStep, onBack: goToPreviousStep),
    ];
  }

  /// ================= STEP NAVIGATION =================

  void goToNextStep() {
    if (_validateCurrentStep()) {
      if (currentStep < steps.length - 1) {
        setState(() {
          currentStep++;
        });
      }
    }
  }

  void goToPreviousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void onStepTapped(int index) {
    /// 🔒 Prevent forward navigation without validation
    if (index > currentStep) {
      if (!_validateCurrentStep()) return;
    }

    setState(() {
      currentStep = index;
    });
  }

  /// ================= VALIDATION HANDLER =================

  bool _validateCurrentStep() {
    switch (currentStep) {
      case 0:
        return _validateLRDetails();
      case 1:
        return _validateConsignor();
      case 2:
        return _validatePackage();
      case 3:
        return _validateInsurance();
      default:
        return true;
    }
  }

  /// ================= STEP 1 VALIDATION =================
  bool _validateLRDetails() {
    final data = ref.read(lrFormDataProvider);

    if ((data["order_id"] ?? "").toString().isEmpty) {
      _showError("Order ID is required");
      return false;
    }

    if ((data["lr_no"] ?? "").toString().isEmpty) {
      _showError("LR No is required");
      return false;
    }

    return true;
  }

  /// ================= STEP 2 VALIDATION =================
  bool _validateConsignor() {
    final data = ref.read(lrFormDataProvider);

    final from = data["consignor_from"] ?? {};
    final to = data["consignor_to"] ?? {};

    if ((from["name"] ?? "").toString().isEmpty) {
      _showError("Consignor name required");
      return false;
    }

    if ((to["name"] ?? "").toString().isEmpty) {
      _showError("Consignee name required");
      return false;
    }

    return true;
  }

  /// ================= STEP 3 VALIDATION =================
  bool _validatePackage() {
    final data = ref.read(lrFormDataProvider);
    final pkg = data["package_details"] ?? {};

    if ((pkg["no_of_package"] ?? "").toString().isEmpty) {
      _showError("No. of package required");
      return false;
    }

    if ((pkg["actual_weight"] ?? "").toString().isEmpty) {
      _showError("Actual weight required");
      return false;
    }

    return true;
  }

  /// ================= STEP 4 VALIDATION =================
  bool _validateInsurance() {
    // Optional validation
    return true;
  }

  /// ================= COMMON ERROR =================
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        title: Text(
          widget.isEdit ? "Edit LR" : "New LR",
          style: TextStyles.f16w600mGray9,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(bottom: 8),
                child: LRStepper(
                  currentStep: currentStep,
                  onStepTapped: onStepTapped,
                ),
              ),
              Container(
                height: 10,
                color: Colors.grey.shade300,
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: steps[currentStep],
      ),
    );
  }
}