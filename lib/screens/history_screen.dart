import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

List<Map<String, dynamic>> favoriteItems = [];
List<Map<String, dynamic>> historyItems = [];

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredItems = [];

  final String headerTitle = "History";
  final String sourceLanguageLabel = "English";
  final String targetLanguageLabel = "Bikol";
  final String copySuccessMessage = "Copied to Clipboard";
  final String shareSubject = "Bikol Translation";
  final String sharePrefix = "Check out this translation!";

  @override
  void initState(){
    super.initState();
    _filteredItems = List.from(historyItems);
  }

  void _runFilter(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(historyItems);
      } else {
        _filteredItems = historyItems.where(
        (item) {
          final english = item['en'].toString().toLowerCase();
          final bikol = (item['bk'] as List).map((w) => w['word']).join(' ').toLowerCase();
          return english.contains(query.toLowerCase()) || bikol.contains(query.toLowerCase());
      }).toList();
      }
    });
  }

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
    return Scaffold(
      backgroundColor: const Color(0xFF384087),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Animated search bar container
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _isSearching ? MediaQuery.of(context).size.width * 0.75 : 45,
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: _isSearching
                          ? Colors.white.withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSearching = !_isSearching;
                              if (!_isSearching) {
                                _searchController.clear();
                                _runFilter('');
                                FocusScope.of(context).unfocus();
                              }
                            });
                          },
                          child: _buildShadowedIcon(
                            assetPath: 'assets/icons/Vector.svg',
                            size: 28,
                            iconColor: _isSearching ? const Color(0xFFFFD54F) : Colors.white,
                          ),
                        ),
                        if (_isSearching)
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: _runFilter,
                              autofocus: true,
                              cursorColor: Colors.white,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'PoppinsBold',
                                fontSize: 18,
                              ),
                              decoration: const InputDecoration(
                                hintText: "Search",
                                hintStyle: TextStyle(color: Colors.white60),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 10, bottom: 5),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Show "History" only when not searching
                  if (!_isSearching)
                    Expanded(
                      child: Text(
                        headerTitle,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'PoppinsBold',
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.9),
                              offset: const Offset(2, 2),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
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
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 30, left: 40, right: 45, bottom: 20),
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) => _buildDismissibleCard(index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDismissibleCard(int index) {
    final item = _filteredItems[index];
    return Dismissible(
      key: Key('${item['en']}_$index'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
      setState(() {
        historyItems.removeWhere((e) => e['en'] == item['en']);
        _filteredItems.removeAt(index);
      });
    },
      background: _buildDeleteBackground(),
      child: _buildHistoryCard(item),
    );
  }


  Widget _buildHistoryCard(Map<String, dynamic> item) {
    bool isFavorited = favoriteItems.any((element) => element['en'] == item['en']);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _label(sourceLanguageLabel),
            ],
          ),
          const SizedBox(height: 2),
          Text(item['en']!,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Color(0xFF1D213B),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(
                color: const Color(0xFF384087).withValues(alpha: 0.08),
                thickness: 1),
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
                        if (isFavorited) {
                          favoriteItems.removeWhere((e) => e['en'] == item['en']);
                        } else {
                          favoriteItems.add(item);
                        }
                      });
                    },
                    child: Icon(
                      isFavorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: 17,
                      color: isFavorited
                          ? const Color(0xFFFAD02C)
                          : const Color(0xFF384087).withValues(alpha: 0.5),
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
                    child: SizedBox(
                      height: 14,
                      width: 14,
                      child: SvgPicture.asset(
                        'assets/icons/share.svg',
                      ),
                    )
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontSize: 10,
          color: Color(0XFF7C83C4),
          fontFamily: 'PoppinsSemiBold'));

  Widget _cardIcon(IconData icon) =>
      Icon(
          icon, size: 20,
          color: const Color(0xFF384087).withValues(alpha: 0.5));

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: const Color(0xFF7C83C4), borderRadius: BorderRadius.circular(23)),
      child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
    );
  }

  Widget _buildShadowedIcon({
    required String assetPath,
    double size = 30.0,
    Color iconColor = Colors.white,
    Color shadowColor = Colors.black,
    double shadowOpacity = 0.9,
    Offset shadowOffset = const Offset(2, 2),
  }) {
    return Stack(
      children: [
        Transform.translate(
          offset: shadowOffset,
          child: SvgPicture.asset(
            assetPath,
            width: size,
            colorFilter: ColorFilter.mode(
              shadowColor.withValues(alpha: shadowOpacity),
              BlendMode.srcIn,
            ),
          ),
        ),
        SvgPicture.asset(
          assetPath,
          width: size,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
      ],
    );
  }
}