import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/storage_service.dart';
import '../../models/bhajan_model.dart';
import '../../models/category_model.dart';
import '../../models/notification_model.dart';
import '../../providers/bhajan_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/app_scaffold.dart';

class AddNotificationScreen extends StatefulWidget {

  final NotificationModel? notification;

  const AddNotificationScreen({

    super.key,

    this.notification,

  });

  @override
  State<AddNotificationScreen> createState() =>
      _AddNotificationScreenState();

}

class _AddNotificationScreenState
    extends State<AddNotificationScreen> {

  final _formKey =
      GlobalKey<FormState>();

  final _titleController =
      TextEditingController();

  final _descriptionController =
      TextEditingController();

  File? _imageFile;

  String _imageUrl = "";

  bool _loading = false;

  bool _status = true;

  String _type = "general";

  String _priority = "normal";

  CategoryModel? _selectedCategory;

  BhajanModel? _selectedBhajan;

  @override
  void initState() {

    super.initState();

    context
        .read<CategoryProvider>()
        .startListening();

    context
        .read<BhajanProvider>()
        .startListening();

    if (widget.notification != null) {

      final notification =
          widget.notification!;

      _titleController.text =
          notification.title;

      _descriptionController.text =
          notification.description;

      _imageUrl =
          notification.image;

      _type =
          notification.type;

      _priority =
          notification.priority;

      _status =
          notification.status;

WidgetsBinding.instance.addPostFrameCallback((_) {

  if (!mounted) return;

  if (notification.type == "category") {

    final categoryProvider =
        context.read<CategoryProvider>();

    if (categoryProvider.categories.isNotEmpty) {

      _selectedCategory =
          categoryProvider.categories.firstWhere(

        (e) => e.id == notification.targetId,

        orElse: () =>
            categoryProvider.categories.first,

      );

      setState(() {});

    }

  }

  if (notification.type == "bhajan") {

    final bhajanProvider =
        context.read<BhajanProvider>();

    if (bhajanProvider.bhajans.isNotEmpty) {

      _selectedBhajan =
          bhajanProvider.bhajans.firstWhere(

        (e) => e.id == notification.targetId,

        orElse: () =>
            bhajanProvider.bhajans.first,

      );

      setState(() {});

    }

  }

});
    }

  }
  
  Future<void> pickImage() async {

    final image = await ImagePicker().pickImage(

      source: ImageSource.gallery,

      imageQuality: 85,

    );

    if (image == null) {
      return;
    }

    setState(() {

      _imageFile = File(image.path);

    });

  }

  @override
  Widget build(BuildContext context) {

    final categoryProvider =
        context.watch<CategoryProvider>();

    final bhajanProvider =
        context.watch<BhajanProvider>();

    return AppScaffold(

      backgroundColor:
          const Color(0xffF8F8F8),

      appBar: AppBar(

        centerTitle: true,

        title: Text(

          widget.notification == null

              ? "Add Notification"

              : "Edit Notification",

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

            GestureDetector(

              onTap: pickImage,

              child: Container(

                height: 190,

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(16),

                  border: Border.all(

                    color: Colors.grey.shade300,

                  ),

                ),

                child: _imageFile != null

                    ? ClipRRect(

                        borderRadius:
                            BorderRadius.circular(16),

                        child: Image.file(

                          _imageFile!,

                          fit: BoxFit.cover,

                          width: double.infinity,

                        ),

                      )

                    : _imageUrl.isNotEmpty

                        ? ClipRRect(

                            borderRadius:
                                BorderRadius.circular(16),

                            child: Image.network(

                              _imageUrl,

                              fit: BoxFit.cover,

                              width: double.infinity,

                            ),

                          )

                        : Column(

                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: const [

                              Icon(

                                Icons.image,

                                size: 55,

                                color: Colors.grey,

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

              controller:
                  _titleController,

              decoration:
                  const InputDecoration(

                labelText:
                    "Notification Title",

                border:
                    OutlineInputBorder(),

              ),

              validator: (value) {

                if (value == null ||
                    value.trim().isEmpty) {

                  return "Enter title";

                }

                return null;

              },

            ),

            const SizedBox(height: 16),

            TextFormField(

              controller:
                  _descriptionController,

              minLines: 4,

              maxLines: 6,

              decoration:
                  const InputDecoration(

                labelText:
                    "Description",

                alignLabelWithHint: true,

                border:
                    OutlineInputBorder(),

              ),

              validator: (value) {

                if (value == null ||
                    value.trim().isEmpty) {

                  return "Enter description";

                }

                return null;

              },

            ),

            const SizedBox(height: 20),
            Text(

              "Notification Type",

              style: GoogleFonts.poppins(

                fontWeight: FontWeight.w600,

                fontSize: 16,

              ),

            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(

              value: _type,

              decoration: const InputDecoration(

                border: OutlineInputBorder(),

              ),

              items: const [

                DropdownMenuItem(

                  value: "general",

                  child: Text("General"),

                ),

                DropdownMenuItem(

                  value: "category",

                  child: Text("Category"),

                ),

                DropdownMenuItem(

                  value: "bhajan",

                  child: Text("Bhajan"),

                ),

              ],

              onChanged: (value) {

                setState(() {

                  _type = value!;

_selectedCategory = null;

_selectedBhajan = null;

FocusScope.of(context).unfocus();

                });

              },

            ),

            const SizedBox(height: 20),

            if (_type == "category")

              DropdownButtonFormField<CategoryModel>(

                value: _selectedCategory,

                decoration: const InputDecoration(

                  labelText: "Select Category",

                  border: OutlineInputBorder(),

                ),

                items: categoryProvider.categories

                    .map(

                      (category) =>

                          DropdownMenuItem(

                        value: category,

                        child: Text(

                          category.nameHi,

                        ),

                      ),

                    )

                    .toList(),

                validator: (value) {

                  if (_type == "category" &&
                      value == null) {

                    return "Select Category";

                  }

                  return null;

                },

                onChanged: (value) {

                  setState(() {

                    _selectedCategory = value;

                  });

                },

              ),

            if (_type == "category")

              const SizedBox(height: 20),

            if (_type == "bhajan")

              DropdownButtonFormField<BhajanModel>(

                value: _selectedBhajan,

                decoration: const InputDecoration(

                  labelText: "Select Bhajan",

                  border: OutlineInputBorder(),

                ),

                items: bhajanProvider.bhajans

                    .map(

                      (bhajan) =>

                          DropdownMenuItem(

                        value: bhajan,

                        child: Text(

                          bhajan.title,

                        ),

                      ),

                    )

                    .toList(),

                validator: (value) {

                  if (_type == "bhajan" &&
                      value == null) {

                    return "Select Bhajan";

                  }

                  return null;

                },

                onChanged: (value) {

                  setState(() {

                    _selectedBhajan = value;

                  });

                },

              ),

            if (_type == "bhajan")

              const SizedBox(height: 20),

            Text(

              "Priority",

              style: GoogleFonts.poppins(

                fontWeight: FontWeight.w600,

                fontSize: 16,

              ),

            ),

            const SizedBox(height: 10),

            Card(

              elevation: 0,

              child: Column(

                children: [

                  RadioListTile<String>(

                    value: "normal",

                    groupValue: _priority,

                    title: const Text(

                      "Normal",

                    ),

                    subtitle: const Text(

                      "Regular Notification",

                    ),

                    onChanged: (value) {

                      setState(() {

                        _priority = value!;

                      });

                    },

                  ),

                  const Divider(height: 1),

                  RadioListTile<String>(

                    value: "important",

                    groupValue: _priority,

                    title: const Text(

                      "Important",

                    ),

                    subtitle: const Text(

                      "Pinned & High Priority",

                    ),

                    onChanged: (value) {

                      setState(() {

                        _priority = value!;

                      });

                    },

                  ),

                ],

              ),

            ),

            const SizedBox(height: 20),

            SwitchListTile(

              value: _status,

              title: const Text(

                "Active Notification",

              ),

              subtitle: const Text(

                "Inactive notifications are hidden",

              ),

              onChanged: (value) {

                setState(() {

                  _status = value;

                });

              },

            ),

            const SizedBox(height: 30),
            SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton.icon(

                onPressed:
                    _loading
                        ? null
                        : saveNotification,

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      Colors.deepOrange,

                  foregroundColor:
                      Colors.white,

                  shape:
                      RoundedRectangleBorder(

                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),

                  ),

                ),

                icon:
                    _loading

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

                            widget.notification == null

                                ? Icons.notifications_active

                                : Icons.save,

                          ),

                label: Text(

                  widget.notification == null

                      ? "Publish Notification"

                      : "Update Notification",

                  style:
                      GoogleFonts.poppins(

                    fontSize: 16,

                    fontWeight:
                        FontWeight.w600,

                  ),

                ),

              ),

            ),

            const SizedBox(
              height: 30,
            ),

          ],

        ),

      ),

    );

  }

  Future<void> saveNotification() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }
