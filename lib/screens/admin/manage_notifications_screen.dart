import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/notification_model.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/app_scaffold.dart';
import 'add_notification_screen.dart';

class ManageNotificationsScreen extends StatefulWidget {

  const ManageNotificationsScreen({
    super.key,
  });

  @override
  State<ManageNotificationsScreen> createState() =>
      _ManageNotificationsScreenState();

}

class _ManageNotificationsScreenState
    extends State<ManageNotificationsScreen> {

  String _search = "";

  @override
  void initState() {

    super.initState();

    context
        .read<NotificationProvider>()
        .startAdminListening();

  }

  @override
  Widget build(BuildContext context) {

    final provider =
        context.watch<NotificationProvider>();

    final List<NotificationModel> notifications =
        provider.notifications.where((notification) {

      final text =
          _search.toLowerCase();

      return notification.title
              .toLowerCase()
              .contains(text) ||

          notification.description
              .toLowerCase()
              .contains(text);

    }).toList();

    return AppScaffold(

      backgroundColor:
          const Color(0xffF8F8F8),

      appBar: AppBar(

        centerTitle: true,

        title: Text(

          "Manage Notifications",

          style: GoogleFonts.poppins(

            fontWeight:
                FontWeight.w600,

          ),

        ),

      ),

      floatingActionButton:
          FloatingActionButton.extended(

        backgroundColor:
            Colors.deepOrange,

        icon: const Icon(
          Icons.notifications_active,
        ),

        label: const Text(
          "Add Notification",
        ),

        onPressed: () async {

          await Navigator.push(

            context,

            MaterialPageRoute(

              builder: (_) =>
                  const AddNotificationScreen(),

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
                          "Search Notification",

                      prefixIcon:
                          const Icon(Icons.search),

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

                  child:
                      notifications.isEmpty

                          ? const Center(

                              child: Text(
                                "No Notifications Found",
                              ),

                            )

                          : ListView.builder(

                              padding:
                                  const EdgeInsets.only(
                                bottom: 100,
                              ),

                              itemCount:
                                  notifications.length,

                              itemBuilder:
                                  (context, index) {

                                final notification =
                                    notifications[index];
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

                                  child: Column(

                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [

                                      if (notification
                                          .image
                                          .isNotEmpty)

                                        ClipRRect(

                                          borderRadius:
                                              const BorderRadius.only(

                                            topLeft:
                                                Radius.circular(
                                                    16),

                                            topRight:
                                                Radius.circular(
                                                    16),

                                          ),

                                          child:
                                              Image.network(

                                            notification
                                                .image,

                                            height: 180,

                                            width: double.infinity,

                                            fit: BoxFit.cover,

                                          ),

                                        ),

                                      Padding(

                                        padding:
                                            const EdgeInsets.all(
                                          14,
                                        ),

                                        child: Column(

                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,

                                          children: [

                                            Text(

                                              notification
                                                  .title,

                                              style:
                                                  GoogleFonts.poppins(

                                                fontSize:
                                                    17,

                                                fontWeight:
                                                    FontWeight.w600,

                                              ),

                                            ),

                                            const SizedBox(
                                              height: 6,
                                            ),

                                            Text(

                                              notification
                                                  .description,

                                              maxLines: 2,

                                              overflow:
                                                  TextOverflow
                                                      .ellipsis,

                                              style:
                                                  GoogleFonts.poppins(

                                                color:
                                                    Colors.grey
                                                        .shade700,

                                              ),

                                            ),

                                            const SizedBox(
                                              height: 12,
                                            ),

                                            Row(

                                              children: [

                                                Container(

                                                  padding:
                                                      const EdgeInsets.symmetric(

                                                    horizontal:
                                                        10,

                                                    vertical:
                                                        4,

                                                  ),

                                                  decoration:
                                                      BoxDecoration(

                                                    color: notification.priority ==
                                                            "important"

                                                        ? Colors.red.withValues(alpha: 0.12)

                                                        : Colors.green.withValues(alpha: 0.12),

                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20,
                                                    ),

                                                  ),

                                                  child: Text(

                                                    notification.priority ==
                                                            "important"

                                                        ? "Important"

                                                        : "Normal",

                                                    style:
                                                        GoogleFonts.poppins(

                                                      fontSize:
                                                          11,

                                                      fontWeight:
                                                          FontWeight.w600,

                                                      color: notification.priority ==
                                                              "important"

                                                          ? Colors.red

                                                          : Colors.green,

                                                    ),

                                                  ),

                                                ),

                                                const SizedBox(
                                                  width: 8,
                                                ),

                                                Container(

                                                  padding:
                                                      const EdgeInsets.symmetric(

                                                    horizontal:
                                                        10,

                                                    vertical:
                                                        4,

                                                  ),

                                                  decoration:
                                                      BoxDecoration(

                                                    color: Colors.orange
                                                        .withValues(alpha: 0.12),

                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20,
                                                    ),

                                                  ),

                                                  child: Text(

                                                    notification
                                                        .type
                                                        .toUpperCase(),

                                                    style:
                                                        GoogleFonts.poppins(

                                                      fontSize:
                                                          11,

                                                      fontWeight:
                                                          FontWeight.w600,

                                                      color:
                                                          Colors.orange,

                                                    ),

                                                  ),

                                                ),

                                                const Spacer(),

                                                PopupMenuButton<String>(
                                                  onSelected:
                                                      (value) async {

                                                    if (value ==
                                                        "edit") {

                                                      await Navigator.push(

                                                        context,

                                                        MaterialPageRoute(

                                                          builder: (_) =>
                                                              AddNotificationScreen(

                                                                notification:
                                                                    notification,

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

                                                          title:
                                                              const Text(
                                                            "Delete Notification",
                                                          ),

                                                          content:
                                                              Text(
                                                            "Are you sure you want to delete '${notification.title}' ?",
                                                          ),

                                                          actions: [

                                                            TextButton(

                                                              onPressed: () {

                                                                Navigator.pop(
                                                                  context,
                                                                  false,
                                                                );

                                                              },

                                                              child:
                                                                  const Text(
                                                                "Cancel",
                                                              ),

                                                            ),

                                                            ElevatedButton(

                                                              style:
                                                                  ElevatedButton.styleFrom(

                                                                backgroundColor:
                                                                    Colors.red,

                                                              ),

                                                              onPressed: () {

                                                                Navigator.pop(
                                                                  context,
                                                                  true,
                                                                );

                                                              },

                                                              child:
                                                                  const Text(
                                                                "Delete",
                                                              ),

                                                            ),

                                                          ],

                                                        ),

                                                      );

                                                      if (confirm ==
                                                          true) {

                                                        await provider
                                                            .deleteNotification(

                                                          notification.id,

                                                        );

                                                      }

                                                    }

                                                  },

                                                  itemBuilder:
                                                      (context) => [

                                                    const PopupMenuItem(

                                                      value:
                                                          "edit",

                                                      child: Row(

                                                        children: [

                                                          Icon(
                                                            Icons.edit,
                                                          ),

                                                          SizedBox(
                                                            width:
                                                                10,
                                                          ),

                                                          Text(
                                                            "Edit",
                                                          ),

                                                        ],

                                                      ),

                                                    ),

                                                    const PopupMenuItem(

                                                      value:
                                                          "delete",

                                                      child: Row(

                                                        children: [

                                                          Icon(

                                                            Icons.delete,

                                                            color:
                                                                Colors.red,

                                                          ),

                                                          SizedBox(
                                                            width:
                                                                10,
                                                          ),

                                                          Text(
                                                            "Delete",
                                                          ),

                                                        ],

                                                      ),

                                                    ),

                                                  ],

                                                ),

                                              ],

                                            ),

                                          ],

                                        ),

                                      ),

                                    ],

                                  ),

                                );

                              },

                            ),

                ),
                Padding(

                  padding:
                      const EdgeInsets.symmetric(

                    horizontal: 16,

                    vertical: 12,

                  ),

                  child: Row(

                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [

                      Text(

                        "Total : ${notifications.length}",

                        style:
                            GoogleFonts.poppins(

                          color: Colors.grey,

                          fontWeight:
                              FontWeight.w500,

                        ),

                      ),

                      Row(

                        children: [

                          Container(

                            padding:
                                const EdgeInsets.symmetric(

                              horizontal: 12,

                              vertical: 6,

                            ),

                            decoration:
                                BoxDecoration(

                              color: Colors.red
                                  .withValues(alpha: 0.12),

                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),

                            ),

                            child: Text(

                              "Important : ${notifications.where((e) => e.priority == "important").length}",

                              style:
                                  GoogleFonts.poppins(

                                color: Colors.red,

                                fontSize: 12,

                                fontWeight:
                                    FontWeight.w600,

                              ),

                            ),

                          ),

                          const SizedBox(
                            width: 8,
                          ),

                          Container(

                            padding:
                                const EdgeInsets.symmetric(

                              horizontal: 12,

                              vertical: 6,

                            ),

                            decoration:
                                BoxDecoration(

                              color: Colors.green
                                  .withValues(alpha: 0.12),

                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),

                            ),

                            child: Text(

                              "Normal : ${notifications.where((e) => e.priority == "normal").length}",

                              style:
                                  GoogleFonts.poppins(

                                color: Colors.green,

                                fontSize: 12,

                                fontWeight:
                                    FontWeight.w600,

                              ),

                            ),

                          ),

                        ],

                      ),

                    ],

                  ),

                ),

              ],

            ),

    );

  }

}