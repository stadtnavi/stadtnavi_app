import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:stadtnavi_core/base/pages/about/about_section/about_section.dart';
import 'package:trufi_core/base/pages/about/translations/about_localizations.dart';
import 'package:trufi_core/base/utils/packge_info_platform.dart';
import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';

class AboutPage extends StatelessWidget {
  static const String route = "/Home/About";

  const AboutPage({
    Key? key,
    required this.appName,
    required this.cityName,
    required this.urlRepository,
    required this.drawerBuilder,
  }) : super(key: key);

  final String appName;
  final String cityName;
  final String urlRepository;
  final WidgetBuilder drawerBuilder;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: drawerBuilder(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(children: [
        Text(Localizations.localeOf(context).languageCode == "en"
            ? "About this service"
            : "Über diesen Dienst")
      ]),
    );
  }

  Widget _buildBody(BuildContext context) {
    final localization = AboutLocalization.of(context);
    final theme = Theme.of(context);
    return Scrollbar(
      child: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  appName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                Text(
                  cityName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.textTheme.bodyLarge?.color,
                    fontSize: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: AboutSection(
                    appName: appName,
                    cityName: cityName,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      return customShowLicensePage(
                        context: context,
                        applicationName: appName,
                        applicationLegalese: cityName,
                        applicationIcon: Container(
                          padding: const EdgeInsets.all(20),
                          height: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                        useRootNavigator: true
                      );
                    },
                    child: Text(localization.aboutLicenses),
                  ),
                ),
                FutureBuilder(
                  future: PackageInfoPlatform.version(),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<String> snapshot,
                  ) {
                    if (snapshot.hasError ||
                        snapshot.connectionState != ConnectionState.done) {
                      return const Text("");
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          localization.version(snapshot.data ?? ''),
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    );
                  },
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: InkWell(
                    onTap: () {
                      launch(urlRepository);
                    },
                    child: Text(
                      localization.aboutOpenSource,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void customShowLicensePage({
    required BuildContext context,
    String? applicationName,
    String? applicationVersion,
    Widget? applicationIcon,
    String? applicationLegalese,
    bool useRootNavigator = false,
  }) {
    Navigator.of(context, rootNavigator: useRootNavigator)
        .push(MaterialPageRoute<void>(
      builder: (BuildContext context) => BaseTrufiPage(
        child: LicensePage(
          applicationName: applicationName,
          applicationVersion: applicationVersion,
          applicationIcon: applicationIcon,
          applicationLegalese: applicationLegalese,
        ),
      ),
    ));
  }
}
