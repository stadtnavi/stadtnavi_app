## Generates all files for the given translation
list='stadtnavi_de.arb stadtnavi_en.arb'

#base command translations
for i in $list; do
flutter gen-l10n --arb-dir=translations/stadtnavi_base_localizations --template-arb-file=$i --output-localization-file=stadtnavi_base_localizations.dart --output-class=StadtnaviBaseLocalization --output-dir=lib/base/translations --no-synthetic-package
done


#SavedPlaces command translations
# for i in $list; do
#     flutter gen-l10n --arb-dir=translations/saved_places_localizations --template-arb-file=$i --output-localization-file=saved_places_localizations.dart --output-class=SavedPlacesLocalization --output-dir=lib/base/pages/saved_places/translations --no-synthetic-package
# done


#Feedback command translations
# for i in $list; do
#     flutter gen-l10n --arb-dir=translations/feedback_localizations --template-arb-file=$i --output-localization-file=feedback_localizations.dart --output-class=FeedbackLocalization --output-dir=lib/base/pages/feedback/translations --no-synthetic-package
# done

#Aboud command translations
# for i in $list; do
#     flutter gen-l10n --arb-dir=translations/about_localizations --template-arb-file=$i --output-localization-file=about_localizations.dart --output-class=AboutLocalization --output-dir=lib/base/pages/about/translations --no-synthetic-package
# done
