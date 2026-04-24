# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Play Core (referenced by Flutter but may not be present)
-dontwarn com.google.android.play.core.**

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Hive
-keep class hive.** { *; }
-keep class com.hivedb.** { *; }

# Keep annotations
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Prevent stripping native methods
-keepclasseswithmembernames class * {
    native <methods>;
}
