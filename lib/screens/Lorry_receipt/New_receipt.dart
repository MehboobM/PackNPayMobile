import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_pay/screens/Lorry_receipt/widgets/InsuranceForm.dart';
import 'package:pack_n_pay/screens/Lorry_receipt/widgets/Lr_stepper.dart';
import 'package:pack_n_pay/screens/Lorry_receipt/widgets/PackagePaymentForm.dart';
import 'package:pack_n_pay/screens/Lorry_receipt/widgets/consignorForm.dart';
import 'package:pack_n_pay/screens/Lorry_receipt/widgets/lr-details.dart';
import 'package:pack_n_pay/notifier/lr_provider.dart';

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

  /// List of all step screens
  late final List<Widget> steps;

  @override
  void initState() {
    super.initState();

    /// Prefill form data in Edit Mode
    if (widget.isEdit) {
      Future.microtask(() {
        final data = ref.read(lrFormDataProvider);
        if (data.isNotEmpty) {
          ref.read(lrFormDataProvider.notifier).state = data;
        }
      });
    } else {
      /// Clear form for new LR
      Future.microtask(() {
        ref.read(lrFormDataProvider.notifier).state = {};
      });
    }

    steps = [
      LRDetailsForm(onNext: goToNextStep),
      ConsignorForm(onNext: goToNextStep, onBack: goToPreviousStep),
      PackagePaymentForm(
          onNext: goToNextStep, onBack: goToPreviousStep),
      InsuranceForm(onNext: goToNextStep, onBack: goToPreviousStep),
    ];
  }

  void goToNextStep() {
    if (currentStep < steps.length - 1) {
      setState(() {
        currentStep++;
      });
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
    setState(() {
      currentStep = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      /// 🔵 APPBAR + STEPPER
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

      /// 🔵 BODY
      body: SafeArea(
        child: steps[currentStep],
      ),
    );
  }
}