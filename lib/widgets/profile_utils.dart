import 'package:flutter/material.dart';

Widget buildProfileHeader(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'PoppinsBold',
                fontSize: 22,
              ),
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    ),
  );
}

BoxDecoration profileContainerDecoration() {
  return const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(50),
      topRight: Radius.circular(50),
    ),
  );
}