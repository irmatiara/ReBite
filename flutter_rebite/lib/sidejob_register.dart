import 'package:flutter/material.dart';

class SidejobRegister extends StatelessWidget {
  const SidejobRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/sidejob-missions');
            }
          },
        ),
        title: const Text('Daftar Relawan Sidejob'),
        backgroundColor: const Color(0xFF2C5745),
        foregroundColor: const Color(0xFFEBE3A7),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.two_wheeler_rounded, size: 64, color: Color(0xFFEB7D00)),
            SizedBox(height: 16),
            Text(
              'Pendaftaran Relawan Kurir Sidejob',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
