import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomFooter extends StatelessWidget {
  const BottomFooter({super.key});

  // Links
  final String googleMapUrl =
      "https://www.google.com/maps/place/Aditya+Engineering+College+%26+Aditya+University";
  final String facebookUrl = "https://www.facebook.com/adityauniversity";
  final String twitterUrl = "https://twitter.com/adityauniv";
  final String youtubeUrl = "https://www.youtube.com/@adityauniversity";
  final String whatsappUrl = "https://wa.me/919898776661";
  final String instaUrl = "https://www.instagram.com/aditya_university/";

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 11, 45, 96), 
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      child: Column(
        children: [

          
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      "https://in8cdn.npfs.co/uploads/template/6102/1556/publish/images/au_logo.png?1737981139",
                      width: 140,
                      height: 100,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: _socialIcon(facebookUrl,
                              "https://cdn-icons-png.flaticon.com/512/733/733547.png"),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: _socialIcon(twitterUrl,
                              "https://cdn-icons-png.flaticon.com/512/733/733579.png"),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: _socialIcon(youtubeUrl,
                              "https://cdn-icons-png.flaticon.com/512/1384/1384060.png"),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: _socialIcon(whatsappUrl,
                              "https://cdn-icons-png.flaticon.com/512/733/733585.png"),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: _socialIcon(instaUrl,
                              "https://cdn-icons-png.flaticon.com/512/2111/2111463.png"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

             
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: ()=>_launchURL("https://aditya.ac.in"),
                        child: Text(
                          "ADITYA UNIVERSITY",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Aditya Nagar, ADB Road,\nSurampalem - 533437\nKakinada District, Andhra Pradesh, INDIA.",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "📞 0884-2326202\n📱 +91 99498 76662\n📱 +91 99897 76661\n📱 +91 70360 76661",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "✉ office@aec.edu.in",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

           
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "REACH US:",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => _launchURL(googleMapUrl),
                        child: Image.network(
                          "https://cache.careers360.mobi/media/colleges/staticmap/2025/8/7/2964.png",
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "OFFICES",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),

                    // Offices list
                    _officeLink("Corporate office"),
                    _officeLink("International Admissions"),
                    _officeLink("Bihar"),
                    _officeLink("Jharkhand"),
                    _officeLink("Kerala"),
                    _officeLink("Bangladesh"),
                    _officeLink("West Bengal"),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(color: Colors.white54),

          const SizedBox(height: 10),
          const Text(
            "© 2026 Aditya University. All rights reserved.",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(String url, String img) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Image.network(img, width: 22, height: 22),
    );
  }

  static Widget _officeLink(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text(
        "» $text",
        style: const TextStyle(color: Colors.blueAccent, fontSize: 14),
      ),
    );
  }
}
