import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher.dart';

import 's.dart';

class DictionariesPage extends StatelessWidget {
  const DictionariesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final isBold = MediaQuery.of(context).boldText;
    final theme = Theme.of(context);

    // helper: вставляет Divider после каждого _dictionaryWidget (если он не последний)
    List<Widget> _withDividers(List<Widget> items, ThemeData theme) {
      final List<Widget> result = [];
      for (var i = 0; i < items.length; i++) {
        final w = items[i];
        result.add(w);

        // если текущий виджет — именно _dictionaryWidget, добавляем Divider после него
        if (w is _dictionaryWidget && i != items.length - 1) {
          result.add(Divider(
            thickness: 1,
            endIndent: 10,
            color: theme.primaryColor.withOpacity(.5),
          ));
        }
      }
      return result;
    }

    // Собираем "сырые" дети так же, как у тебя было, ничего не трогаем
    final rawChildren = <Widget>[
      // EN
      if (context.locale == const Locale('en', 'US')) ...[
        const _dictionaryWidget(
          title: 'Digor-Russian dictionary',
          description:
              'Entry count      34657\nFile size        53,47 MB\nState            active <a>✅</a>\nSound            planned',
          author: 'Takazov F., 2nd ed. - Vladikavkaz, 2015.',
        ),
        const SizedBox(height: 15),
        const _dictionaryWidget(
          title: 'Digor-English dictionary',
          description:
              'Entry count      18780\nFile size        3,85 MB\nState            active <a>✅</a>\nSound            planned',
          author:
              'Dictionary of the Digor language corpus. \n<ref>http://corpus-digor.ossetic-studies.org</ref>',
        ),
        const SizedBox(height: 15),
        const _dictionaryWidget(
          title: 'Ossetian (Iron)-Russian dictionary',
          description:
              'Entry count      26775\nFile size        4,64 MB\nState            active <a>✅</a>\nSound            planned',
          author:
              'Bigulaev B., Gagkaev K., Guriev T., Kulaev N., Tuaeva O., 5th ed. - Vladikavkaz, 2004.',
        ),
        const SizedBox(height: 15),
        const _dictionaryWidget(
          title: 'Russian-Ossetian (Iron) dictionary',
          description:
              'Entry count      25213\nFile size        4,77 MB\nState            active <a>✅</a>\nSound            planned',
          author: 'Abaev V., 3rd ed. - Vladikavkaz, 2013.',
        ),
      ],

      // KM
      if (context.locale == const Locale('km', 'KM')) ...[
        const _dictionaryWidget(
          title: 'Дыгурон-уырыссаг дзырдуат',
          description:
              'Фыстуацты нымӕц      34657\nФайлы ас      53,47 MB\nӔууӕл      кусы <a>✅</a>\nЗӕлгонд      уыдзӕн',
          author: 'Тахъазты Ф., 2-аг рауагъд - Дзӕуджыхъӕу, 2015.',
        ),
        const SizedBox(height: 15),
        const _dictionaryWidget(
          title: 'Дыгурон-англисаг дзырдуат',
          description:
              'Фыстуацты нымӕц      18780\nФайлы ас      3,85 MB\nӔууӕл      кусы <a>✅</a>\nЗӕлгонд      уыдзӕн',
          author:
              'Дыгурон ӕвзагон къорпусӕй ист дзырдуат. \n<ref>http://corpus-digor.ossetic-studies.org</ref>',
        ),
        const SizedBox(height: 15),
        // Note: In original you had identical counts for some items — keep consistent entries below.
        const _dictionaryWidget(
          title: 'Ирон-уырыссаг дзырдуат',
          description:
              'Фыстуацты нымӕц      34657\nФайлы ас      4,64 MB\nӔууӕл      кусы <a>✅</a>\nЗӕлгонд      уыдзӕн',
          author:
              'Бигъуылаты Б., Гагкайты К., Гуыриаты Т., Хъышленаты Н., Туаты О., 5-аг рауагъд - Дзӕуджыхъӕу, 2004.',
        ),
        const SizedBox(height: 15),
        const _dictionaryWidget(
          title: 'Уырыссаг-ирон дзырдуат',
          description:
              'Фыстуацты нымӕц      18780\nФайлы ас      4,77 MB\nӔууӕл      кусы <a>✅</a>\nЗӕлгонд      уыдзӕн',
          author: 'Абайты В., 3-аг рауагъд - Дзӕуджыхъӕу, 2013.',
        ),
      ],

      // RU
      if (context.locale == const Locale('ru', 'RU')) ...[
        const _dictionaryWidget(
          title: 'Дигорско-русский словарь',
          description:
              'Количество статей      34657\nРазмер файла      53,47 МБ\nСостояние      включен <a>✅</a>\nОзвучка      планируется',
          author: 'Таказов Ф. М., изд. 2-е. - Владикавказ, 2015.',
        ),
        const SizedBox(height: 15),
        const _dictionaryWidget(
          title: 'Дигорско-английский словарь',
          description:
              'Количество статей      18780\nРазмер файла      3,85 МБ\nСостояние      включен <a>✔</a>\nОзвучка      планируется',
          author:
              'Словарь дигорского языкового корпуса. \n<ref>http://corpus-digor.ossetic-studies.org</ref>',
        ),
        const SizedBox(height: 15),
        const _dictionaryWidget(
          title: 'Осетинско (иронско)-русский словарь',
          description:
              'Количество статей      26775\nРазмер файла      4,64 МБ\nСостояние      включен <a>✅</a>\nОзвучка      планируется',
          author:
              'Бигулаев Б. Б., Гагкаев К. Е., Гуриев Т. А., Кулаев Н. Х., Туаева О. Н., изд. 5-е. - Владикавказ, 2004.',
        ),
        const SizedBox(height: 15),
        const _dictionaryWidget(
          title: 'Русско-осетинский (иронский) словарь',
          description:
              'Количество статей      25213\nРазмер файла      4,77 МБ\nСостояние      включен <a>✅</a>\nОзвучка      планируется',
          author: 'Абаев В.И., изд. 3-е. - Владикавказ, 2013.',
        ),
      ],

      // TR
      if (context.locale == const Locale('tr', 'TR')) ...[
        const _dictionaryWidget(
          title: 'Digoronca-Rusça sözlük',
          description:
              'Makale sayısı      34657\nDosya boyutu      53,47 MB\nDurum      aktif <a>✅</a>\nSes      planlandı',
          author: 'Takazov F., 2. Baskı. - Vladikavkaz, 2015.',
        ),
        const SizedBox(height: 15),
        const _dictionaryWidget(
          title: 'Digoronca-İngilizce sözlük',
          description:
              'Makale sayısı      18780\nDosya boyutu      3,85 MB\nDurum      aktif <a>✅</a>\nSes      planlandı',
          author:
              'Digor dil külliyatının sözlüğü. \n<ref>http://corpus-digor.ossetic-studies.org</ref>',
        ),
        const SizedBox(height: 15),
        const _dictionaryWidget(
          title: 'İronca-Rusça sözlük',
          description:
              'Makale sayısı      26775\nDosya boyutu      4,64 MB\nDurum      aktif <a>✅</a>\nSes      planlandı',
          author:
              'Bigulaev B., Gagkaev K., Guriev T., Kulaev N., Tuaeva O., 5. Baskı. - Vladikavkaz, 2004.',
        ),
        const SizedBox(height: 15),
        const _dictionaryWidget(
          title: 'İronca-İngilizce sözlük',
          description:
              'Makale sayısı      25213\nDosya boyutu      4,77 MB\nDurum      aktif <a>✅</a>\nSes      planlandı',
          author: 'Abaev V., 3. Baskı. - Vladikavkaz, 2013.',
        ),
      ],

      // SW
      if (context.locale == const Locale('sw', 'SW')) ...[
        const _dictionaryWidget(
          title: 'Дигорон-уруссаг дзурдуат',
          description:
              'Финстуацти нимӕдзӕ      34657\nФайли асӕ      53,47 MB\nӔууӕл      косуй <a>✅</a>\nЗӕлгонд      уодзӕнӕй',
          author: 'Тахъазти Ф., 2-аг рауагъд - Дзӕуӕгигъӕу, 2015.',
        ),
        const SizedBox(height: 15),
        const _dictionaryWidget(
          title: 'Дигорон-англисаг дзурдуат',
          description:
              'Финстуацти нимӕдзӕ      18780\nФайли асӕ      3,85 MB\nӔууӕл      косуй <a>✅</a>\nЗӕлгонд      уодзӕнӕй',
          author:
              'Дигорон ӕвзагон къорпусӕй ист дзурдуат. \n<ref>http://corpus-digor.ossetic-studies.org</ref>',
        ),
        const SizedBox(height: 15),
        const _dictionaryWidget(
          title: 'Ирон-уруссаг дзурдуат',
          description:
              'Финстуацти нимӕдзӕ      26775\nФайли асӕ      4,64 MB\nӔууӕл      косуй <a>✅</a>\nЗӕлгонд      уодзӕнӕй',
          author:
              'Бигъулати Б., Гагкайти К., Гуриати Т., Хъулати Н., Туати О., 5-аг рауагъд - Дзӕуӕгигъӕу, 2004.',
        ),
        const SizedBox(height: 15),
        const _dictionaryWidget(
          title: 'Уруссаг-ирон дзурдуат',
          description:
              'Финстуацти нимӕдзӕ      25213\nФайли асӕ      4,77 MB\nӔууӕл      косуй <a>✅</a>\nЗӕлгонд      уодзӕнӕй',
          author: 'Абайти В., 3-аг рауагъд - Дзӕуӕгигъӕу, 2013.',
        ),
      ],
    ];

    return Scaffold(
      appBar: AppBar(
        title: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(1), boldText: false),
          child: Text(
            tr('dictionaries'),
            style: theme.textTheme.bodyMedium!.copyWith(
              color: Colors.white,
              fontSize: 22,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
      body: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(1), boldText: false),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _withDividers(rawChildren, theme),
            ),
          ),
        ),
      ),
    );
  }
}

class _dictionaryWidget extends StatelessWidget {
  final String title;
  final String description;
  final String author;
  const _dictionaryWidget(
      {required this.title, required this.description, required this.author});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        AlignedDescription(
          description: description,
          style: theme.textTheme.bodySmall!.copyWith(
            fontSize: 14,
            height: 1.3,
            fontWeight: FontWeight.w500,
            color: theme.textTheme.bodyMedium!.color,
          ),
          tags: {
            'a': StyledTextIconTag(Icons.check, size: 26, color: Colors.green),
            'e': StyledTextActionTag(
                (String? text, Map<String?, String?> attrs) {},
                style: const TextStyle(fontSize: 13)),
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
            fontSize: 14,
            height: 1.3,
            fontWeight: FontWeight.w500,
            color: theme.textTheme.bodyMedium!.color,
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