if (_type == "category" &&
    _selectedCategory == null) {

  ScaffoldMessenger.of(context).showSnackBar(

    const SnackBar(

      content: Text(
        "Please select category",
      ),

    ),

  );

  return;

}

if (_type == "bhajan" &&
    _selectedBhajan == null) {

  ScaffoldMessenger.of(context).showSnackBar(

    const SnackBar(

      content: Text(
        "Please select bhajan",
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
    context.read<NotificationProvider>();

final String id =
    widget.notification?.id ??
        await provider.getNextId();

if (_imageFile != null) {

  _imageUrl =
      await StorageService.instance
          .uploadNotificationImage(

    file: _imageFile!,
    fileName: "$id.jpg",

  );

}

final notification =
    NotificationModel(

  id: id,

  title:
      _titleController.text.trim(),

  description:
      _descriptionController.text.trim(),

  image: _imageUrl,

  type: _type,

  targetId:

      _type == "category"

          ? _selectedCategory?.id ?? ""

          : _type == "bhajan"

              ? _selectedBhajan?.id ?? ""

              : "",

  targetName:

      _type == "category"

          ? _selectedCategory?.nameHi ?? ""

          : _type == "bhajan"

              ? _selectedBhajan?.title ?? ""

              : "",

  priority:
      _priority,

  status:
      _status,

  createdBy:

      AuthService.instance
              .currentUser
              ?.uid ??

          "",

  createdAt:

      widget.notification?.createdAt ??

      DateTime.now(),

);

      if (widget.notification == null) {

        await provider.addNotification(

          notification:
              notification,

        );

      } else {

        await provider.updateNotification(

          notification:
              notification,

        );

      }

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(

            widget.notification == null

                ? "Notification Published Successfully"

                : "Notification Updated Successfully",

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
  void dispose() {

    _titleController.dispose();

    _descriptionController.dispose();

    super.dispose();

  }

}