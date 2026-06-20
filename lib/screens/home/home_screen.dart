import 'package:flutter/material.dart';

import '../../widgets/category_card.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/section_title.dart';
import '../bhajan/bhajan_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Map<String, dynamic>> categories = [

    {
      "id": "radha_krishna",
      "title": "राधा कृष्ण",
      "image": "radha.png",
      "color": Color(0xffFF9800),
    },

    {
      "id": "shree_ram",
      "title": "श्री राम",
      "image": "ram.png",
      "color": Color(0xffE53935),
    },

    {
      "id": "hanuman",
      "title": "हनुमान",
      "image": "hanuman.png",
      "color": Color(0xffFF7043),
    },

    {
      "id": "shiv",
      "title": "शिव",
      "image": "shiv.png",
      "color": Color(0xff5E35B1),
    },

    {
      "id": "ganesh",
      "title": "गणेश",
      "image": "ganesh.png",
      "color": Color(0xffFB8C00),
    },

    {
      "id": "khatu_shyam",
      "title": "खाटू श्याम",
      "image": "khatu.png",
      "color": Color(0xff8E24AA),
    },

    {
      "id": "navdurga",
      "title": "नवदुर्गा",
      "image": "durga.png",
      "color": Color(0xffD81B60),
    },

    {
      "id": "aarti",
      "title": "आरती संग्रह",
      "image": "aarti.png",
      "color": Color(0xff00897B),
    },

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(

        child: CustomScrollView(

          slivers: [

            const SliverToBoxAdapter(
              child: CustomAppBar(),
            ),

            const SliverToBoxAdapter(
              child: SearchBarWidget(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 15),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: Container(

                  height: 180,

                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(24),

                    gradient: const LinearGradient(

                      colors: [

                        Color(0xffFF9800),

                        Color(0xffFF6F00),

                      ],

                    ),

                  ),

                  child: const Center(

                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [

                        Text(

                          "🌸 आज का विशेष भजन 🌸",

                          style: TextStyle(

                            color: Colors.white,

                            fontSize: 24,

                            fontWeight: FontWeight.bold,

                          ),

                        ),

                        SizedBox(height: 10),

                        Text(

                          "राधे राधे जपो चले आएंगे बिहारी",

                          style: TextStyle(

                            color: Colors.white,

                            fontSize: 17,

                          ),

                        ),

                      ],

                    ),

                  ),

                ),

              ),

            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 25),
            ),

            const SliverToBoxAdapter(
              child: SectionTitle(
                title: "भजन श्रेणियाँ",
              ),
            ),
const SliverToBoxAdapter(
              child: SizedBox(height: 15),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = categories[index];

                    return CategoryCard(
                      title: category["title"] as String,
                      image: category["image"] as String,
                      color: category["color"] as Color,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BhajanScreen(
                              categoryId: category["id"] as String,
                              categoryName: category["title"] as String,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  childCount: categories.length,
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.92,
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],
        ),
      ),
    );
  }
}