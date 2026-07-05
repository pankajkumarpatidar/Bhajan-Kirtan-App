import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/services/auth_service.dart';
import '../../models/bhajan_model.dart';
import '../../models/category_model.dart';
import '../../providers/bhajan_provider.dart';
import '../../providers/category_provider.dart';
import '../../widgets/app_scaffold.dart';

class AddBhajanScreen extends StatefulWidget {

  final BhajanModel? bhajan;

  const AddBhajanScreen({
    super.key,
    this.bhajan,
  });

  @override
  State<AddBhajanScreen> createState() =>
      _AddBhajanScreenState();
}

class _AddBhajanScreenState
    extends State<AddBhajanScreen> {

  final _formKey =
      GlobalKey<FormState>();

  final _titleController =
      TextEditingController();

  final _lyricsController =
      TextEditingController();

  final _audioUrlController =
      TextEditingController();

  final _youtubeUrlController =
      TextEditingController();

  CategoryModel? _selectedCategory;

  bool _status = true;

  bool _loading = false;

  @override
  void initState() {

    super.initState();

    final categoryProvider =
        context.read<CategoryProvider>();

    if (categoryProvider.categories.isEmpty) {

      categoryProvider.startListening();

    }

    if (widget.bhajan != null) {

      final bhajan = widget.bhajan!;

      _titleController.text =
          bhajan.title;

      _lyricsController.text =
          bhajan.lyrics;

      _audioUrlController.text =
          bhajan.audioUrl;

      _youtubeUrlController.text =
          bhajan.youtubeUrl;

      _status =
          bhajan.status;

      WidgetsBinding.instance
          .addPostFrameCallback((_) {

        final provider =
            context.read<CategoryProvider>();

        try {

          _selectedCategory =
              provider.categories.firstWhere(

            (e) =>
                e.id ==
                bhajan.categoryId,

          );

          if (mounted) {

            setState(() {});

          }

        } catch (_) {}

      });

    }

  }
  Future<void> saveBhajan() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select category",
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
          context.read<BhajanProvider>();

      final String id =
          widget.bhajan?.id ??
              await provider.getNextId();

      final int order =
          widget.bhajan?.order ??
              await provider.getNextOrder();

      final bhajan = BhajanModel(

        id: id,

        categoryId:
            _selectedCategory!.id,

        title:
            _titleController.text.trim(),

        lyrics:
            _lyricsController.text.trim(),

        audioUrl:
            _audioUrlController.text.trim(),

        youtubeUrl:
            _youtubeUrlController.text.trim(),

        image:
            _selectedCategory!.icon,

        order: order,

        favoriteCount:
            widget.bhajan?.favoriteCount ?? 0,

        views:
            widget.bhajan?.views ?? 0,

        duration:
            widget.bhajan?.duration ?? "",

        status: _status,

        createdBy:
            AuthService.instance.currentUser?.uid ?? "",

      );

      if (widget.bhajan == null) {

        await provider.addBhajan(
          bhajan: bhajan,
        );

      } else {

        await provider.updateBhajan(
          bhajan: bhajan,
        );

      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: Text(

            widget.bhajan == null
                ? "Bhajan Added Successfully"
                : "Bhajan Updated Successfully",

          ),

        ),

      );

      Navigator.pop(context);

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(

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

    final categoryProvider =
        context.watch<CategoryProvider>();

    return AppScaffold(

      backgroundColor:
          const Color(0xffF8F8F8),

      appBar: AppBar(

        centerTitle: true,

        title: Text(

          widget.bhajan == null
              ? "Add Bhajan"
              : "Edit Bhajan",

          style: GoogleFonts.poppins(

            fontWeight:
                FontWeight.w600,

          ),

        ),

      ),

      body: Form(

        key: _formKey,

        child: ListView(

          padding:
              const EdgeInsets.all(20),

          children: [
            DropdownButtonFormField<CategoryModel>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
              items: categoryProvider.categories
                  .map(
                    (category) => DropdownMenuItem<CategoryModel>(
                      value: category,
                      child: Text(category.nameHi),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return "Please select category";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Bhajan Title",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return "Please enter bhajan title";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _lyricsController,
              minLines: 8,
              maxLines: 15,
              decoration: const InputDecoration(
                labelText: "Lyrics",
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return "Please enter lyrics";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _audioUrlController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: "Cloudinary Audio URL",
                hintText:
                    "https://res.cloudinary.com/...",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return null;
                }

                final url = value.trim();

                if (!url.startsWith("https://")) {
                  return "Enter a valid URL";
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _youtubeUrlController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: "YouTube URL (Optional)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            if (_selectedCategory != null)
              Card(
                elevation: 0,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage:
                        NetworkImage(
                      _selectedCategory!.icon,
                    ),
                  ),
                  title: Text(
                    _selectedCategory!.name,
                  ),
                  subtitle: Text(
                    _selectedCategory!.nameHi,
                  ),
                ),
              ),

            const SizedBox(height: 16),

            SwitchListTile(
              value: _status,
              title: const Text(
                "Active",
              ),
              onChanged: (value) {
                setState(() {
                  _status = value;
                });
              },
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed:
                    _loading ? null : saveBhajan,
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
                    : Icon(
                        widget.bhajan == null
                            ? Icons.add
                            : Icons.save,
                      ),
                label: Text(
                  widget.bhajan == null
                      ? "Save Bhajan"
                      : "Update Bhajan",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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

    _titleController.dispose();

    _lyricsController.dispose();

    _audioUrlController.dispose();

    _youtubeUrlController.dispose();

    super.dispose();

  }

}