import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';
import '../screens/user/notifications_screen.dart';

class CustomAppBar extends StatefulWidget {

  const CustomAppBar({
    super.key,
  });

  @override
  State<CustomAppBar> createState() =>
      _CustomAppBarState();

}

class _CustomAppBarState
    extends State<CustomAppBar> {

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

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding:
          const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        10,
      ),

      child: Row(

        children: [

          InkWell(

            borderRadius:
                BorderRadius.circular(14),

            onTap: () {

              Scaffold.of(context)
                  .openDrawer();

            },

            child: Container(

              height: 50,

              width: 50,

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  14,
                ),

                boxShadow: [

                  BoxShadow(

                    color: Colors.black
                        .withValues(
                      alpha: 0.05,
                    ),

                    blurRadius: 12,

                    offset:
                        const Offset(
                      0,
                      4,
                    ),

                  ),

                ],

              ),

              child: const Icon(

                Icons.menu_rounded,

                color: Colors.orange,

              ),

            ),

          ),

          const SizedBox(
            width: 16,
          ),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(

                  "🙏 Welcome",

                  style:
                      GoogleFonts.poppins(

                    color: Colors.grey,

                    fontSize: 13,

                  ),

                ),

                Text(

                  "Kirtan App",

                  style:
                      GoogleFonts.poppins(

                    fontWeight:
                        FontWeight.bold,

                    fontSize: 24,

                  ),

                ),

              ],

            ),

          ),

          Consumer<
              NotificationProvider>(

            builder:

                (
                  context,
                  provider,
                  child,
                ) {

              final unread =
                  provider
                      .totalNotifications;
              return Stack(

                clipBehavior: Clip.none,

                children: [

                  Container(

                    height: 50,

                    width: 50,

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),

                      boxShadow: [

                        BoxShadow(

                          color: Colors.black
                              .withValues(
                            alpha: 0.05,
                          ),

                          blurRadius: 12,

                        ),

                      ],

                    ),

                    child: IconButton(

                      onPressed: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                const NotificationsScreen(),

                          ),

                        );

                      },

                      icon: const Icon(

                        Icons.notifications_rounded,

                        color: Colors.orange,

                      ),

                    ),

                  ),

                  if (unread > 0)

                    Positioned(

                      right: -3,

                      top: -3,

                      child: Container(

                        padding:
                            const EdgeInsets.all(5),

                        constraints:
                            const BoxConstraints(

                          minWidth: 20,

                          minHeight: 20,

                        ),

                        decoration:
                            const BoxDecoration(

                          color: Colors.red,

                          shape: BoxShape.circle,

                        ),

                        child: Center(

                          child: Text(

                            unread > 99

                                ? "99+"

                                : unread.toString(),

                            style:
                                const TextStyle(

                              color: Colors.white,

                              fontSize: 10,

                              fontWeight:
                                  FontWeight.bold,

                            ),

                          ),

                        ),

                      ),

                    ),

                ],

              );

            },

          ),

        ],

      ),

    );

  }

}