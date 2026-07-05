import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/storage_service.dart';
import '../../models/category_model.dart';
import '../../providers/category_provider.dart';
import '../../widgets/app_scaffold.dart';

class AddCategoryScreen extends StatefulWidget {
  final CategoryModel? category;

  const AddCategoryScreen({
    super.key,
    this.category,
  });

  @override
  State<AddCategoryScreen> createState() =>
      _AddCategoryScreenState();
}

class _AddCategoryScreenState
    extends State<AddCategoryScreen> {

  final _formKey =
      GlobalKey<FormState>();

  final _nameController =
      TextEditingController();

  final _nameHiController =
      TextEditingController();

  final _colorController =
      TextEditingController(
    text: "#FF9800",
  );

  final ImagePicker _picker =
      ImagePicker();

  File? _imageFile;

  String _imageUrl = "";

  String _oldImageUrl = "";

  bool _status = true;

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    if (widget.category != null) {

      _nameController.text =
          widget.category!.name;

      _nameHiController.text =
          widget.category!.nameHi;

      _colorController.text =
          widget.category!.color;

      _imageUrl =
          widget.category!.icon;

      _oldImageUrl =
          widget.category!.icon;

      _status =
          widget.category!.status;

    }
  }

  Future<void> pickImage() async {

    final image =
        await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1600,
    );

    if (image == null) return;

    setState(() {

      _imageFile =
          File(image.path);

    });

  }
  Future<void> saveCategory() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_imageFile == null &&
        _imageUrl.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select category image",
          ),
        ),
      );

      return;
    }

    setState(() {
      _loading = true;
    });

    try {

      final provider =
          context.read<CategoryProvider>();

      final order =
          widget.category == null
              ? await provider.getNextOrder()
              : widget.category!.order;

      final id =
          widget.category?.id ??
              _nameController.text
                  .trim()
                  .toLowerCase()
                  .replaceAll(" ", "_");

      String imageUrl = _imageUrl;

      /// Upload New Image
      if (_imageFile != null) {

        imageUrl =
            await StorageService.instance
                .replaceCategoryImage(

          file: _imageFile!,

          fileName: "$id.jpg",

          oldImageUrl: _oldImageUrl,

        );

      }

      final category = CategoryModel(

        id: id,

        name: _nameController.text.trim(),

        nameHi:
            _nameHiController.text.trim(),

        icon: imageUrl,

        color:
            _colorController.text.trim(),

        order: order,

        status: _status,

        createdBy:
            AuthService.instance
                    .currentUser
                    ?.uid ??
                "",

      );

      if (widget.category == null) {

        await provider.addCategory(
          category: category,
        );

      } else {

        await provider.updateCategory(
          category: category,
        );

      }

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(

            widget.category == null
                ? "Category Added Successfully"
                : "Category Updated Successfully",

          ),

        ),

      );

      Navigator.pop(context);

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),

      );

    } finally {

      if (mounted) {

        setState(() {
          _loading = false;
        });

      }

    }

  }
  @override
  Widget build(BuildContext context) {

    return AppScaffold(

      backgroundColor: const Color(0xffF8F8F8),

      appBar: AppBar(

        centerTitle: true,

        title: Text(

          widget.category == null
              ? "Add Category"
              : "Edit Category",

          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),

        ),

      ),

      body: Form(

        key: _formKey,

        child: ListView(

          padding: const EdgeInsets.all(20),

          children: [

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Category Name",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return "Enter Category Name";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _nameHiController,
              decoration: const InputDecoration(
                labelText: "Category Name (Hindi)",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return "Enter Hindi Name";
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            Text(
              "Category Image",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            GestureDetector(

              onTap: pickImage,

              child: Container(

                height: 190,

                decoration: BoxDecoration(

                  borderRadius:
                      BorderRadius.circular(16),

                  border: Border.all(
                    color: Colors.orange,
                  ),

                  color: Colors.grey.shade100,

                ),

                child: _imageFile != null

                    ? ClipRRect(

                        borderRadius:
                            BorderRadius.circular(16),

                        child: Image.file(

                          _imageFile!,

                          fit: BoxFit.cover,

                        ),

                      )

                    : _imageUrl.isNotEmpty

                        ? ClipRRect(

                            borderRadius:
                                BorderRadius.circular(16),

                            child: Image.network(

                              _imageUrl,

                              fit: BoxFit.cover,

                              errorBuilder:
                                  (context, error, stack) {

                                return const Center(

                                  child: Icon(

                                    Icons.broken_image,

                                    size: 70,

                                    color: Colors.grey,

                                  ),

                                );

                              },

                            ),

                          )

                        : Column(

                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: const [

                              Icon(

                                Icons.add_photo_alternate,

                                size: 60,

                                color: Colors.orange,

                              ),

                              SizedBox(height: 10),

                              Text(
                                "Tap to Select Image",
                              ),

                            ],

                          ),

              ),

            ),

            const SizedBox(height: 20),

            TextFormField(

              controller: _colorController,

              decoration: const InputDecoration(

                labelText: "Theme Color",

                hintText: "#FF9800",

                border: OutlineInputBorder(),

              ),

            ),

            const SizedBox(height: 15),

            SwitchListTile(

              title: const Text("Active"),

              value: _status,

              onChanged: (value) {

                setState(() {

                  _status = value;

                });

              },

            ),

            const SizedBox(height: 25),

            SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton.icon(

                onPressed:
                    _loading ? null : saveCategory,

                style: ElevatedButton.styleFrom(

                  backgroundColor: Colors.orange,

                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(

                    borderRadius:
                        BorderRadius.circular(14),

                  ),

                ),

                icon: _loading

                    ? const SizedBox(

                        width: 22,

                        height: 22,

                        child:
                            CircularProgressIndicator(

                          strokeWidth: 2,

                          color: Colors.white,

                        ),

                      )

                    : const Icon(Icons.save),

                label: Text(

                  widget.category == null
                      ? "Save Category"
                      : "Update Category",

                  style: GoogleFonts.poppins(

                    fontSize: 16,

                    fontWeight:
                        FontWeight.w600,

                  ),

                ),

              ),

            ),

            const SizedBox(height: 30),

          ],

        ),

      ),

    );

  }
  @override
  void dispose() {

    _nameController.dispose();

    _nameHiController.dispose();

    _colorController.dispose();

    super.dispose();

  }

}