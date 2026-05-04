import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../routes/route_names_const.dart';
import '../../../database/shared_preferences/shared_storage.dart';

class SetupPopup extends StatefulWidget {
  final VoidCallback onClose;

  const SetupPopup({
    super.key,
    required this.onClose,
  });

  @override
  State<SetupPopup> createState() => _SetupPopupState();
}

class _SetupPopupState extends State<SetupPopup> {
  final storage = StorageService();

  bool isBusinessCompleted = false;
  bool isSubscriptionCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadStatus(); // OK (no change needed)
  }

  /// ✅ Load status from storage
  Future<void> _loadStatus() async {
    final companyStatus = await storage.getCompanyStatus();
    final subscriptionStatus = await storage.getSubscriptionStatus();

    setState(() {
      isBusinessCompleted = companyStatus == "complete";
      isSubscriptionCompleted = subscriptionStatus == "complete";
    });

    /// Auto close if both done
    if (isBusinessCompleted && isSubscriptionCompleted) {
      Future.microtask(() => Navigator.pop(context));
    }
  }

  /// 🔹 Step 1 → Business
  Future<void> onBusinessTap() async {
    await Navigator.pushNamed(context, myBusinessRoute);

    /// 🔥 Reload status after coming back
    _loadStatus();
  }

  /// 🔹 Step 2 → Subscription
  Future<void> onSubscriptionTap() async {
    if (!isBusinessCompleted) return;

    await Navigator.pushNamed(context, PlansRoute);

    /// 🔥 Reload after payment
    _loadStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 420,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [

              /// 🔵 LEFT PANEL
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2F3A8F),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Complete Setup",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Finish 2 steps to unlock",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// Step 1
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: isBusinessCompleted
                                ? Colors.green
                                : Colors.white,
                            child: Text(
                              isBusinessCompleted ? "✓" : "1",
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              "Business",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 11),
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// Step 2
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: isBusinessCompleted
                                ? Colors.white
                                : Colors.white24,
                            child: Text(
                              "2",
                              style: TextStyle(
                                fontSize: 10,
                                color: isBusinessCompleted
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Subscription",
                              style: TextStyle(
                                color: isBusinessCompleted
                                    ? Colors.white
                                    : Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              /// ⚪ RIGHT PANEL
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// CLOSE
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: widget.onClose,
                          child: const Icon(Icons.close, size: 20),
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "Complete setup",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// STEP 1
                      GestureDetector(
                        onTap: onBusinessTap,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border:
                            Border.all(color: AppColors.primary),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius:
                                  BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.business,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),

                              const Expanded(
                                child: Text(
                                  "Business Details",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              const Icon(Icons.arrow_forward_ios,
                                  size: 13),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// STEP 2
                      GestureDetector(
                        onTap: isBusinessCompleted
                            ? onSubscriptionTap
                            : null,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isBusinessCompleted
                                ? Colors.white
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: isBusinessCompleted
                                ? Border.all(
                                color: AppColors.primary)
                                : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: isBusinessCompleted
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                  borderRadius:
                                  BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  isBusinessCompleted
                                      ? Icons.subscriptions
                                      : Icons.lock,
                                  size: 16,
                                  color: isBusinessCompleted
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 10),

                              Expanded(
                                child: Text(
                                  "Subscription",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isBusinessCompleted
                                        ? Colors.black
                                        : Colors.black45,
                                    fontWeight:
                                    isBusinessCompleted
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),

                              if (isBusinessCompleted)
                                const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 13),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}