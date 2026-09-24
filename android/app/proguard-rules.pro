# ML Kit Text Recognition only bundles the Latin recognizer. R8 references the
# optional language-specific recognizers, which are not included as dependencies.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
