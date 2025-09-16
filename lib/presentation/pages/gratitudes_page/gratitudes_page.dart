import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher.dart';

class GratitudesPage extends StatelessWidget {
  const GratitudesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isBold = MediaQuery.of(context).boldText;
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1), boldText: false),
            child: Text(
              tr('gratitudes'),
              style: theme.textTheme.bodyMedium!.copyWith(
                color: Colors.white,
                fontSize: 22,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
          backgroundColor: theme.primaryColor,
        ),
        body: MediaQuery(
          data: MediaQuery.of(context).copyWith(
              boldText: false, textScaler: const TextScaler.linear(1)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: StyledText(
                  text: context.locale == const Locale('ru', 'RU')
                      ? '''
Данное приложение появилось благодаря поддержке людей, неравнодушных к положению и судьбе дигорского языка.
 
От имени руководителя проекта хотелось бы выразить огромную благодарность людям, внесшим вклад в создание мобильного приложения:
 
<b>Алборовой Зарине Александровне</b> - создателю сайта Digoria.com <ref>https://www.digoria.com</ref> за энтузиазм и неугасаемую веру в успех реализации проекта, активность в распространении информации о сборе средств, а также о ходе развития проекта.
 
<b>Таказову Валерию Дзантемировичу</b> - доктору филологических наук, профессору, за большую активность в вопросах статуса дигорского языка, организаций двух научно-практических конференций по проблемам дигорского языка и культуры, на котором также было представлено мобильное приложение дигорско-русско-английского словаря "Digor". За отзывчивость и помощь в различных вопросах.
 
<b>Таказову Федару Магометовичу</b> - доктору филологических наук, профессору, создателю дигорского-русского и русского дигорского словарей.
 
<b>Кудзаеву Аслану</b> - создателю электронной библиотеки в группе Вконтакте "Bærzæfcæg" <ref>https://vk.com/barzafcag</ref> за сканирование дигорского-русского и русского-дигорского словаря 2003, 2015.
 
<b>Магомедову Магомеду</b> - создателю приложения мультиязычного словаря северокавказских языков "Bazur" <ref>https://play.google.com/store/apps/details?id=com.alkaitagi.avzag</ref> и "Avdan" <ref>https://play.google.com/store/apps/details?id=com.alkaitagi.avdan</ref> за консультативную помощь при создании проекта.
 
<b>Макаренко Марии Дмитриевне</b> - за лингвистическую помощь в оформлении структуры словарей.
 
<b>Дзуцевой Лане</b> - за техническую работу над дигорско-русским и дигорско-английским словарями.
 
<b>Золойти Алийхсану</b> - за проделанный огромный труд в составлении турецко-дигорского словаря.
 
<b>Сотрудникам газеты "Дигора"</b> - за распространение новости о создании мобильного приложения. <ref>https://gazeta-digora.ru/</ref>
 
Для создания электронного словаря "Digor" был объявлен сбор денежных средств на реализацию поставленных технических и лингвистических задач.
 
Отдельная благодарность за поддержку проекта <b>Батразу Хидирову, Вадиму Бердиеву, Дане и Зарине Алборовым, Юрию Дзекоеву, Тавитовой-Кардановой Зое, Марату Сабанову, Голубевой Бэлле, Гетоевой Ларисе, Лауре Юрьевне Г., Алану Хетаговичу Т.</b>
 
Особенно хотелось бы выделить и поблагодарить всех тех людей, благодаря которым появилось данное приложение:
 
Алборов Барисби
Алборова-Дзотцоева Лариса
Алборова Дана
Алборты Зарина
Аршиева Лора
Байцаев Заурбек
Байцаева Лема
Бердиев Вадим
Бициева Бэлла
Будаев Давид
Будаев Марат
Будаев Эдуард
Габеева-Гобаева Оксана
Галкина Светлана
Гаспарян Вардуи
Гегкиева Камила
Гетоев Владимир
Гетоев Руслан
Гетоев Сослан
Гетоева-Гецаева Фатима
Гетоева-Тускаева Эльвира
Гетоева Дзерасса
Гетоева Зарина
Гетоева Лариса
Гетоева Людмила
Гетоева Эльза
Голубева Бэлла
Григоращенко Юрий
Гурдзибеева Ирина
Джусоева Магдалина
Дзагурова Дана
Дзагурова Диана
Дзекоев Юрий
Дзидзоев Георгий
Дзотцоев Борис
Дзотцоева Алана
Дзотцоти Ирина
Елеева Нина
Елканов Заурбек
Елканова-Сабанова Дзерасса
Золоев Валерий
Зураев Ирлан
Кабалоева Джульетта
Кабалоева Фатима
Кадохова Мадина
Каирова Залина
Калухов Артур
Лолаева-Кибизова Зарема
Макоев Таймураз
Малиев Заурбек
Малиева Луиза
Мамаева Марина
Мамиева Вера
Мамиева Разиат
Мамукаев Казбек
Мамукаева Людмила
Миндзаев Игорь
Миндзаев Марат
Миндзаева Валентина
Михайлова-Сабанова Козетта
Сабанов Марат
Сабанов Сергей
Сабанов Тамерлан
Скодтаев Энвер
Сланова-Цаголова Галина
Суменова Бела
Тавасиева Залина
Тавитова-Карданова Зоя
Тайсаев Владимир Сулейманович
Тайсаев Владимир Тазретович
Тайсаев Рамазан
Таказов Валерий
Тандуева Людмила
Тегаева Зарема
Текоев Владимир
Текоева Альбина
Текоева Жанна
Текоева Рима
Томаев Борис
Томаев Феликс
Тубеев Роберт
Тургиев Таймураз
Тускаева Гуара
Уримагова Людмила
Уруймагов Александр
Халлаева Аза
Хидиров Батраз
Хлоева Зарема
Царикаева Рима
Цебоев Артур
Цебоева Ирина
Диана К.
Алихан Асланович Ц.
Азамат Б.
Людмила Германовна Р.
Катерина Маратовна Б.
Мадина Руслановна Б.
Фатима Магометовна К.
Залина Александровна Х.
Фатима Батарбековна С.
Оксана Алихановна Л.
Хетаг Олегович Т.
Артём Александрович Х.
Зарета Сахановна Д.
Константин Юрьевич Д.
Алан Хетагович Т.
Лаура Юрьевна Г.
Эдуард Юрьевич К.
Рустам Магамедович Д.
Бэлла Эльбрусовна К.
Екатерина Александровна Г
Алан Николаевич К.
Елена Александровна Г.
Лида Александровна З.
                      '''
                      : context.locale == const Locale('en', 'US')
                          ? '''
This application appeared thanks to the support of people who care about the situation and fate of the Digor langua

On behalf of the project manager, I would like to express my deep gratitude to the people who contributed to the creation of the mobile application:

<b>Alborova Zarina Aleksandrovna</b> - creator of the Digoria.com website <ref>https://www.digoria.com</ref> for her enthusiasm and unquenchable faith in the success of the project, her activity in disseminating information about fundraising, as well as about the progress of the project.

<b>Takazov Valery Dzantemirovich</b> - Doctor of Philology, Professor, for his great activity in matters of the status of the Digor language, organizing two scientific and practical conferences on the problems of the Digor language and culture, at which the mobile application of the Digor-Russian-English dictionary "Digor" was also presented. For responsiveness and assistance in various matters.

<b>Takazov Fedar Magometovich</b> - Doctor of Philological Sciences, Professor, creator of the Digor-Russian and Russian Digor dictionaries.

<b>Aslan Kudzaev</b> - creator of the electronic library in the VKontakte group "Bærzæfcæg" <ref>https://vk.com/barzafcag</ref> for scanning the Digor-Russian and Russian-Digor dictionary 2003, 2015.

<b>Magomedov Magomed</b> - creator of the application of the multilingual dictionary of North Caucasian languages "Bazur" <ref>https://play.google.com/store/apps/details?id=com.alkaitagi.avzag</ref> and "Avdan" <ref>https://play.google.com/store/apps/details?id=com.alkaitagi.avdan</ref> for consultative assistance in creating the project.

<b>Makarenko Maria Dmitrievna</b> - for linguistic assistance in the design of the dictionary structure.

<b>Dzutseva Lana</b> - for technical work on the Digor-Russian and Digor-English dictionaries.

<b>Zoloti Aliykhsan</b> - for the enormous work done in compiling the Turkish-Digor dictionary.

<b>To the staff of the newspaper "Digora"</b> - for distributing the news about the creation of a mobile application. <ref>https://gazeta-digora.ru/</ref>

In order to create the electronic dictionary "Digor", a fundraising campaign was announced to implement the set technical and linguistic tasks.

Special thanks for supporting the project to <b>Batraz Khidirov, Vadim Berdiev, Dana and Zarina Alborovs, Yuri Dzekoev, Tavitova-Kardanova Zoya, Marat Sabanov, Golubeva Bella, Getoeva Larisa, Laura Yuryevna G., Alan Khetagovich T.</b>

I would especially like to highlight and thank all those people who made this application possible:

Alborov Barisbi
Alborova-Dzotsoeva Larisa
Alborova Dana
Alborty Zarina
Arshieva Laura
Baitsaev Zaurbek
Baitsaeva Lema
Berdiev Vadim
Bitsieva Bella
Budaev David
Budaev Marat
Budaev Eduard
Gabeeva-Gobaeva Oksana
Galkina Svetlana
Gasparyan Varduhi
Gegkieva Kamila
Getoev Vladimir
Getoev Ruslan
Getoev Soslan
Getoeva-Getsaeva Fatima
Getoeva-Tuskaeva Elvira
Getoeva Dzerassa
Getoeva Zarina
Getoeva Larisa
Getoeva Ludmila
Getoeva Elza
Golubeva Bella
Grigorashchenko Yuri
Gurdzibeeva Irina
Dzhusoeva Magdalina
Dzagurova Dana
Dzagurova Diana
Dzekoev Yuri
Dzidzoev Georgy
Dzotsoev Boris
Dzotsoeva Alana
Dzotzoti Irina
Eleeva Nina
Elkanov Zaurbek
Elkanova-Sabanova Dzerassa
Kabaloeva Juliet
Kabaloeva Fatima
Kadokhova Madina
Kairova Zalina
Kalukhov Artur
Lolaeva-Kibizova Zarema
Makoev Taimuraz
Maliev Zaurbek
Malieva Louise
Mamaeva Marina
Mamieva Vera
Mamieva Raziat
Mamukaev Kazbek
Mamukaeva Lyudmila
Mindzaev Igor
Mindzaev Marat
Mindzaeva Valentina
Mikhailova-Sabanova Cosette
Sabanov Marat
Sabanov Sergey
Sabanov Tamerlan
Skodtaev Enver
Slanova-Tsagolova Galina
Sumenova Bela
Tavasieva Zalina
Tavitova-Kardanova Zoya
Taysaev Vladimir Suleimanovich
Taysaev Vladimir Tazretovich
Taysaev Ramazan
Takazov Valery
Tandueva Lyudmila
Tegaeva Zarema
Tekoev Vladimir
Tekoeva Albina
Tekoeva Zhanna
Tekoeva Rima
Tomaev Boris
Tomaev Felix
Tsarikaeva Rima
Tseboev Artur
Tseboeva Irina
Tubeev Robert
Turgiev Taimuraz
Tuskaeva Guara
Urimagova Ludmila
Uruimagov Alexander
Hallaeva Aza
Khidirov Batraz
Khloeva Zarema
Zoloev Valery
Zuraev Irlan
Diana K.
Alikhan Aslanovich Ts.
Azamat B.
Ludmila Germanovna R.
Katerina Maratovna B.
Madina Ruslanovna B.
Fatima Magometovna K.
Zalina Alexandrovna H.
Fatima Batarbekovna S.
Oksana Alikhanovna L.
Khetag Olegovich T.
Artyom Alexandrovich H.
Zareta Sakhanovna D.
Konstantin Yurievich D.
Alan Hetagovich T.
Laura Yurievna G.
Edward Yurievich K.
Rustam Magamedovich D.
Bella Elbrusovna K.
Ekaterina Alexandrovna G
Alan Nikolaevich K.
Elena Alexandrovna G.
Lida Alexandrovna Z.
                      '''
                          : context.locale == const Locale('tr', 'TR')
                              ? '''
Bu uygulama Digor dilinin durumu ve kaderiyle ilgilenen kişilerin desteği sayesinde ortaya çıktı.
 
Mobil uygulamanın oluşturulmasında emeği geçenlere proje yöneticisi adına en derin şükranlarımı sunmak isterim:
 
<b>Alborova Zarina Aleksandrovna</b> - Digoria.com web sitesinin <ref>https://www.digoria.com</ref> kurucusu, projenin başarısına olan coşkusu ve sarsılmaz inancı, bağış toplama ve projenin ilerleyişi hakkında bilgi yayma konusundaki etkinliği nedeniyle.
 
<b>Valeriy Dzantemirovich Takazov</b> - Filoloji Doktoru, Profesör, Digor dilinin statüsü konusundaki büyük çalışmaları, Digor dili ve kültürünün sorunları üzerine iki bilimsel ve pratik konferans düzenlemesi ve bu konferansta Digoronca-Rusça-İngilizce sözlüğünün mobil uygulaması "Digor"un da tanıtılması nedeniyle. Çeşitli konulardaki duyarlılığı ve yardımı için.
 
<b>Takazov Fedar Magometovich</b> - Filoloji Bilimleri Doktoru, Profesör, Digoronca-Rusça ve Rusça-Digoronca sözlüklerinin yaratıcısı.
 
<b>Kudzaev Aslan</b> - VKontakte grubu "Bærzæfcæg" elektronik kütüphanesinin yaratıcısı <ref>https://vk.com/barzafcag</ref> Digoronca-Rusça ve Rusça-Digoronca sözlüğünün 2003, 2015'te taranması için.
 
<b>Magomedov Magomed</b> - Kuzey Kafkas dilleri "Bazur" <ref>https://play.google.com/store/apps/details?id=com.alkaitagi.avzag</ref> ve "Avdan" <ref>https://play.google.com/store/apps/details?id=com.alkaitagi.avdan</ref> çok dilli sözlüğünün uygulamasının yaratıcısı, projenin oluşturulmasında danışmanlık yardımı için.
 
<b>Makarenko Maria Dmitrievna</b> - Sözlük yapısının tasarımında dilsel yardımlarından dolayı.
 
<b>Dzutseva Lana</b> - Digoronca-Rusça ve Digoronca-İngilizce sözlükleri üzerindeki teknik çalışmalarından dolayı.
 
<b>Zoloti Aliyhsan</b> - Türkçe-Digoronca sözlüğünün derlenmesinde yaptığı muazzam çalışmadan dolayı.
 
<b>"Digora" gazetesi çalışanlarına</b> - Mobil uygulama oluşturma haberini dağıttıkları için. <ref>https://gazeta-digora.ru/</ref>
 
Elektronik sözlük "Digor"un oluşturulması için belirlenen teknik ve dilsel görevlerin yerine getirilmesi amacıyla bir bağış kampanyası ilan edildi.
 
<b>Batraz Khidirov, Vadim Berdiev, Dana ve Zarina Alborovs, Yuri Dzekoev, Tavitova-Kardanova Zoya, Marat Sabanov, Golubeva Bella, Getoeva Larisa, Laura Yuryevna G., Alan Khetagovich T.</b>'ye projeyi destekledikleri için özellikle teşekkür ederiz.
 
Bu uygulamayı mümkün kılan herkese özellikle teşekkür etmek ve onları vurgulamak isterim:
 
 Alborov Barışbi
 Alborova-Dzotsoeva Larisa
 Alborova Dana
 Alborti Zarina
 Arşieva Laura
 Baitsaev Zaurbek
 Baitsaeva Lema
 Berdiyev Vadim
 Bitsiyeva Bella
 Budayev David
 Budayev Marat
 Budayev Eduard
 Gabeeva-Gobaeva Oksana
 Galkina Svetlana
 Gasparyan Varduhi
 Gegkieva Kamila
 Getoyev Vladimir
 Getoyev Ruslan
 Getoyev Soslan
 Getoeva-Getsaeva Fatima
 Getoeva-Tuskaeva Elvira
 Getoeva Dzerassa
 Getoeva Zarina
 Getoeva Larisa
 Getoeva Ludmila
 Getoeva Elza
 Golubeva Bella
 Grigoraşçenko Yuri
 Gurdzibeeva Irina
 Dzhusoeva Magdalina
 Dzagurova Dana
 Dzagurova Diana
 Dzekoyev Yuri
 Dzidzoev Georgy
 Dzotsoyev Boris
 Dzotsoeva Alana
 Dzotzoti Irina
 Eleeva Nina
 Elkanov Zaurbek
 Elkanova-Sabanova Dzerassa
 Kabaloeva Juliet
 Kabaloeva Fatima
 Kadokhova Medine
 Kayrova Zalina
 Kalukhov Artur
 Lolaeva-Kibizova Zarema
 Makoev Taimuraz
 Maliev Zaurbek
 Malieva Louise
 Mamaeva Marinası
 Mamieva Vera
 Mamieva Raziat
 Mamukayev Kazbek
 Mamukaeva Lyudmila
 Mindzayev İgor
 Mindzayev Marat
 Mindzaeva Valentina
 Mikhailova-Sabanova Cosette
 Sabanov Marat
 Sabanov Sergei
 Sabanov Tamerlan
 Skodtaev Enver
 Slanova-Tsagolova Galina
 Sümenova Bela
 Tavasieva Zalina
 Tavitova-Kardanova Zoya
 Taysaev Vladimir Süleymanoviç
 Taysaev Vladimir Tazretoviç
 Taysayev Ramazan
 Takazov Valery
 Tandueva Lyudmila
 Tegaeva Zarema
 Tekoev Vladimir
 Tekoeva Albina
 Tekoeva Zhanna
 Tekoeva Rima
 Tomayev Boris
 Tomayev Felix
 Tsarikaeva Rima
 Tseboyev Artur
 Tseboyeva Irina
 Tubeyev Robert
 Turgiev Taimuraz
 Tuskaeva Guara
 Urimagova Ludmila
 Uruimagov İskender
 Hallaeva Aza
 Hıdırov Batraz
 Khloeva Zarema
 Zoloev Valery
 Zuraev Irlan
 Diana K.
 Alihan Aslanoviç Ts.
 Azamet B.
 Ludmila Germanovna R.
 Katerina Maratovna B.
 Medine Ruslanovna B.
 Fatima Magometovna K.
 Zalina Aleksandrovna H.
 Fatima Batarbekovna S.
 Oksana Alikhanovna L.
 Hetag Olegovich T.
 Artyom Aleksandroviç H.
 Zareta Sakhanovna D.
 Konstantin Yuryeviç D.
 Alan Hetagoviç T.
 Laura Yuryevna G.
 Edward Yurievich K.
 Rustam Magamedovich D.
 Bella Elbrusovna K.
 Ekaterina Aleksandrovna G
 Alan Nikolayeviç K.
 Elena Aleksandrovna G.
 Lida Aleksandrovna Z.
                      '''
                              : '''
Ӕнхасӕн "Digor" фӕззиндтӕй ӕнӕвгъау адӕми ӕнхусӕй, дигорон ӕвзаги исонбонбӕл ка тухсуй, уони фӕрци.
 
Проекти разамонӕги номӕй, мӕн фӕндуй устур арфӕ ракӕнун аци ӕнхасӕнмӕ ӕ хай ка бахаста, уонӕн:
 
<b>Ӕлборти Зӕринӕн</b> - сайт Digoria.com - и аразӕгӕн <ref>https://www.digoria.com</ref> хъӕбӕр ке фенхус кодта, ӕновудӕй ке архайдта проект парахат кӕнунбӕл, уӕдта цӕмӕй проект кӕронмӕ исӕнхӕст уа, уобӕл. Устур нифс ӕма амалгун адӕймагӕн.
 
<b>Тахъазти Валерийӕн</b> - филологон наукити доктор, профессорӕн. Дигорон ӕвзаги паддзахадон статусбӕл архайӕгӕн, уӕдта дууӕ ӕнккӕтадӕмон конферецитӕ дигорон ӕвзаги туххӕй исаразӕгӕн. Е ’ргом ке ӕздахта алли зинкӕнуйнаг фарстатӕмӕ.
 
<b>Тахъазти Федарӕн</b> - филологон наукити доктор, профессорӕн. Дигорон-уруссаг, уруссаг-дигорон дзурдуӕтти аразӕгӕн.
 
<b>Кудзати Асланӕн</b> - электрон киунугӕдонӕ "Bærzæfcæg" - и аразӕгӕн <ref>https://vk.com/barzafcag</ref> дигорон-уруссаг, уруссаг-дигорон дзурдуӕттӕ ке рапарахат кодта социалон хизӕгти.
 
<b>Магомедову Магомеду</b> - Цӕгат Кавкази адӕмти ӕвзӕгутӕн электрон дзурдуат "Bazur" <ref>https://play.google.com/store/apps/details?id=com.alkaitagi.avzag</ref> ӕма "Avdan" <ref>https://play.google.com/store/apps/details?id=com.alkaitagi.avdan</ref> аразӕгӕн, ке амудта зин фарстати ӕнхасӕн куд аразгӕ ’й, е.
 
<b>Макаренко Марии Дмитриевне</b> - лингвистикон ӕнхус дзурдуӕтти арӕзтӕн.
 
<b>Дзуццати Ланӕн</b> - дигорон-уруссаг уӕдта дигорон-англисаг дзурдуӕттӕбӕл техникон ӕгъдӕуӕй ке байархайдта.
 
<b>Золойти Алийхсанӕн</b> - устур куст турккаг-дигорон дзурдуат ке исаразта, уой туххӕй.
 
<b>Газзет "Дигори" косгутӕн</b> - ке ниммухур кодтонцӕ уац дзурдуати туххӕй. <ref>https://gazeta-digora.ru/</ref>
 
Цӕмӕй электрон дзурдуат "Digor" фӕззиндтайдӕ, уомӕн арӕзт ӕрцудӕй ӕхцай фӕрӕзнити ӕмбурд.
 
Хецӕн боз зӕгъӕн проекти ӕнхусгӕнгутӕн <b>Хидирти Батразӕн, Бердити Вадимӕн, Ӕлборти Данӕн ӕма Зӕринӕн, Дзекоти Юрийӕн, Тауитти-Хъарданти Зойӕн, Сӕбанти Маратӕн, Голубевой Бэлле, Гетъоти Ларисӕн, Лауре Юрьевне Г., Алану Хетаговичу Т.</b>
 
Уӕлдайдӕр мах фӕндуй райарфӕ кӕнун еци адӕмӕн, ке фӕрци мах бон иссӕй ӕнхасӕн исаразун, етӕ ӕнцӕ:
 
Ӕлборти Барисби
Ӕлборти-Дзотцоти Ларисӕ
Ӕлборти Данӕ
Ӕлборти Зӕринӕ
Ӕрсити Лорӕ
Байцати Заурбек
Байцати Лемӕ
Бердити Вадим
Бицъити Бэлла
Будайти Давид
Будайти Марат
Будайти Эдуард
Габети-Гобати Оксанӕ
Галкина Светланӕ
Гаспарян Вардуи
Гегкити Камилӕ
Гетъоти Владимир
Гетъоти Руслан
Гетъоти Сослан
Гетъоти-Гецати Фатимӕ
Гетъоти-Тускъати Эльвирӕ
Гетъоти Дзерассӕ
Гетъоти Зӕринӕ
Гетъоти Ларисӕ
Гетъоти Людмилӕ
Гетъоти Эльзӕ
Голубева Бэллӕ
Григоращенко Юрий
Гурдзибети Иринӕ
Джусойти Магдалинӕ
Дзагурти Данӕ
Дзагурти Дианӕ
Дзекоти Юрий 
Дзидзойти Георгий
Дзотцоти Барис
Дзотцоти Аланӕ
Дзотцоти Иринӕ
Елети Нинӕ
Елхъанти Заурбек
Елхъанти-Сӕбанти Дзерассӕ
Золойти Валерий
Зурати Ирлан
Хъабалоти Джульеттӕ
Хъабалоти Фатимӕ
Хъадохти Мадинӕ
Хъаирти Зӕлинӕ
Кӕлухти Артур
Лолати-Къибизти Заремӕ
Махъоти Таймураз
Малити Заурбек
Малити Луизӕ
Мамайти Маринӕ
Мамити Верӕ
Мамити Разиат
Мамукъати Къазбек
Мамукъати Людмилӕ
Миндзайти Игорь
Миндзайти Марат
Миндзайти Валентинӕ
Михайлова-Сӕбӕнти Козеттӕ
Сӕбӕнти Марат
Сӕбӕнти Сергей
Сӕбӕнти Тамерлан
Скъодтати Энвер
Сланти-Цӕголти Галинӕ
Сументи Белӕ
Тауасити Зӕлинӕ
Тауитти-Хъарданти Зоя
Тайсаути Владимир Сулеймани фурт
Тайсаути Владимир Тазарети фурт
Тайсаути Рамазан
Тахъазти Валерий
Тандути Людмилӕ
Тегати Заремӕ
Текъойти Владимир
Текъойти Альбинӕ
Текъойти Жаннӕ
Текъойти Римӕ
Томайти Барис
Томайти Феликс
Тубети Роберт
Тургити Таймураз
Тускъати Гуарӕ
Уримӕгти Людмилӕ
Уруймӕгти Александр
Хӕллати Азӕ
Хидирти Батраз
Хлойти Заремӕ
Царикъати Римӕ
Цъебойти Артур
Цъебойти Иринӕ
Диана К.
Алихан Асланович Ц.
Азамат Б.
Людмила Германовна Р.
Катерина Маратовна Б.
Мадина Руслановна Б.
Фатима Магометовна К.
Залина Александровна Х.
Фатима Батарбековна С.
Оксана Алихановна Л.
Хетаг Олегович Т.
Артём Александрович Х.
Зарета Сахановна Д.
Константин Юрьевич Д.
Алан Хетагович Т.
Лаура Юрьевна Г.
Эдуард Юрьевич К.
Рустам Магамедович Д.
Бэлла Эльбрусовна К.
Екатерина Александровна Г
Алан Николаевич К.
Елена Александровна Г.
Лида Александровна З.
                      ''',
                  // textAlign: TextAlign.justify,
                  style: theme.textTheme.headlineSmall!.copyWith(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.justify,
                  tags: {
                    'b': StyledTextActionTag(
                      (String? text, Map<String?, String?> attrs) {},
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          textBaseline: TextBaseline.ideographic),
                    ),
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
              ),
            ),
          ),
        ));
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
