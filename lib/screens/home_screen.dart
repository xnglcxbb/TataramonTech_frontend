import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'history_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, this.userName = "Sophia Thompson"});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _inputController = TextEditingController();
  int _currentNavIndex = 0;
  String translatedText = "";
  bool showBreakdown = false;

  List<Map<String, String>> currentPosDataBikol = [];
  List<Map<String, String>> currentPosDataEnglish = [];

  List<Widget> get _screens => [
    _buildTranslationBody(),
    HistoryScreen(key: UniqueKey()),
    FavoritesScreen(key: UniqueKey()),
    const ProfileScreen(),
  ];

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Color _getPosColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'pron': return const Color(0xFFFFD54F);
      case 'verb': return const Color(0xFFA16BFF);
      case 'noun': return const Color(0xFF42A5F5);
      default: return const Color(0xFF384087);
    }
  }

  void _handleTranslateAction() {
    if (_inputController.text.isEmpty) return;

    setState(() {
      showBreakdown = true;
      translatedText = "Nagkakaon ako nin tinapay";

      currentPosDataEnglish = [
        {"word": "I", "tag": "Pron"},
        {"word": "am", "tag": "Verb"},
        {"word": "eating", "tag": "Verb"},
        {"word": "bread", "tag": "Noun"},
      ];

      currentPosDataBikol = [
        {"word": "Nagkakaon", "tag": "Verb"},
        {"word": "ako", "tag": "Pron"},
        {"word": "nin", "tag": "Verb"},
        {"word": "tinapay", "tag": "Noun"},
      ];

      historyItems.insert(0, {
        "en": _inputController.text,
        "bk": currentPosDataBikol,
        "type": "Sentence"
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF384087),
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _currentNavIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 30),
      child: Container(
        height: 62,
        decoration: BoxDecoration(
          color: const Color(0xFFE5E8FF),
          borderRadius: BorderRadius.circular(23),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navItem(0, Icons.home_filled),
            _navItem(1, Icons.history_rounded),
            _navItem(2, Icons.favorite_border_rounded),
            _navItem(3, Icons.person_outline_rounded),
          ],
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon) {
    bool isActive = _currentNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentNavIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF384087) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: index == 0
            ? SvgPicture.asset(
          'assets/icons/home.svg',
          width: 25,
          height: 25,
          colorFilter: ColorFilter.mode(
            isActive ? Colors.white : const Color(0xFF384087),
            BlendMode.srcIn,
          ),
        )
            : Icon(
          icon,
          color: isActive ? Colors.white : const Color(0xFF384087),
          size: 25,
        ),
      ),
    );
  }

  Widget _buildTranslationBody() {
    return Column(
      children: [
        _buildTopHeader(),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(55),
                topRight: Radius.circular(55),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Column(
                children: [
                  _buildLanguageToggle(),
                  const SizedBox(height: 30),

                  _buildTranslationCard(
                    label: "English",
                    isInput: true,
                    controller: _inputController,
                    hint: "Type text here...",
                    onChanged: (val) {
                      if (val.isEmpty) {
                        setState(() {
                          showBreakdown = false;
                          translatedText = "";
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: _handleTranslateAction,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF384087),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          "Translate",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'PoppinsSemiBold',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildTranslationCard(
                    label: "Bikol",
                    isInput: false,
                    text: translatedText.isEmpty ? "Translation will appear here" : translatedText,
                    isPlaceholder: translatedText.isEmpty,
                  ),

                  const SizedBox(height: 25),

                  if (showBreakdown) _buildPosBreakdown(),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Hello, ${widget.userName.split(' ').first}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'PoppinsSemiBold',
            ),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(radius: 24, backgroundColor: Colors.white),
        ],
      ),
    );
  }

  Widget _buildLanguageToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('English',
            style: TextStyle(
                fontSize: 24,
                color: Color(0xFF384087),
                fontFamily: 'PoppinsBold')),
        const SizedBox(width: 15),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE5E8FF), width: 1.5),
          ),
          child: const Icon(
              Icons.swap_horiz_outlined,
              color: Color(0xFF384087), size: 30),
        ),
        const SizedBox(width: 15),
        const Text('Bikol',
            style: TextStyle(
                fontSize: 24,
                color: Color(0xFF384087),
                fontFamily: 'PoppinsBold')),
      ],
    );
  }

  Widget _buildTranslationCard({
    required String label,
    bool isInput = false,
    String? text,
    TextEditingController? controller,
    String? hint,
    ValueChanged<String>? onChanged,
    bool isPlaceholder = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4FF),
        borderRadius: BorderRadius.circular(23),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Color(0xFFA1A5CD),
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
              if (isInput)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      controller?.clear();
                      translatedText = "";
                      showBreakdown = false;
                    });
                  },
                  child: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF7C83C4)),
                ),
            ],
          ),
          const SizedBox(height: 5),
          isInput
              ? TextField(
            controller: controller,
            onChanged: onChanged,
            style: const TextStyle(
                color: Color(0xFF1D213B),
                fontSize: 16, fontFamily: 'Poppins'),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                  color: const Color(0xFF384087).withValues(alpha: 0.3),
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
              border: InputBorder.none,
              isDense: true,
            ),
          )
              : Text(
            text ?? "",
            style: TextStyle(
                color: isPlaceholder ? const Color(0xFF384087).withValues(alpha: 0.3) : const Color(0xFF1D213B),
                fontSize: 16,
                fontFamily: 'Poppins'
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // --- FAVORITE FUNCTIONALITY ---
              GestureDetector(
                onTap: () {
                  if (translatedText.isNotEmpty && !isInput && !isPlaceholder) {
                    setState(() {
                      bool alreadyExists = favoriteItems.any((item) => item['en'] == _inputController.text);

                      if (!alreadyExists) {
                        favoriteItems.add({
                          "en": _inputController.text,
                          "bk": currentPosDataBikol,
                          "type": "Sentence"
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Added to Favorites"),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    });
                  }
                },
                child: Icon(
                  favoriteItems.any((item) => item['en'] == _inputController.text && _inputController.text.isNotEmpty)
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_outlined,
                  size: 15,
                  color: favoriteItems.any((item) => item['en'] == _inputController.text && _inputController.text.isNotEmpty)
                      ? const Color(0xFFFAD02C)
                      : const Color(0xFF384087),
                ),
              ),
              const SizedBox(width: 18),

              // --- COPY FUNCTIONALITY ---
              GestureDetector(
                onTap: () {
                  if (text != null && !isPlaceholder) {
                    Clipboard.setData(ClipboardData(text: text)).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Copied to clipboard"), duration: Duration(seconds: 1)),
                      );
                    });
                  }
                },
                child: _cardAction(Icons.copy_rounded),
              ),
              const SizedBox(width: 18),

              // --- SHARE FUNCTIONALITY ---
              GestureDetector(
                onTap: () {
                  if (text != null && !isPlaceholder) {
                    Share.share(text);
                  }
                },
                child: _cardAction(Icons.share_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardAction(IconData icon) => Icon(icon, size: 15, color: const Color(0xFF384087));

  Widget _buildPosBreakdown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4FF),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: const Color(0xFFCDD0EC), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Label stays at the start
        children: [
          const Text("POS BREAKDOWN",
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFA1A5CD),
                  fontFamily: 'PoppinsSemiBold')),
          const SizedBox(height: 20),

          // English Tags Centered
          Center(
            child: Wrap(
              alignment: WrapAlignment.center, // Centers the pills
              spacing: 15,
              runSpacing: 10,
              children: currentPosDataEnglish.map((item) => _TagUnit(item['tag']!, item['word']!, _getPosColor(item['tag']!), const Color(0xFF384087))).toList(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: const Color(0xFF384087).withValues(alpha: 0.08), thickness: 1),
          ),

          // Bikol Tags Centered
          Center(
            child: Wrap(
              alignment: WrapAlignment.center, // Centers the pills
              spacing: 15,
              runSpacing: 10,
              children: currentPosDataBikol.map((item) => _TagUnit(item['tag']!, item['word']!, _getPosColor(item['tag']!), const Color(0xFF384087))).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagUnit extends StatelessWidget {
  final String label, word;
  final Color labelColor, wordColor;
  const _TagUnit(this.label, this.word, this.labelColor, this.wordColor);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center, // Centers tag text over word text
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: labelColor, fontFamily: 'PoppinsSemiBold')),
        const SizedBox(height: 2),
        Text(word, style: TextStyle(fontSize: 13, color: wordColor, fontFamily: 'PoppinsMedium')),
      ],
    );
  }
}