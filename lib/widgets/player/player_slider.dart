import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerSlider extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<double> onChanged;

  const PlayerSlider({
    super.key,
    required this.position,
    required this.duration,
    required this.onChanged,
  });

  String format(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);

    if (hours > 0) {
      return "${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
    }

    return "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
  }

  @override
  Widget build(BuildContext context) {
    final max = duration.inSeconds == 0
        ? 1.0
        : duration.inSeconds.toDouble();

    final value = position.inSeconds
        .toDouble()
        .clamp(0.0, max);

    return Column(
      children: [

        SliderTheme(

          data: SliderTheme.of(context).copyWith(

            activeTrackColor: Colors.orange,

            inactiveTrackColor:
                Colors.orange.shade100,

            thumbColor: Colors.deepOrange,

            overlayColor:
                Colors.orange.withOpacity(.2),

            trackHeight: 4,

          ),

          child: Slider(

            value: value,

            min: 0,

            max: max,

            onChanged: onChanged,

          ),

        ),

        Row(

          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

          children: [

            Text(
              format(position),
              style: GoogleFonts.poppins(
                fontSize: 12,
              ),
            ),

            Text(
              format(duration),
              style: GoogleFonts.poppins(
                fontSize: 12,
              ),
            ),

          ],

        ),

      ],

    );
  }
}