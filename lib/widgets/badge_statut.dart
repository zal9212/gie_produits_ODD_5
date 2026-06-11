import 'package:flutter/material.dart';


class BadgeStatut extends StatelessWidget {
  final bool vendu;

  const BadgeStatut({super.key, required this.vendu});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        // operateur ternaire : si vendu > gris else vert
        color: vendu ? const Color(0xFFF1EFE8) : const Color(0xFFEAF3DE), borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        vendu ? 'Vendu' : 'En Stock',
        style: TextStyle(
            fontSize: 11,
            fontWeight:  FontWeight.w500,
            color: vendu ? const Color(0xFF5F5E5A) : const Color(0xFF3B6D11),
        ), 
      ),
    );
  }
}
