import 'package:flutter/material.dart';

import 'pengumuman_page.dart';
import 'jadwal_seleksi_page.dart';
import 'hasil_seleksi_page.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  Widget infoCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.10),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: Colors.red,
            size: 27,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
        trailing: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 14,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
      ),
    );
  }

  Widget headerSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE53935),
            Color(0xFFB71C1C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(
            Icons.info_rounded,
            color: Colors.white,
            size: 42,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Pantau informasi penting seputar seleksi Paskibraka.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1.4,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pusat Informasi',
            style: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Pilih informasi yang ingin kamu lihat.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Info'),
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 110),
        children: [
          headerSection(),
          const SizedBox(height: 24),
          sectionTitle(),
          infoCard(
            context: context,
            icon: Icons.campaign_outlined,
            title: 'Pengumuman',
            subtitle: 'Lihat informasi terbaru dari panitia seleksi.',
            page: const PengumumanPage(),
          ),
          infoCard(
            context: context,
            icon: Icons.event_available_outlined,
            title: 'Jadwal Seleksi',
            subtitle: 'Lihat jadwal tahapan seleksi Paskibraka.',
            page: const JadwalSeleksiPage(),
          ),
          infoCard(
            context: context,
            icon: Icons.emoji_events_outlined,
            title: 'Hasil Seleksi',
            subtitle: 'Lihat hasil seleksi berdasarkan tahapan.',
            page: const HasilSeleksiPage(),
          ),
        ],
      ),
    );
  }
}