import 'package:flutter/material.dart';

class AdminFooter extends StatelessWidget {
  const AdminFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF060E57),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: const Column(
        children: [
          Text(
            '© 2025 University Guidance Counseling System Team. All rights reserved.',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TeamMember(name: 'Milwaukee'),
              _TeamMember(name: 'Sebastian'),
              _TeamMember(name: 'Emeliza'),
              _TeamMember(name: 'Rex'),
              _TeamMember(name: 'Princess'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TeamMember extends StatelessWidget {
  final String name;

  const _TeamMember({required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}