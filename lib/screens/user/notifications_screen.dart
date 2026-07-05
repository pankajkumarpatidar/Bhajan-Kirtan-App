import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/notification_model.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/app_scaffold.dart';
import '../bhajan/bhajan_screen.dart';
import '../lyrics/lyrics_screen.dart';
import '../../repository/bhajan_repository.dart';

class NotificationsScreen extends StatefulWidget {

  const NotificationsScreen({
    super.key,
  });

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();

}

class _NotificationsScreenState
    extends State<NotificationsScreen> {

  @override
  void initState() {

    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {

      context
          .read<NotificationProvider>()
          .startListening();

    });

  }

  Future<void> _refresh() async {

    await context
        .read<NotificationProvider>()
        .refresh();

  }

  Future<void> _openNotification(

  NotificationProvider provider,

  NotificationModel notification,

) async {

  await provider.markAsRead(
    notification.id,
  );

  if (!mounted) return;

  switch (notification.type) {

    case "general":

      await showDialog(

        context: context,

        builder: (_) => AlertDialog(

          title: Text(
            notification.title,
          ),

          content: Text(
            notification.description,
          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(context);

              },

              child: const Text(
                "Close",
              ),

            ),

          ],

        ),

      );

      break;

    case "category":

      Navigator.push(

        context,

        MaterialPageRoute(

          builder: (_) => BhajanScreen(

            categoryId:
                notification.targetId,

            categoryName:
                notification.targetName,

          ),

        ),

      );

      break;

    case "bhajan":

      final bhajan =
          await BhajanRepository.instance
              .getById(

        notification.targetId,

      );

      if (!mounted) return;

      if (bhajan == null) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content: Text(
              "Bhajan not found.",
            ),

          ),

        );

        return;

      }

      Navigator.push(

        context,

        MaterialPageRoute(

          builder: (_) => LyricsScreen(

            bhajan: bhajan,

          ),

        ),

      );

      break;

    default:

      break;

  }

}

  @override
  Widget build(BuildContext context) {

    final provider =
        context.watch<NotificationProvider>();

    final notifications =
        provider.notifications;

    return AppScaffold(

      backgroundColor:
          const Color(0xffF8F8F8),

      appBar: AppBar(

        centerTitle: true,

        title: Text(

          "Notifications",

          style: GoogleFonts.poppins(

            fontWeight:
                FontWeight.w600,

          ),

        ),

      ),

      body: provider.loading

          ? const Center(

              child:
                  CircularProgressIndicator(),

            )

          : RefreshIndicator(

              onRefresh: _refresh,

              child: notifications.isEmpty

                  ? ListView(

                      children: [

                        const SizedBox(
                          height: 120,
                        ),

                        Icon(

                          Icons.notifications_off,

                          size: 90,

                          color:
                              Colors.grey.shade400,

                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Center(

                          child: Text(

                            "No Notifications",

                            style:
                                GoogleFonts.poppins(

                              fontSize: 20,

                              fontWeight:
                                  FontWeight.bold,

                            ),

                          ),

                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Center(

                          child: Text(

                            "Latest notifications will appear here.",

                            style:
                                GoogleFonts.poppins(

                              color: Colors.grey,

                            ),

                          ),

                        ),

                      ],

                    )

                  : ListView.separated(

                      padding:
                          const EdgeInsets.all(
                        16,
                      ),

                      itemCount:
                          notifications.length,

                      separatorBuilder:
                          (_, __) =>
                              const SizedBox(
                        height: 16,
                      ),

                      itemBuilder:
                          (context, index) {

                        final notification =
                            notifications[index];

                        final isRead =
                            provider.isRead(
                          notification.id,
                        );
                        return InkWell(

                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),

                          onTap: () async {

                            await _openNotification(

                              provider,

                              notification,

                            );

                          },

                          child: Card(

                            color: isRead

                                ? Colors.white

                                : Colors.orange.shade50,

                            elevation: 1,

                            margin: EdgeInsets.zero,

                            shape:
                                RoundedRectangleBorder(

                              borderRadius:
                                  BorderRadius.circular(
                                18,
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
                                        18,
                                      ),

                                      topRight:
                                          Radius.circular(
                                        18,
                                      ),

                                    ),

                                    child: Image.network(

                                      notification.image,

                                      width:
                                          double.infinity,

                                      height: 190,

                                      fit: BoxFit.cover,

                                      errorBuilder:

                                          (

                                        context,

                                        error,

                                        stackTrace,

                                      ) {

                                        return Container(

                                          width:
                                              double.infinity,

                                          height: 190,

                                          color: Colors
                                              .grey
                                              .shade200,

                                          child:
                                              const Center(

                                            child: Icon(

                                              Icons
                                                  .image_not_supported,

                                              size: 46,

                                            ),

                                          ),

                                        );

                                      },

                                    ),

                                  ),

                                Padding(

                                  padding:
                                      const EdgeInsets.all(
                                    16,
                                  ),

                                  child: Column(

                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,

                                    children: [

                                      Row(

                                        children: [

                                          Expanded(

                                            child: Text(

                                              notification
                                                  .title,

                                              style:
                                                  GoogleFonts.poppins(

                                                fontSize:
                                                    18,

                                                fontWeight:
                                                    FontWeight
                                                        .w600,

                                              ),

                                            ),

                                          ),

                                          if (notification
                                                  .priority ==
                                              "important")

                                            Container(

                                              padding:
                                                  const EdgeInsets.symmetric(

                                                horizontal:
                                                    10,

                                                vertical:
                                                    5,

                                              ),

                                              decoration:
                                                  BoxDecoration(

                                                color: Colors.red
                                                    .withOpacity(
                                                  0.12,
                                                ),

                                                borderRadius:
                                                    BorderRadius.circular(
                                                  30,
                                                ),

                                              ),

                                              child: Text(

                                                "IMPORTANT",

                                                style:
                                                    GoogleFonts.poppins(

                                                  color:
                                                      Colors.red,

                                                  fontWeight:
                                                      FontWeight.bold,

                                                  fontSize:
                                                      10,

                                                ),

                                              ),

                                            ),

                                        ],

                                      ),

                                      const SizedBox(
                                        height: 12,
                                      ),

                                      Text(

                                        notification
                                            .description,

                                        style:
                                            GoogleFonts.poppins(

                                          fontSize: 14,

                                          color: Colors
                                              .grey
                                              .shade700,

                                          height: 1.5,

                                        ),

                                      ),

                                      const SizedBox(
                                        height: 14,
                                      ),

                                      Row(

                                        children: [

                                          Icon(

                                            Icons.schedule,

                                            size: 16,

                                            color: Colors
                                                .grey
                                                .shade600,

                                          ),

                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(

                                            notification.createdAt == null

                                                ? ""

                                                : "${notification.createdAt!.day}/${notification.createdAt!.month}/${notification.createdAt!.year}",

                                            style:
                                                GoogleFonts.poppins(

                                              fontSize: 12,

                                              color: Colors.grey,

                                            ),

                                          ),

                                          const Spacer(),

                                          AnimatedContainer(

                                            duration:
                                                const Duration(
                                              milliseconds: 250,
                                            ),

                                            width: 10,

                                            height: 10,

                                            decoration:
                                                BoxDecoration(

                                              color: isRead

                                                  ? Colors.grey

                                                  : notification.priority ==
                                                          "important"

                                                      ? Colors.red

                                                      : Colors.green,

                                              shape:
                                                  BoxShape.circle,

                                            ),

                                          ),

                                        ],

                                      ),

                                    ],

                                  ),

                                ),

                              ],

                            ),

                          ),

                        );

                      },

                    ),

            ),

    );

  }

}