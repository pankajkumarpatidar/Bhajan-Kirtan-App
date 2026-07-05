import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/app_scaffold.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({
    super.key,
  });

  @override
  State<AboutScreen> createState() =>
      _AboutScreenState();
}

class _AboutScreenState
    extends State<AboutScreen> {

  final List<String> quotes = [

    "🙏 भक्ति ही जीवन का सच्चा मार्ग है।",

    "🙏 जहाँ भजन है, वहीं भगवान का वास है।",

    "🙏 राम नाम से बड़ा कोई सहारा नहीं।",

    "🙏 हरि स्मरण से मन को शांति मिलती है।",

    "🙏 कीर्तन से हृदय निर्मल होता है।",

    "🙏 सच्ची भक्ति ही सबसे बड़ा धन है।",

    "🙏 प्रभु का नाम ही जीवन का आधार है।",

    "🙏 हर दिन प्रभु को याद करें, जीवन सफल होगा।",

    "🙏 भजन मन को परम शांति प्रदान करता है।",

    "🙏 भगवान पर विश्वास ही सबसे बड़ी शक्ति है।",

    "🙏 सेवा, सुमिरन और सत्संग जीवन का सार है।",

    "🙏 जहाँ प्रेम है, वहीं परमात्मा हैं।",

    "🙏 प्रभु का स्मरण हर कठिनाई को सरल बना देता है।",

    "🙏 मन को शांति चाहिए तो प्रभु का नाम जपिए।",

    "🙏 जीवन की सबसे बड़ी संपत्ति भगवान का नाम है।",

    "🙏 भक्ति में ही सच्चा आनंद है।",

    "🙏 ईश्वर पर विश्वास कभी व्यर्थ नहीं जाता।",

    "🙏 नाम जप ही सबसे सरल साधना है।",

    "🙏 हर श्वास में प्रभु का स्मरण करें।",

    "🙏 प्रेम, सेवा और भक्ति ही जीवन का सार है।",

  ];

  late final String todayQuote;

  @override
  void initState() {

    super.initState();

    todayQuote = quotes[
      Random().nextInt(
        quotes.length,
      )
    ];

  }

  Future<void> openWhatsapp() async {

    final uri = Uri.parse(
      "https://wa.me/919340066006",
    );

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

  }

  Future<void> openInstagram() async {

    final uri = Uri.parse(
      "https://instagram.com/sakrani_kirtan",
    );

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

  }

  Future<void> callNow() async {

    final uri = Uri.parse(
      "tel:+919340066006",
    );

    await launchUrl(uri);

  }

  @override
  Widget build(BuildContext context) {

    return AppScaffold(

      backgroundColor:
          const Color(0xffF5F6FA),

      appBar: AppBar(

        centerTitle: true,

        title: Text(

          "About",

          style: GoogleFonts.poppins(

            fontWeight:
                FontWeight.w600,

          ),

        ),

      ),

      body: ListView(

        padding:
            const EdgeInsets.all(20),

        children: [

          Container(

            padding:
                const EdgeInsets.all(24),

            decoration: BoxDecoration(

              borderRadius:
                  BorderRadius.circular(24),

              gradient:
                  const LinearGradient(

                colors: [

                  Color(0xffFF9800),

                  Color(0xffF57C00),

                ],

                begin:
                    Alignment.topLeft,

                end: Alignment.bottomRight,

              ),

              boxShadow: [

                BoxShadow(

                  color:
                      Colors.orange.withOpacity(
                    .25,
                  ),

                  blurRadius: 18,

                  offset:
                      const Offset(0, 8),

                ),

              ],

            ),

            child: Column(

              children: [

                const CircleAvatar(

                  radius: 42,

                  backgroundColor:
                      Colors.white,

                  child: Icon(

                    Icons.music_note,

                    color: Colors.orange,

                    size: 42,

                  ),

                ),

                const SizedBox(height: 16),

                Text(

                  "Kirtan App",

                  style:
                      GoogleFonts.poppins(

                    color: Colors.white,

                    fontSize: 28,

                    fontWeight:
                        FontWeight.bold,

                  ),

                ),

                const SizedBox(height: 6),

                Text(

                  "Version 1.0.0",

                  style:
                      GoogleFonts.poppins(

                    color:
                        Colors.white70,

                  ),

                ),

                const SizedBox(height: 24),

                Text(

                  "🙏 आज का प्रेरणादायक विचार 🙏",

                  textAlign:
                      TextAlign.center,

                  style:
                      GoogleFonts.poppins(

                    color: Colors.white,

                    fontWeight:
                        FontWeight.w600,

                  ),

                ),

                const SizedBox(height: 14),

                Text(

                  todayQuote,

                  textAlign:
                      TextAlign.center,

                  style:
                      GoogleFonts.poppins(

                    color: Colors.white,

                    fontSize: 18,

                    fontWeight:
                        FontWeight.w500,

                    height: 1.6,

                  ),

                ),

              ],

            ),

          ),

          const SizedBox(height: 24),
          Card(

            elevation: 2,

            shape: RoundedRectangleBorder(

              borderRadius:
                  BorderRadius.circular(20),

            ),

            child: Padding(

              padding:
                  const EdgeInsets.all(20),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(

                    "🙏 ABOUT APP",

                    style:
                        GoogleFonts.poppins(

                      fontSize: 20,

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),

                  const SizedBox(height: 18),

                  Text(

                    "Kirtan App एक निःशुल्क आध्यात्मिक ऐप है।",

                    style:
                        GoogleFonts.poppins(

                      fontWeight:
                          FontWeight.w600,

                      fontSize: 15,

                    ),

                  ),

                  const SizedBox(height: 14),

                  Text(

                    "इसमें भजन, कीर्तन, आरती, सुंदरकाण्ड, चालीसा तथा अन्य धार्मिक सामग्री सरल, सुंदर एवं व्यवस्थित रूप में उपलब्ध कराई गई है।",

                    style:
                        GoogleFonts.poppins(

                      height: 1.8,

                    ),

                  ),

                  const SizedBox(height: 16),

                  Text(

                    "हमारा उद्देश्य भक्ति को हर घर तक पहुँचाना तथा श्रद्धालुओं को एक ही स्थान पर आध्यात्मिक सामग्री उपलब्ध कराना है।",

                    style:
                        GoogleFonts.poppins(

                      height: 1.8,

                    ),

                  ),

                  const SizedBox(height: 16),

                  Text(

                    'यह ऐप मध्यप्रदेश के नीमच जिले की जीरन तहसील के ग्राम "सकरानी जागीर" में स्थित "श्री बालाजी सुंदरकाण्ड मित्र मण्डल" द्वारा संचालित किया जाता है।',

                    style:
                        GoogleFonts.poppins(

                      height: 1.8,

                    ),

                  ),

                  const SizedBox(height: 16),

                  Text(

                    "यदि आप अपने भजन इस ऐप पर प्रकाशित करवाना चाहते हैं, अथवा आप हमारे आसपास के क्षेत्र से हैं और सुंदरकाण्ड पाठ, भजन संध्या या कीर्तन का आयोजन करवाना चाहते हैं, तो नीचे दिए गए माध्यमों से हमसे संपर्क कर सकते हैं।",

                    style:
                        GoogleFonts.poppins(

                      height: 1.8,

                    ),

                  ),

                ],

              ),

            ),

          ),

          const SizedBox(height: 24),

          Text(

            "📞 Contact Us",

            style:
                GoogleFonts.poppins(

              fontSize: 20,

              fontWeight:
                  FontWeight.bold,

            ),

          ),

          const SizedBox(height: 18),

          SizedBox(

            height: 56,

            width: double.infinity,

            child: ElevatedButton.icon(

              onPressed: openWhatsapp,

              style:
                  ElevatedButton.styleFrom(

                backgroundColor:
                    const Color(0xff25D366),

                foregroundColor:
                    Colors.white,

                shape:
                    RoundedRectangleBorder(

                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),

                ),

              ),

              icon: const Icon(
                Icons.chat,
              ),

              label: const Text(
                "WhatsApp",
              ),

            ),

          ),

          const SizedBox(height: 14),

          SizedBox(

            height: 56,

            width: double.infinity,

            child: ElevatedButton.icon(

              onPressed:
                  openInstagram,

              style:
                  ElevatedButton.styleFrom(

                backgroundColor:
                    const Color(0xffE1306C),

                foregroundColor:
                    Colors.white,

                shape:
                    RoundedRectangleBorder(

                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),

                ),

              ),

              icon: const Icon(
                Icons.camera_alt,
              ),

              label: const Text(
                "Instagram",
              ),

            ),

          ),

          const SizedBox(height: 14),

          SizedBox(

            height: 56,

            width: double.infinity,

            child: ElevatedButton.icon(

              onPressed: callNow,

              style:
                  ElevatedButton.styleFrom(

                backgroundColor:
                    Colors.orange,

                foregroundColor:
                    Colors.white,

                shape:
                    RoundedRectangleBorder(

                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),

                ),

              ),

              icon: const Icon(
                Icons.call,
              ),

              label: const Text(
                "Call Now",
              ),

            ),

          ),

          const SizedBox(height: 28),
          Card(

            elevation: 2,

            shape: RoundedRectangleBorder(

              borderRadius:
                  BorderRadius.circular(20),

            ),

            child: Padding(

              padding:
                  const EdgeInsets.all(20),

              child: Column(

                children: [

                  const Icon(

                    Icons.favorite,

                    color: Colors.red,

                    size: 42,

                  ),

                  const SizedBox(height: 12),

                  Text(

                    "Support This Project",

                    style:
                        GoogleFonts.poppins(

                      fontSize: 20,

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),

                  const SizedBox(height: 14),

                  Text(

                    "यदि आपको यह ऐप पसंद आए,\nतो कृपया इसे अपने परिवार,\nमित्रों एवं अन्य भक्तजनों के साथ अवश्य साझा करें।",

                    textAlign:
                        TextAlign.center,

                    style:
                        GoogleFonts.poppins(

                      height: 1.8,

                    ),

                  ),

                ],

              ),

            ),

          ),

          const SizedBox(height: 30),

          Center(

            child: Column(

              children: [

                Text(

                  "🙏 जय श्री राम 🙏",

                  style:
                      GoogleFonts.poppins(

                    fontSize: 22,

                    fontWeight:
                        FontWeight.bold,

                    color: Colors.orange,

                  ),

                ),

                const SizedBox(height: 14),

                Text(

                  "Developed by",

                  style:
                      GoogleFonts.poppins(

                    color: Colors.grey,

                  ),

                ),

                const SizedBox(height: 4),

                Text(

                  "Pankaj Patidar",

                  style:
                      GoogleFonts.poppins(

                    fontSize: 17,

                    fontWeight:
                        FontWeight.w600,

                  ),

                ),

                const SizedBox(height: 18),

                Text(

                  "© 2026 Kirtan App",

                  style:
                      GoogleFonts.poppins(

                    color: Colors.grey,

                  ),

                ),

                const SizedBox(height: 4),

                Text(

                  "Version 1.0.0",

                  style:
                      GoogleFonts.poppins(

                    color: Colors.grey,

                    fontSize: 12,

                  ),

                ),

                const SizedBox(height: 30),

              ],

            ),

          ),

        ],

      ),

    );

  }

}