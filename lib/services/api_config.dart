class ApiConfig {
  // ── HOW TO SWITCH BASE URL ────────────────────────────────
  // Uncomment the ONE url you need, comment out the others
  // ─────────────────────────────────────────────────────────

  // CHROME TESTING (flutter run → pick Chrome)
  static const String baseUrl = 'http://localhost:8000';

  // ANDROID STUDIO EMULATOR (flutter run → pick emulator)
  //static const String baseUrl = 'http://10.0.2.2:8000';
  // ── Local testing (Android Emulator) ──────────────────────
  // 10.0.2.2 is the special IP that points to your PC's localhost
  //static const String baseUrl = 'http://10.0.2.2:8000';

  // REAL ANDROID DEVICE (phone on same WiFi)
  // ── When testing on a real Android device on the same WiFi ──
  // Replace with your PC's local IP (run `ipconfig` in Windows to find it)
  // static const String baseUrl = 'http://192.168.1.XXX:8000';
  

  // ── Endpoints ─────────────────────────────────────────────
  static const String translate = '$baseUrl/translate';
  static const String translatePos = '$baseUrl/translate/pos';
  static const String phrasebook = '$baseUrl/phrasebook';
  static const String pairs = '$baseUrl/pairs';
  static const String feedback = '$baseUrl/feedback';
  static const String health = '$baseUrl/health';
}