import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../services/translation_service.dart';
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
  bool isLoading = false;        // ← NEW: loading state
  String? errorMessage;          // ← NEW: error message

  // Direction toggle: true = eng→bcl, false = bcl→eng
  bool isEngToBcl = true;        // ← NEW: direction state

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

  // ── Convert API pos tag to display label ──────────────────
  String _posToLabel(String pos) {
    switch (pos.toLowerCase()) {
      case 'n': return 'Noun';
      case 'v':
      case 'vblex': return 'Verb';
      case 'prn': return 'Pron';
      case 'adj': return 'Adj';
      case 'adv': return 'Adv';
      case 'pr': return 'Prep';
      case 'det': return 'Det';
      default: return pos.toUpperCase();
    }
  }

  // ── Main translate action — now calls real API ────────────
  Future<void> _handleTranslateAction() async {
    if (_inputController.text.isEmpty) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
      showBreakdown = false;
      translatedText = "";
    });

    try {
      final direction = isEngToBcl ? 'eng-bcl' : 'bcl-eng';
      final rawText = _inputController.text.trim();
      final inputText = rawText.isNotEmpty
          ? rawText[0].toUpperCase() + rawText.substring(1)
          : rawText;

      // Call real API with POS tags
      final result = await TranslationService.translateWithPos(
        text: inputText,
        direction: direction,
      );

      // Build POS tag lists from API response
      final List<Map<String, String>> inputTags = result.posTags
          .map((tag) => {'word': tag.word, 'tag': _posToLabel(tag.pos)})
          .toList();

      // For output POS — run reverse morph on translated text
      final outputResult = await TranslationService.translateWithPos(
        text: result.output.replaceAll('*', ''),
        direction: isEngToBcl ? 'bcl-eng' : 'eng-bcl',
      );

      final List<Map<String, String>> outputTags = outputResult.posTags
          .map((tag) => {'word': tag.word, 'tag': _posToLabel(tag.pos)})
          .toList();

      setState(() {
        isLoading = false;
        showBreakdown = true;
        translatedText = result.output.replaceAll('*', '');

        if (isEngToBcl) {
          currentPosDataEnglish = inputTags;
          currentPosDataBikol = outputTags.isNotEmpty ? outputTags : [
            {'word': result.output, 'tag': 'Word'}
          ];
        } else {
          currentPosDataBikol = inputTags;
          currentPosDataEnglish = outputTags.isNotEmpty ? outputTags : [
            {'word': result.output, 'tag': 'Word'}
          ];
        }

        // Add to history
        historyItems.insert(0, {
          "en": inputText,
          "bk": currentPosDataBikol,
          "type": "Sentence"
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Could not connect to server.\nMake sure the API is running.";
        showBreakdown = false;
      });
    }
  }

  // ── Toggle direction ──────────────────────────────────────
  void _toggleDirection() {
    setState(() {
      isEngToBcl = !isEngToBcl;
      _inputController.clear();
      translatedText = "";
      showBreakdown = false;
      errorMessage = null;
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
                    label: isEngToBcl ? "English" : "Bikol",
                    isInput: true,
                    controller: _inputController,
                    hint: "Type text here...",
                    onChanged: (val) {
                      if (val.isEmpty) {
                        setState(() {
                          showBreakdown = false;
                          translatedText = "";
                          errorMessage = null;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  // ── Error message ────────────────────────
                  if (errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorMessage!,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // ── Translate button ─────────────────────
                  GestureDetector(
                    onTap: isLoading ? null : _handleTranslateAction,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isLoading
                            ? const Color(0xFF384087).withValues(alpha: 0.6)
                            : const Color(0xFF384087),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: isLoading
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                            : const Text(
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
                    label: isEngToBcl ? "Bikol" : "English",
                    isInput: false,
                    text: translatedText.isEmpty
                        ? "Translation will appear here"
                        : translatedText,
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
        Text(
          isEngToBcl ? 'English' : 'Bikol',
          style: const TextStyle(
              fontSize: 24,
              color: Color(0xFF384087),
              fontFamily: 'PoppinsBold'),
        ),
        const SizedBox(width: 15),
        // ── Swap button now actually toggles direction ──────
        GestureDetector(
          onTap: _toggleDirection,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE5E8FF), width: 1.5),
            ),
            child: const Icon(
                Icons.swap_horiz_outlined,
                color: Color(0xFF384087), size: 30),
          ),
        ),
        const SizedBox(width: 15),
        Text(
          isEngToBcl ? 'Bikol' : 'English',
          style: const TextStyle(
              fontSize: 24,
              color: Color(0xFF384087),
              fontFamily: 'PoppinsBold'),
        ),
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
                      errorMessage = null;
                    });
                  },
                  child: const Icon(Icons.close_rounded,
                      size: 16, color: Color(0xFF7C83C4)),
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
                fontSize: 16,
                fontFamily: 'Poppins'),
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
                color: isPlaceholder
                    ? const Color(0xFF384087).withValues(alpha: 0.3)
                    : const Color(0xFF1D213B),
                fontSize: 16,
                fontFamily: 'Poppins'),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  if (translatedText.isNotEmpty &&
                      !isInput &&
                      !isPlaceholder) {
                    setState(() {
                      bool alreadyExists = favoriteItems
                          .any((item) => item['en'] == _inputController.text);
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
                  favoriteItems.any((item) =>
                  item['en'] == _inputController.text &&
                      _inputController.text.isNotEmpty)
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_outlined,
                  size: 15,
                  color: favoriteItems.any((item) =>
                  item['en'] == _inputController.text &&
                      _inputController.text.isNotEmpty)
                      ? const Color(0xFFFAD02C)
                      : const Color(0xFF384087),
                ),
              ),
              const SizedBox(width: 18),
              GestureDetector(
                onTap: () {
                  if (text != null && !isPlaceholder) {
                    Clipboard.setData(ClipboardData(text: text)).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Copied to clipboard"),
                            duration: Duration(seconds: 1)),
                      );
                    });
                  }
                },
                child: _cardAction(Icons.copy_rounded),
              ),
              const SizedBox(width: 18),
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

  Widget _cardAction(IconData icon) =>
      Icon(icon, size: 15, color: const Color(0xFF384087));

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("POS BREAKDOWN",
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFA1A5CD),
                  fontFamily: 'PoppinsSemiBold')),
          const SizedBox(height: 20),

          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 15,
              runSpacing: 10,
              children: currentPosDataEnglish
                  .map((item) => _TagUnit(
                item['tag']!,
                item['word']!,
                _getPosColor(item['tag']!),
                const Color(0xFF384087),
              ))
                  .toList(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(
                color: const Color(0xFF384087).withValues(alpha: 0.08),
                thickness: 1),
          ),

          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 15,
              runSpacing: 10,
              children: currentPosDataBikol
                  .map((item) => _TagUnit(
                item['tag']!,
                item['word']!,
                _getPosColor(item['tag']!),
                const Color(0xFF384087),
              ))
                  .toList(),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 10,
                color: labelColor,
                fontFamily: 'PoppinsSemiBold')),
        const SizedBox(height: 2),
        Text(word,
            style: TextStyle(
                fontSize: 13,
                color: wordColor,
                fontFamily: 'PoppinsMedium')),
      ],
    );
  }
}
