import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/global_alerts_cubit/global_alerts_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/services/global_alerts/models/icons.dart';
import 'package:trufi_core/base/blocs/theme/theme_cubit.dart';

class BannerAlerts extends StatefulWidget {
  const BannerAlerts({super.key});

  @override
  State<BannerAlerts> createState() => _BannerAlertsState();
}

class _BannerAlertsState extends State<BannerAlerts> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool isExpandable = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = StadtnaviBaseLocalization.of(context);
    final globalAlertsCubit = context.watch<GlobalAlertsCubit>();
    final globalAlertsState = context.watch<GlobalAlertsCubit>().state;
    final getFilteredAlerts = globalAlertsState.getFilteredAlerts;
    return getFilteredAlerts.isNotEmpty
        ? Container(
            color: ThemeCubit.isDarkMode(theme)
                ? theme.appBarTheme.backgroundColor
                : theme.colorScheme.primary,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFDC0451),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: isExpandable
                        ? MediaQuery.of(context).size.height * 0.3
                        : 72,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: getFilteredAlerts.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final alert = getFilteredAlerts[index];
                        return Expanded(
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: SingleChildScrollView(
                                  physics: const ClampingScrollPhysics(),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 50,
                                      top: 12,
                                      right: 50,
                                      bottom: 0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          alert.alertHeaderText ?? "",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            height: 1,
                                            overflow: isExpandable
                                                ? null
                                                : TextOverflow.ellipsis,
                                          ),
                                          maxLines: isExpandable ? null : 2,
                                        ),
                                        const SizedBox(height: 8),
                                        RichText(
                                          maxLines: isExpandable ? null : 2,
                                          text: TextSpan(
                                            text: alert.alertDescriptionText,
                                            style: TextStyle(
                                              color: Colors.white,
                                              height: 1,
                                              fontSize: 13,
                                              overflow: isExpandable
                                                  ? null
                                                  : TextOverflow.ellipsis,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    localization.commonMoreInfo,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () async {
                                                        final selectedAlert =
                                                            globalAlertsState
                                                                    .alerts[
                                                                _currentIndex];
                                                        Uri uri = Uri.parse(
                                                            selectedAlert
                                                                    .alertUrl ??
                                                                '');
                                                        if (await canLaunchUrl(
                                                            uri)) {
                                                          await launchUrl(uri);
                                                        }
                                                      },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 12,
                                top: 12,
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: FittedBox(
                                    child: cautionSvg(
                                        color: Colors.white,
                                        backColor: const Color(0xFFDC0451)),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    globalAlertsCubit.deleteAlert(alert);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 8,
                      top: 4,
                      right: 8,
                      bottom: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (_currentIndex != 0) {
                                    _pageController.previousPage(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.bounceIn,
                                    );
                                  }
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Color(0xFFCCCCCC),
                                  size: 18,
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Row(
                                    children: getFilteredAlerts
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      return InkWell(
                                        onTap: () {
                                          _pageController.jumpToPage(entry.key);
                                        },
                                        child: Container(
                                          width: _currentIndex == entry.key
                                              ? 8
                                              : 6,
                                          height: _currentIndex == entry.key
                                              ? 8
                                              : 6,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 4.0,
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _currentIndex == entry.key
                                                ? Colors.white
                                                : const Color(0xFFCCCCCC),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (_currentIndex <
                                      getFilteredAlerts.length) {
                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.bounceIn,
                                    );
                                  }
                                },
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFFCCCCCC),
                                  size: 20,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: isExpandable
                              ? localization.commonShowLess
                              : localization.commonShowMore,
                          icon: Icon(
                            isExpandable
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          iconSize: 30,
                          onPressed: () {
                            setState(() {
                              isExpandable = !isExpandable;
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
