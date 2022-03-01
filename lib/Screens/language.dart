import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../widgets/languages.dart';

class LanguageTranslator extends StatefulWidget {
  static const String id = 'LanguageScreen';

  @override
  _LanguageTranslatorState createState() => _LanguageTranslatorState();
}

class _LanguageTranslatorState extends State<LanguageTranslator> {
  void _changeLanguage(Language language) {
    Locale _temp;
    switch (language.LanguageCode) {
      case 'en':
        _temp = Locale(language.LanguageCode, 'US');
        break;
      case 'de':
        _temp = Locale(language.LanguageCode, 'DE');
        break;
      case 'fr':
        _temp = Locale(language.LanguageCode, 'FR');
        break;
      case 'it':
        _temp = Locale(language.LanguageCode, 'IT');
        break;
      case 'ar':
        _temp = Locale(language.LanguageCode, 'EG');
        break;
      default:
        _temp = Locale(language.LanguageCode, 'US');
    }
    EasyLocalization.of(context).setLocale(_temp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose Your Language'.tr().toString(),
        ),
      ),
      body: ListView.builder(
        itemCount: Language.languageList().length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 550),
            child: SlideAnimation(
              horizontalOffset: 100,
              child: FadeInAnimation(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      onTap: () {
                        _changeLanguage(Language.languageList()[index]);
                      },
                      title: Text(Language.languageList()[index].name),
                      leading: Text(
                        Language.languageList()[index].flag,
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}