import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutAppPage extends StatefulWidget {
  const AboutAppPage({super.key});

  @override
  State<AboutAppPage> createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  String appVersion = '1.0.0';

  Future<void> checkVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  void initState() {
    super.initState();
    checkVersion();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(boldText: false, textScaler: const TextScaler.linear(1)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            tr('about_app'),
            style: theme.textTheme.bodyMedium!.copyWith(
                color: Colors.white, fontSize: 21, fontWeight: FontWeight.w600),
          ),
          backgroundColor: theme.primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (context.locale == const Locale('uz', 'UZ')) ...[
                Text(
                  'Дзырдуӕттӕ Digor®',
                  style: theme.textTheme.headlineSmall!.copyWith(
                    fontSize: 21,
                  ),
                ),
                Text(
                  '''
    
Хуыз $appVersion
    
Нымӕц# 2025/25.
    
© 2023 «Digor»
Проекты автор ӕмӕ разамонӕг Будайты Мурат 
    
Проект «Digor» нысангонд у алкӕмӕн дӕр, кӕцы цымыдис кӕны дыгурон ӕвзагмӕ - куыд мадӕлон кӕнӕ фӕсарӕйнаг ӕвзаг, астӕуккаг ӕмӕ уӕлдӕр ахуыргӕнӕндӕтты студенттӕн, афтӕ ма профессионалон ӕгъдауӕй лингвистикӕйы чи архайы, кӕнӕ дыгурон ӕвзаг ӕмӕ литературӕ чи амоны, уыцы специалисттӕн. Ацы ӕмхасӕны бакӕсӕн ис алыхуызы ӕвзагзонынады информаци.
''',
                  textAlign: TextAlign.justify,
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: 15,
                    height: 1.3,
                    color: theme.textTheme.bodyMedium!.color,
                  ),
                ),
              ],
              if (context.locale == const Locale('ru', 'RU')) ...[
                Text(
                  'Словари Digor®',
                  style: theme.textTheme.headlineSmall!.copyWith(
                    fontSize: 21,
                  ),
                ),
                Text(
                  '''
    
Версия $appVersion
    
Артикул# 2025/25.
    
© 2023 «Digor»
Автор и руководитель проекта Будаев Мурат Олегович
    
Проект «Digor» предназначен для всех, кто интересуется дигорским языком - как родным или как иностранным, для учащихся средней и высшей школы, а также для специалистов, профессионально занимающихся лингвистикой или преподаванием дигорского языка и литературы. Приложение содержит общедоступную лингвистическую информацию разного типа.
''',
                  textAlign: TextAlign.justify,
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: 15,
                    height: 1.3,
                    color: theme.textTheme.bodyMedium!.color,
                  ),
                ),
              ],
              if (context.locale == const Locale('en', 'US')) ...[
                Text(
                  'Digor® Dictionaries',
                  style: theme.textTheme.headlineSmall!.copyWith(
                    fontSize: 21,
                  ),
                ),
                Text(
                  '''
    
Version $appVersion
    
Part# 2025/25.
    
© 2023 «Digor»
    
Author and project manager Murat Budaev
    
The "Digor" project is intended for everyone who is interested in the Digor language - as a native or as a foreign language, for students of secondary and higher education, as well as for specialists who are professionally engaged in linguistics or teaching the Digor language and literature. The application contains publicly available linguistic information of various types.
''',
                  textAlign: TextAlign.justify,
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: 15,
                    height: 1.3,
                    color: theme.textTheme.bodyMedium!.color,
                  ),
                ),
              ],
              if (context.locale == const Locale('tr', 'TR')) ...[
                Text(
                  'Digor® Sözlükler',
                  style: theme.textTheme.headlineSmall!.copyWith(
                    fontSize: 21,
                  ),
                ),
                Text(
                  '''
    
Sürüm $appVersion
    
Ürün kodu# 2025/25.
    
© 2023 «Digor»
Yazar ve proje yöneticisi Murat Budayev
    
«Digor» projesi, ana dili veya yabancı dili olarak Digor diliyle ilgilenen herkese, ortaöğretim ve yükseköğretim öğrencilerine ve profesyonel olarak dilbilim alanında çalışan veya Digor dili ve edebiyatı öğreten uzmanlara yöneliktir. Uygulama, çeşitli türlerde kamuya açık dil bilgisi içermektedir.
''',
                  textAlign: TextAlign.justify,
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: 15,
                    height: 1.3,
                    color: theme.textTheme.bodyMedium!.color,
                  ),
                ),
              ],
              if (context.locale == const Locale('de', 'DE')) ...[
                Text(
                  'Дзурдуӕттӕ Digor®',
                  style: theme.textTheme.headlineSmall!.copyWith(
                    fontSize: 21,
                  ),
                ),
                Text(
                  '''
    
Хузӕ $appVersion
    
Нимӕдзӕ# 2025/25.
    
© 2023 «Digor»
Проекти автор ӕма разамонӕг Будайти Мурат 
    
Проект «Digor» арӕзт ӕй, дигорон ӕвзаг цӕмӕдесаг кӕмӕн ӕй, уонӕй алке туххӕн дӕр – ӕвзаг ин хеуон уа, ӕви фӕсарӕйнаг, уӕдта астӕуккаг ӕма уӕлдӕр ахургӕнӕндӕнтти ахурдзаутӕн, никки ба ма, лингвистикӕ ӕ професси кӕмӕн ӕй, кенӕ дигорон ӕвзаг ӕма литератури ахургӕнӕг ка ӕй, уонӕн. Аци ӕнхасӕни бакӕсӕн ес аллихузи ӕвзагзонуйнади информаци.
''',
                  textAlign: TextAlign.justify,
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: 15,
                    height: 1.3,
                    color: theme.textTheme.bodyMedium!.color,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
