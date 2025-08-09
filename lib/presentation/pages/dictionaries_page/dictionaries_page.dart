import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher.dart';

class DictionariesPage extends StatelessWidget {
  const DictionariesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1, boldText: false),
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              tr('dictionaries'),
              style:
                  theme.textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (context.locale == const Locale('en', 'US')) ...[
                    const _dictionaryWidget(
                      title: 'Digor-Russian dictionary',
                      description:
                          'Entry count   34657\nFile size         53,47 MB\nState              active <a>✅</a>\nSound            planned',
                      author: 'Takazov F., 2nd ed. - Vladikavkaz, 2015.',
                    ),
                    const SizedBox(height: 40),
                    const _dictionaryWidget(
                      title: 'Digor-English dictionary',
                      description:
                          'Entry count    18780\nFile size          3,85 MB\nState              active <a>✅</a>\nSound            planned',
                      author:
                          'Dictionary of the Digor language corpus. <ref>http://corpus-digor.ossetic-studies.org</ref>',
                    ),
                    const SizedBox(height: 40),
                    const _dictionaryWidget(
                      title: 'Ossetian (Iron)-Russian dictionary',
                      description:
                          'Entry count     26775\nFile size          4,64 MB\nState              active <a>✅</a>\nSound            planned',
                      author: 'Bigulaev B., Gagkaev K., Guriev T., Kulaev N., Tuaeva O., 5th ed. - Vladikavkaz, 2004.',
                    ),
                    const SizedBox(height: 40),
                    const _dictionaryWidget(
                      title: 'Russian-Ossetian (Iron) dictionary',
                      description:
                          'Entry count     25213\nFile size          4,77 MB\nState              active <a>✅</a>\nSound            planned',
                      author: 'Abaev V., 3rd ed. - Vladikavkaz, 2013.',
                    ),
                  ],
                  if (context.locale == const Locale('uz', 'UZ')) ...[
                    const _dictionaryWidget(
                      title: 'Дыгурон-уырыссаг дзырдуат',
                      description: 'Фыстуацты нымӕц          34657\n'
                          'Файлы ас                          53,47 MB\n'
                          'Ӕууӕл                              кусы ✅\n'
                          'Зӕлгонд                           уыдзӕн',
                      author: 'Тахъазты Федар. 2-аг рауагъд - Дзӕуджыхъӕу, 2015.',
                    ),
                    const SizedBox(height: 40),
                    const _dictionaryWidget(
                      title: 'Дыгурон-англисаг дзырдуат',
                      description: 'Фыстуацты нымӕц          18780\n'
                          'Файлы ас                          3,85 MB\n'
                          'Ӕууӕл                              кусы ✅\n'
                          'Зӕлгонд                           уыдзӕн',
                      author:
                          'Дыгурон ӕвзагон къорпусӕй ист дзырдуат. <ref>http://corpus-digor.ossetic-studies.org</ref>',
                    ),
                    const SizedBox(height: 40),
                    const _dictionaryWidget(
                      title: 'Ирон-уырыссаг дзырдуат',
                      description: 'Фыстуацты нымӕц          34657\n'
                          'Файлы ас                          4,64 МБ\n'
                          'Ӕууӕл                              кусы ✅\n'
                          'Зӕлгонд                           уыдзӕн',
                      author:
                          'Бигъуылаты Б., Гагкайты К., Гуыриаты Т., Хъуылаты Н., Туаты О., 5-аг рауагъд - Дзӕуджыхъӕу, 2004.',
                    ),
                    const SizedBox(height: 40),
                    const _dictionaryWidget(
                      title: 'Уырыссаг-ирон дзырдуат',
                      description: 'Фыстуацты нымӕц          18780\n'
                          'Файлы ас                          4,77 МБ\n'
                          'Ӕууӕл                              кусы ✅\n'
                          'Зӕлгонд                           уыдзӕн',
                      author: 'Абайты В., 3-аг рауагъд - Дзӕуджыхъӕу, 2013.',
                    ),
                  ],
                  if (context.locale == const Locale('ru', 'RU')) ...[
                    const _dictionaryWidget(
                      title: 'Дигорско-русский словарь',
                      description: 'Количество статей   34657\n'
                          'Размер файла           53,47 МБ\n'
                          'Состояние                  включен ✅\n'
                          'Озвучка                      планируется',
                      author: 'Таказов Ф. М., изд. 2-е. - Владикавказ, 2015.',
                    ),
                    const SizedBox(height: 40),
                    const _dictionaryWidget(
                      title: 'Дигорско-английский словарь',
                      description: 'Количество статей    18780\n'
                          'Размер файла            3,85 МБ\n'
                          'Состояние                  включен ✅\n'
                          'Озвучка                      планируется',
                      author:
                          'Словарь дигорского языкового корпуса. <ref>http://corpus-digor.ossetic-studies.org</ref>',
                    ),
                    const SizedBox(height: 40),
                    const _dictionaryWidget(
                      title: 'Осетинско (иронско)-русский словарь',
                      description: 'Количество статей     26775\n'
                          'Размер файла            4,64 МБ\n'
                          'Состояние                  включен ✅\n'
                          'Озвучка                      планируется',
                      author:
                          'Бигулаев Б. Б., Гагкаев К. Е., Гуриев Т. А., Кулаев Н. Х, Туаева О. Н., изд. 5-е. - Владикавказ, 2004.',
                    ),
                    const SizedBox(height: 40),
                    const _dictionaryWidget(
                      title: 'Русско-осетинский (иронский) словарь',
                      description: 'Количество статей     25213\n'
                          'Размер файла            4,77 МБ\n'
                          'Состояние                  включен ✅\n'
                          'Озвучка                      планируется',
                      author: 'Абаев В.И., изд. 3-е. - Владикавказ, 2013.',
                    ),
                  ],
                  if (context.locale == const Locale('tr', 'TR')) ...[
                    const _dictionaryWidget(
                      title: 'Digoronca-Rusça sözlük',
                      description: 'Makale sayısı            34657\n'
                          'Dosya boyutu           53,47 MB\n'
                          'Durum                       aktif <a>✅</a>\n'
                          'Ses                            planlandı',
                      author: 'Takazov F., 2. Baskı. - Vladikavkaz, 2015.',
                    ),
                    const SizedBox(height: 40),
                    const _dictionaryWidget(
                      title: 'Digoronca-İngilizce sözlük',
                      description: 'Makale sayısı            18780\n'
                          'Dosya boyutu            3,85 MB\n'
                          'Durum                       aktif <a>✅</a>\n'
                          'Ses                            planlandı',
                      author: 'Digor dil külliyatının sözlüğü. <ref>http://corpus-digor.ossetic-studies.org</ref>',
                    ),
                    const SizedBox(height: 40),
                    const _dictionaryWidget(
                      title: 'İronca-Rusça sözlük',
                      description: 'Makale sayısı            26775\n'
                          'Dosya boyutu            4,64 MB\n'
                          'Durum                       aktif <a>✅</a>\n'
                          'Ses                            planlandı',
                      author:
                          'Bigulaev B., Gagkaev K., Guriev T., Kulaev N., Tuaeva O., 5. Baskı. - Vladikavkaz, 2004.',
                    ),
                    const SizedBox(height: 40),
                    const _dictionaryWidget(
                      title: 'İronca-İngilizce sözlük',
                      description: 'Makale sayısı            25213\n'
                          'Dosya boyutu            4,77 MB\n'
                          'Durum                       aktif <a>✅</a>\n'
                          'Ses                            planlandı',
                      author: 'Abaev V., 3. Baskı. - Vladikavkaz, 2013.',
                    ),
                  ],
                  if (context.locale == const Locale('de', 'DE')) ...[
                    const _dictionaryWidget(
                      title: 'Дигорон-уруссаг дзурдуат',
                      description: 'Финстуацти нимӕдзӕ      34657\n'
                          'Файли асӕ                         53,47 MB\n'
                          'Ӕууӕл                                косуй ✅\n'
                          'Зӕлгонд                             уодзӕнӕй',
                      author:
                          'Тахъазти Федар. Дигорон-уруссаг дзурдуат. Уруссаг-дигорон дзурдуат. - Дзӕуӕгигъӕу, 2015.',
                    ),
                    const SizedBox(height: 40),
                    const _dictionaryWidget(
                      title: 'Дигорон-англисаг дзурдуат',
                      description: 'Финстуацти нимӕдзӕ      18780\n'
                          'Файли асӕ                         3,85 MB\n'
                          'Ӕууӕл                                косуй ✅\n'
                          'Зӕлгонд                             уодзӕнӕй',
                      author: 'Дигорон ӕвзагон къорпусӕй ист дзурдуат. http://corpus-digor.ossetic-studies.org',
                    ),
                    const SizedBox(height: 40),
                    const _dictionaryWidget(
                      title: 'Ирон-уруссаг дзурдуат',
                      description: 'Финстуацти нимӕдзӕ      26775\n'
                          'Файли асӕ                         4,64 MB\n'
                          'Ӕууӕл                                косуй ✅\n'
                          'Зӕлгонд                             уодзӕнӕй',
                      author:
                          'Бигъулати Б., Гагкайти К., Гуриати Т., Хъулати Н., Туати О., 5-аг рауагъд - Дзӕуӕгигъӕу, 2004.',
                    ),
                    const SizedBox(height: 40),
                    const _dictionaryWidget(
                      title: 'Уруссаг-ирон дзурдуат',
                      description: 'Финстуацти нимӕдзӕ      25213\n'
                          'Файли асӕ                         4,77 MB\n'
                          'Ӕууӕл                                косуй ✅\n'
                          'Зӕлгонд                             уодзӕнӕй',
                      author: 'Абайти В., 3-аг рауагъд - Дзӕуӕгигъӕу, 2013.',
                    ),
                  ]
                ],
              ),
            ),
          )),
    );
  }
}

