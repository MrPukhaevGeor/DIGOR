
library collation;

int _unknownBase = 0x10000;

final Map<String, List<String>> _orders = {
  'ru': [
    ' ',
    'а','б','в','г','д','е','ё','ж','з','и','й','к','л','м','н','о','п','р','с','т','у','ф','х','ц','ч','ш','щ','ъ','ы','ь','э','ю','я',
  ],
  'iron': [
    ' ',
    'а','ӕ','б','в','г','д','е','ё','ж','з','и','й','к','л','м','н','о','п','р','с','т','у','ф','х','ц','ч','ш','щ','ы','ь','э','ю','я','ъ',
  ],
  'dig': [
    ' ',
    'ӕ','а','б','в','г','д','е','ё','ж','з','и','й','к','л','м','н','о','п','р','с','т','у','ф','х','ц','ч','ш','щ','ы','ь','э','ю','я','ъ',
  ],
  'turk': [
    ' ',
    'a','b','c','ç','d','e','f','g','ğ','h','ı','i','j','k','l','m','n','o','ö','p','r','s','ş','t','u','ü','v','y','z',
  ],
  'en': [
    ' ',
    'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
  ],
};

Map<String, Map<String, int>> _rankCache = {};

int _rankOf(String ch, String alpha) {
  final cached = _rankCache[alpha];
  if (cached != null) {
    return cached[ch] ?? (_unknownBase + ch.codeUnitAt(0));
  }
  final order = _orders[alpha] ?? _orders['ru']!;
  final map = <String,int>{};
  for (int i = 0; i < order.length; i++) {
    map[order[i]] = i;
  }
  _rankCache[alpha] = map;
  return map[ch] ?? (_unknownBase + ch.codeUnitAt(0));
}

String normalizeAlpha(String s, String alpha) {
  final ossetOrRu = alpha == 'iron' || alpha == 'dig' || alpha == 'ru';
  if (!ossetOrRu) return s;
  return s
      .replaceAll('æ', 'ӕ')
      .replaceAll('Æ', 'Ӕ')
      .replaceAll('a', 'а')
      .replaceAll('A', 'А');
}

int compareByAlphabet(String a, String b, String alpha) {
  a = normalizeAlpha(a, alpha).toLowerCase();
  b = normalizeAlpha(b, alpha).toLowerCase();
  final len = a.length < b.length ? a.length : b.length;
  for (int i = 0; i < len; i++) {
    final ra = _rankOf(a[i], alpha);
    final rb = _rankOf(b[i], alpha);
    if (ra != rb) return ra - rb;
  }
  return a.length - b.length;
}
