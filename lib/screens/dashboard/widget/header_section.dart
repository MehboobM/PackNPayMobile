import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(

      padding: const EdgeInsets.all(16),
      child: Row(
        children: [

          /// LOGO
          Image.asset(
            "assets/images/logo.png",
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),

          const SizedBox(width: 6),

          /// DEFAULT BUSINESS DROPDOWN
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  children: [
                    Text(
                      "Default Business",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        letterSpacing: 0,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 6,),
                    SizedBox(height: 10,width: 10,child: SvgPicture.asset("assets/images/arrow_down.svg")),
                  ]
              ),
              Text(
                "Acme Corporation pvt.Ltd",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,

                ),
              ),

            ],


          ),

          const Spacer(),

          /// NOTIFICATION BELL
          Stack(
            children: [
              const Icon(Icons.notifications_none, size: 28),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      "2",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),

          const SizedBox(width: 12),

          /// PROFILE IMAGE
          const CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage("assets/images/profile.png"),
          ),
        ],
      ),
    );
  }
}