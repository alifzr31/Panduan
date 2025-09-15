##############################################
## Project-specific keep rules
##############################################
-keep class com.example.dbdtbc.** { *; }
-keep class com.example.dbdtbc.models.** { *; }

##############################################
## Android core
##############################################
-keep public class * extends android.app.Application
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends androidx.lifecycle.ViewModel
-keep public class * extends androidx.lifecycle.LiveData

-keepclassmembers class ** {
    @android.webkit.JavascriptInterface <methods>;
}

-keepclassmembers class * {
    public void *(java.lang.String, java.lang.Class[]);
}

-keepclasseswithmembernames class * {
    native <methods>;
}

-dontwarn android.support.**
-dontwarn androidx.**
-keep class androidx.** { *; }

##############################################
## Flutter
##############################################
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep public class * extends io.flutter.embedding.android.FlutterActivity
-keep public class * extends io.flutter.embedding.android.FlutterFragmentActivity
-dontwarn io.flutter.embedding.**

##############################################
## Firebase
##############################################
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-dontwarn io.grpc.**

-keep class com.google.firebase.messaging.** { *; }
-keep class com.google.firebase.remoteconfig.** { *; }
-keepclassmembers class * {
    @com.google.firebase.remoteconfig.FirebaseRemoteConfigParameter public *;
}

-keep class com.google.android.gms.common.** { *; }
-keep interface com.google.android.gms.common.** { *; }
-dontwarn com.google.android.gms.**

# Maps
# -keep class com.google.maps.android.** { *; }
# -keep public class com.google.android.gms.maps.MapsInitializer { *; }
# -keep @interface com.google.android.gms.maps.**

##############################################
## Networking (Dio, OkHttp, Okio, Logging)
##############################################
-dontwarn okhttp3.**
-keepattributes Signature, *Annotation*, SourceFile, LineNumberTable
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-keep enum okhttp3.** { *; }

-keep class okio.** { *; }
-dontwarn okio.**

-keep class com.github.ihsanbal.logging.** { *; }
-dontwarn com.github.ihsanbal.logging.*

##############################################
## Flutter Secure Storage & Keystore
##############################################
-keep class io.flutter.plugins.fluttersecurestorage.** { *; }
-keep class androidx.security.crypto.** { *; }
-keepclassmembers class androidx.security.crypto.** { *; }
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

##############################################
## Lottie
##############################################
-keep class com.airbnb.lottie.** { *; }
-dontwarn com.airbnb.lottie.**

##############################################
## flutter_svg
##############################################
-keep class com.caverock.androidsvg.** { *; }
-dontwarn com.caverock.androidsvg.**
-keep class com.bumptech.glide.** { *; }
-dontwarn com.bumptech.glide.**

##############################################
## local_auth
##############################################
-keep class io.flutter.plugins.localauth.** { *; }
-keep class androidx.biometric.** { *; }

##############################################
## Toastification
##############################################
-keep class com.toastification.** { *; }

##############################################
## Misc
##############################################
-keep class java.util.** { *; }
-keep class org.intellij.lang.annotations.** { *; }
-dontwarn org.intellij.lang.annotations.**

# Preserve resource files (like .env, R classes)
-keep class **.R$* { *; }
-dontwarn **.R

# Hide Log methods in release
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** w(...);
    public static *** v(...);
    public static *** i(...);
}
