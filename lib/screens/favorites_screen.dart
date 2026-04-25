import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'history_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final String headerTitle = "Favorites";
  final String sourceLanguageLabel = "English";
  final String targetLanguageLabel = "Bikol";
  final String copySuccessMessage = "Copied to Clipboard";
  final String shareSubject = "Bikol Translation";
  final String sharePrefix = "Check out this favorite translation!";
  final String emptyMessage = "No favorites yet";

  Color _getPosColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'pron': return const Color(0xFFFFD54F);
      case 'verb': return const Color(0xFFA16BFF);
      case 'noun': return const Color(0xFF42A5F5);
      default: return const Color(0xFF7C83C4);
    }
  }

  void _shareContent(BuildContext context, String english, List<dynamic> bicolWords) {
    String bicolText = bicolWords.map((w) => w['word']).join(' ');
    final box = context.findRenderObject() as RenderBox?;
    Share.share(
      '$sharePrefix\n\n$sourceLanguageLabel: $english\n$targetLanguageLabel: $bicolText',
      subject: shareSubject,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  void _copyToClipboard(List<dynamic> bicolWords) {
    String bicolText = bicolWords.map((w) => w['word']).join(' ');
    Clipboard.setData(ClipboardData(text: bicolText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(copySuccessMessage),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- TOP HEADER AREA ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSearchIcon(),
              Text(
                headerTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'PoppinsBold',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.9),
                      offset: const Offset(2, 2),
                      blurRadius: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // --- MAIN WHITE CONTENT AREA ---
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: favoriteItems.isEmpty
                ? Center(child: Text(emptyMessage, style: const TextStyle(fontFamily: 'Poppins', color: Colors.grey)))
                : ListView.builder(
              padding: const EdgeInsets.only(top: 30, left: 40, right: 45, bottom: 100),
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) => _buildDismissibleFavoriteCard(index),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDismissibleFavoriteCard(int index) {
    final item = favoriteItems[index];
    return Dismissible(
      key: Key('fav_${item['en']}_$index'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          favoriteItems.removeAt(index);
        });
      },
      background: _buildDeleteBackground(),
      child: _buildFavoriteCard(item, index),
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> item, int index) {
    List<dynamic> bkWords;
    if (item['bk'] is String) {
      bkWords = [{"word": item['bk'], "tag": "Word"}];
    } else {
      bkWords = item['bk'] as List<dynamic>;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4FF),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: const Color(0xFFCDD0EC).withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(sourceLanguageLabel),
          Text(item['en']!,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF1D213B)),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: const Color(0xFF384087).withValues(alpha: 0.08), thickness: 1),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(targetLanguageLabel),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: bkWords.map((w) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              w['tag'] ?? "Word",
                              style: TextStyle(
                                fontSize: 9,
                                fontFamily: 'PoppinsBold',
                                color: _getPosColor(w['tag'] ?? "Word"),
                              ),
                            ),
                            Text(
                              w['word'] ?? "",
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: Color(0xFF1D213B)
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        favoriteItems.removeAt(index);
                      });
                    },
                    child: const Icon(
                      Icons.favorite_rounded,
                      size: 20,
                      color: Color(0xFFFAD02C),
                    ),
                  ),
                  const SizedBox(width: 14),
                  GestureDetector(
                    onTap: () => _copyToClipboard(bkWords),
                    child: _cardIcon(Icons.copy_rounded),
                  ),
                  const SizedBox(width: 14),
                  GestureDetector(
                    onTap: () => _shareContent(context, item['en']!, bkWords),
                    child: _cardIcon(Icons.share_outlined),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(text, style: const TextStyle(fontSize: 10, color: Color(0XFF7C83C4), fontFamily: 'PoppinsSemiBold'));

  Widget _cardIcon(IconData icon) => Icon(icon, size: 20, color: const Color(0xFF384087).withValues(alpha: 0.5));

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: const Color(0xFF7C83C4), borderRadius: BorderRadius.circular(23)),
      child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
    );
  }

  Widget _buildSearchIcon() {
    return Stack(
      children: [
        Transform.translate(
          offset: const Offset(2, 2),
          child: SvgPicture.asset(
            'assets/icons/Vector.svg',
            width: 30,
            colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.9), BlendMode.srcIn),
          ),
        ),
        SvgPicture.asset(
          'assets/icons/Vector.svg',
          width: 30,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ],
    );
  }
}