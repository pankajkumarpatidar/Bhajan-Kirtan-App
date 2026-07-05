import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/services/auth_service.dart';
import '../../models/category_model.dart';
import '../../providers/category_provider.dart';
import '../../widgets/app_scaffold.dart';
import 'add_category_screen.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({
    super.key,
  });

  @override
  State<ManageCategoriesScreen> createState() =>
      _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState
    extends State<ManageCategoriesScreen> {

  String _search = "";

  @override
  void initState() {
    super.initState();

    context
        .read<CategoryProvider>()
        .startListening();
  }

  @override
  Widget build(BuildContext context) {

    final provider =
        context.watch<CategoryProvider>();

    final bool isSuperAdmin =
        AuthService.instance.isSuperAdmin;

    final List<CategoryModel> categories =
        provider.categories.where((category) {

      final text =
          _search.toLowerCase();

      return category.name
              .toLowerCase()
              .contains(text) ||
          category.nameHi
              .toLowerCase()
              .contains(text);

    }).toList();

    return AppScaffold(

      backgroundColor:
          const Color(0xffF8F8F8),

      appBar: AppBar(

        centerTitle: true,

        title: Text(

          "Manage Categories",

          style: GoogleFonts.poppins(

            fontWeight:
                FontWeight.w600,

          ),

        ),

      ),

      floatingActionButton:
          FloatingActionButton.extended(

        backgroundColor: Colors.orange,

        icon: const Icon(
          Icons.add,
        ),

        label: const Text(
          "Add Category",
        ),

        onPressed: () async {

          await Navigator.push(

            context,

            MaterialPageRoute(

              builder: (_) =>
                  const AddCategoryScreen(),

            ),

          );

        },

      ),

      body: provider.loading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : Column(

              children: [

                Padding(

                  padding:
                      const EdgeInsets.all(16),

                  child: TextField(

                    decoration: InputDecoration(

                      hintText:
                          "Search Category",

                      prefixIcon:
                          const Icon(
                        Icons.search,
                      ),

                      filled: true,

                      fillColor:
                          Colors.white,

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),

                        borderSide:
                            BorderSide.none,

                      ),

                    ),

                    onChanged: (value) {

                      setState(() {

                        _search = value;

                      });

                    },

                  ),

                ),

                Expanded(

                  child: categories.isEmpty

                      ? const Center(

                          child: Text(
                            "No Categories Found",
                          ),

                        )

                      : ListView.builder(

                          padding:
                              const EdgeInsets.only(
                            bottom: 100,
                          ),

                          itemCount:
                              categories.length,

                          itemBuilder:
                              (context, index) {

                            final category =
                                categories[index];
                            return Card(

                              margin:
                                  const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  16,
                                ),
                              ),

                              child: ListTile(

                                leading:
                                    CircleAvatar(

                                  radius: 26,

                                  backgroundImage:
                                      category.icon
                                              .isNotEmpty
                                          ? NetworkImage(
                                              category.icon,
                                            )
                                          : null,

                                  child:
                                      category.icon.isEmpty

                                          ? const Icon(
                                              Icons.image,
                                            )

                                          : null,

                                ),

                                title: Text(

                                  category.name,

                                  style:
                                      GoogleFonts.poppins(

                                    fontWeight:
                                        FontWeight.w600,

                                  ),

                                ),

                                subtitle: Text(

                                  category.nameHi,

                                  style:
                                      GoogleFonts.poppins(),

                                ),

                                trailing:
                                    isSuperAdmin

                                        ? PopupMenuButton<String>(
                                  onSelected:
                                      (value) async {

                                    if (value ==
                                        "edit") {

                                      await Navigator.push(

                                        context,

                                        MaterialPageRoute(

                                          builder: (_) =>
                                              AddCategoryScreen(

                                            category:
                                                category,

                                          ),

                                        ),

                                      );

                                    }

                                    if (value ==
                                        "delete") {

                                      final confirm =
                                          await showDialog<bool>(

                                        context:
                                            context,

                                        builder: (_) =>
                                            AlertDialog(

                                          title: const Text(
                                            "Delete Category",
                                          ),

                                          content: Text(
                                            "Are you sure you want to delete '${category.name}' ?",
                                          ),

                                          actions: [

                                            TextButton(

                                              onPressed: () {

                                                Navigator.pop(
                                                  context,
                                                  false,
                                                );

                                              },

                                              child: const Text(
                                                "Cancel",
                                              ),

                                            ),

                                            ElevatedButton(

                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.red,
                                              ),

                                              onPressed: () {

                                                Navigator.pop(
                                                  context,
                                                  true,
                                                );

                                              },

                                              child: const Text(
                                                "Delete",
                                              ),

                                            ),

                                          ],

                                        ),

                                      );

                                      if (confirm ==
                                          true) {

                                        await provider
                                            .deleteCategory(
                                          category.id,
                                        );

                                      }

                                    }

                                  },

                                  itemBuilder:
                                      (context) => [

                                    const PopupMenuItem(

                                      value: "edit",

                                      child: Row(

                                        children: [

                                          Icon(
                                            Icons.edit,
                                          ),

                                          SizedBox(
                                            width: 10,
                                          ),

                                          Text(
                                            "Edit",
                                          ),

                                        ],

                                      ),

                                    ),

                                    const PopupMenuItem(

                                      value: "delete",

                                      child: Row(

                                        children: [

                                          Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),

                                          SizedBox(
                                            width: 10,
                                          ),

                                          Text(
                                            "Delete",
                                          ),

                                        ],

                                      ),

                                    ),

                                  ],

                                )

                                    : null,

                              ),

                            );

                          },

                        ),

                ),
                Padding(

                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),

                  child: Row(

                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [

                      Text(

                        "Total Categories : ${categories.length}",

                        style: GoogleFonts.poppins(

                          color: Colors.grey,

                          fontWeight: FontWeight.w500,

                        ),

                      ),

                      Container(

                        padding:
                            const EdgeInsets.symmetric(

                          horizontal: 12,

                          vertical: 6,

                        ),

                        decoration: BoxDecoration(

                          color: Colors.orange
                              .withValues(alpha: 0.12),

                          borderRadius:
                              BorderRadius.circular(20),

                        ),

                        child: Text(

                          "Active : ${categories.where((e) => e.status).length}",

                          style: GoogleFonts.poppins(

                            color: Colors.orange,

                            fontWeight: FontWeight.w600,

                            fontSize: 12,

                          ),

                        ),

                      ),

                    ],

                  ),

                ),

              ],

            ),

    );

  }

}