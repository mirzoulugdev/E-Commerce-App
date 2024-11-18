import 'package:flutter/material.dart';

class CustomCart extends StatelessWidget {
  final Widget child;
  final String number;
  const CustomCart({
    super.key,
    required this.child,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              alignment: Alignment.center,
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 8,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
