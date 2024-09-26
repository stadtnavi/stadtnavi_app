import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:trufi_core/base/pages/feedback/translations/feedback_localizations.dart';

class FeedbackPage extends StatelessWidget {
  static const String route = "/Home/Feedback";
  final String urlFeedback;
  final Widget Function(BuildContext) drawerBuilder;

  const FeedbackPage({
    Key? key,
    required this.drawerBuilder,
    required this.urlFeedback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizationF = FeedbackLocalization.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [Text(localizationF.menuFeedback)]),
      ),
      drawer: drawerBuilder(context),
      body: Scrollbar(
        child: ListView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          children: <Widget>[
            Text(
              localizationF.feedbackTitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 20,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                localizationF.feedbackContent,
                style: theme.textTheme.bodyMedium,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          launchUrl(Uri.parse(urlFeedback));
        },
        heroTag: null,
        child: const Icon(Icons.feedback),
      ),
    );
  }
}
