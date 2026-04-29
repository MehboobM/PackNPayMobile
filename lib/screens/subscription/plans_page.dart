import 'package:flutter/material.dart';
import 'package:dio/dio.dart';class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  int selectedIndex = 0;
  List<dynamic> apiPlans = [];
  bool isLoading = true;
  String? errorMessage;

  final String authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjE5LCJjb21wYW55X2lkIjoxMCwiY29tcGFueV9pZHMiOlsxMCwxMV0sImlhdCI6MTc3NjY4Nzg1OSwiZXhwIjoxNzc3MjkyNjU5fQ.IlY5FfknQSOAhdh30HJ8x8msHxxFUHq6SG_Ozy6HvDE";

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  Future<void> _fetchPlans() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final dio = Dio();
      final response = await dio.get(
        'http://192.168.0.247:5000/api/subscription/plans',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          // Adjust based on your API response structure.
          // If the list is inside a key, use response.data['data'] or similar.
          apiPlans = response.data is List ? response.data : (response.data['plans'] ?? []);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Failed to load plans. Check connection.";
      });
      debugPrint("Dio Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Design
          Positioned.fill(
            child: Image.network(
              'https://example.com/subback.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: const Color(0xFFFBFBFF)),
            ),
          ),
          SafeArea(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E3B8E)))
                : errorMessage != null
                ? _buildErrorState()
                : _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(errorMessage!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _fetchPlans, child: const Text("Retry")),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 10),
          _buildMainTitles(),
          const SizedBox(height: 25),
          _buildPlanGrid(),
          const SizedBox(height: 32),
          _buildFeaturesCard(),
          const SizedBox(height: 40),
          _buildBottomButton(),
          _buildLegalText(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Color(0xFF1A1A1A), size: 28),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/pandpplus.png',
              height: 42,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.inventory_2, color: Color(0xFF2E3B8E)),
                  const SizedBox(width: 8),
                  const Text("PackNPay",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Container(
                    margin: const EdgeInsets.only(left: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFF6D00),
                        borderRadius: BorderRadius.circular(4)),
                    child: const Text("PLUS",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainTitles() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: const [
          Text(
            "Your trusted moving partner in the palm of your hand",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: Color(0xFF000000),
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Make a commitment to stress-free relocation – for a smoother, happier move!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF5F6368),
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanGrid() {
    if (apiPlans.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: apiPlans.asMap().entries.map((entry) {
          int index = entry.key;
          var plan = entry.value;

          // Logic for dynamic tags based on index
          String tag = "BEST VALUE";
          if (index == 1) tag = "MOST POPULAR";
          if (index == 2) tag = "PREMIUM";

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: _buildPlanCard(
                tag,
                plan["plan_name"]?.toString().toUpperCase() ?? "PLAN",
                "₹${plan["price"]}",
                selectedIndex == index,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlanCard(String tag, String title, String price, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF2E3B8E) : const Color(0xFFE0E0E0),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? const Color(0xFF2E3B8E).withOpacity(0.1)
                : Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tag,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Color(0xFFFF6D00),
              letterSpacing: 0.1,
            ),
          ),
          Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: price,
                      style: const TextStyle(
                        color: Color(0xFF2E3B8E),
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const TextSpan(
                      text: "/m",
                      style: TextStyle(color: Color(0xFF757575), fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              "Save upto 25%",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontSize: 8,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFF2E3B8E) : const Color(0xFFBDBDBD),
                width: 1.5,
              ),
            ),
            child: isSelected
                ? Center(
              child: Container(
                width: 11,
                height: 11,
                decoration: const BoxDecoration(
                  color: Color(0xFF2E3B8E),
                  shape: BoxShape.circle,
                ),
              ),
            )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard() {
    if (apiPlans.isEmpty) return const SizedBox();

    String currentPlanName = apiPlans[selectedIndex]["plan_name"] ?? "PLAN";

    // Map 'benefits' from API if available, otherwise use fallback
    List<dynamic> features = apiPlans[selectedIndex]["benefits"] ?? [
      "Unlimited local move consultations",
      "Priority scheduling",
      "Free packing material tips",
      "Assistance with short-term relocations",
      "24/7 customer assistance",
      "Packing & unpacking guidance",
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -48,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFFFF3E0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.assignment_outlined,
                        size: 16, color: Color(0xFFFF6D00)),
                    const SizedBox(width: 8),
                    Text(
                      "${currentPlanName.toUpperCase()} PLAN FEATURES LIST",
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFFF6D00)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check, size: 18, color: Color(0xFFFF6D00)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        f.toString(),
                        style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF3C4043),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              )),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text("See more",
                          style: TextStyle(
                              color: Color(0xFF2E3B8E),
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                      Icon(Icons.keyboard_arrow_down,
                          size: 20, color: Color(0xFF2E3B8E)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    String price = apiPlans.isNotEmpty ? apiPlans[selectedIndex]["price"].toString() : "0";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {
          // Add subscription logic here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E3B8E),
          minimumSize: const Size(double.infinity, 56),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        child: Text(
          "Starting at ₹$price/m",
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLegalText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 18, 40, 0),
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(
              fontSize: 11,
              color: Color(0xFF70757A),
              height: 1.5,
              fontWeight: FontWeight.w400),
          children: [
            TextSpan(text: "By continuing you agree to our "),
            TextSpan(
              text: "Terms of services",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500),
            ),
            TextSpan(text: " and "),
            TextSpan(
              text: "Privacy Policy",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}