class _dictionaryWidget extends StatelessWidget {
  final String title;
  final String description;
  final String author;
  const _dictionaryWidget({required this.title, required this.description, required this.author});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontSize: 21,
            fontFamily: 'HelveticaNeue',
          ),
        ),
        const SizedBox(height: 20),
        StyledText(
          text: description,
          style: theme.textTheme.bodySmall!.copyWith(
            fontSize: 16,
            height: 1.3,
            color: theme.textTheme.bodyMedium!.color,
            fontFamily: 'HelveticaNeue',
          ),
          tags: {
            'a': StyledTextActionTag((String? text, Map<String?, String?> attrs) {},
                style: const TextStyle(fontSize: 15, color: Colors.green)),
            'e': StyledTextActionTag((String? text, Map<String?, String?> attrs) {},
                style: const TextStyle(fontSize: 12)),
            'ref': StyledTextActionTag(
              (String? text, Map<String?, String?> attrs) {
                _launchUrl(Uri.parse(text!));
              },
              style: TextStyle(
                  color: theme.brightness == Brightness.dark
                      ? const Color.fromARGB(255, 0, 129, 255)
                      : const Color.fromARGB(255, 0, 0, 238)),
            ),
          },
        ),
        const SizedBox(height: 7.5),
        StyledText(
          text: author,
          style: theme.textTheme.bodySmall!.copyWith(
            fontSize: 16,
            height: 1.3,
            color: theme.textTheme.bodyMedium!.color,
            fontFamily: 'HelveticaNeue',
          ),
          tags: {
            'ref': StyledTextActionTag(
              (String? text, Map<String?, String?> attrs) {
                _launchUrl(Uri.parse(text!));
              },
              style: TextStyle(
                  color: theme.brightness == Brightness.dark
                      ? const Color.fromARGB(255, 0, 129, 255)
                      : const Color.fromARGB(255, 0, 0, 238)),
            ),
          },
        )
      ],
    );
  }
}

Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}
