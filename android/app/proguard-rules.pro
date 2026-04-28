##############################################
## Project Package
##############################################
-keep class gov.bdg.panduan.** { *; }

##############################################
## Core Android Components
##############################################
-keep public class * extends android.app.Application
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends androidx.lifecycle.ViewModel
-keep public class * extends androidx.lifecycle.LiveData

##############################################
## Flutter Engine & Plugins
##############################################
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

-keep class * extends io.flutter.embedding.android.FlutterActivity
-keep class * extends io.flutter.embedding.android.FlutterFragmentActivity

##############################################
## Firebase (Core, Messaging, Remote Config)
##############################################
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-dontwarn io.grpc.**

-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

##############################################
## Networking: Dio, OkHttp, Okio
##############################################
-keep class okhttp3.** { *; }
-keep interface okhttp3.**
-keep class okio.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

-keep class com.github.ihsanbal.logging.** { *; }
-dontwarn com.github.ihsanbal.logging.**

##############################################
## Gson (RECOMMENDED for flutter_local_notifications < v19)
##############################################
# -keepattributes Signature
# -keepattributes *Annotation*

# -dontwarn sun.misc.**

# -keep class * extends com.google.gson.TypeAdapter
# -keep class * implements com.google.gson.TypeAdapterFactory
# -keep class * implements com.google.gson.JsonSerializer
# -keep class * implements com.google.gson.JsonDeserializer

# -keepclassmembers,allowobfuscation class * {
#   @com.google.gson.annotations.SerializedName <fields>;
# }

# -keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
# -keep,allowobfuscation,allowshrinking class * extends com.google.gson.reflect.TypeToken

##############################################
## Secure Storage & Keystore
##############################################
-keep class io.flutter.plugins.fluttersecurestorage.** { *; }
-keep class com.it_nomads.fluttersecurestorage.** { *; }
-keep class androidx.security.crypto.** { *; }
-keep class android.security.keystore.** { *; }
-keep class android.security.** { *; }

##############################################
## local_auth & biometric_storage
##############################################
-keep class io.flutter.plugins.localauth.** { *; }
-keep class androidx.biometric.** { *; }
-keep class design.codeux.biometric_storage.** { *; }

##############################################
## Shared Preferences
##############################################
-keep class io.flutter.plugins.sharedpreferences.** { *; }

##############################################
## Location & Maps
##############################################
-keep class com.google.android.gms.location.** { *; }
-keep class com.google.android.gms.maps.** { *; }
-dontwarn com.google.android.libraries.**

##############################################
## Geolocator
##############################################
-keep class com.baseflow.geolocator.** { *; }

##############################################
## flutter_local_notifications
##############################################
-keep class com.dexterous.flutterlocalnotifications.** { *; }

##############################################
## File Picker
##############################################
-keep class com.mr.flutter.plugin.filepicker.** { *; }

##############################################
## Image Picker
##############################################
-keep class io.flutter.plugins.imagepicker.** { *; }

##############################################
## WebView (webview_flutter)
##############################################
-keep class android.webkit.WebView { *; }
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
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

##############################################
## Camera Plugin
##############################################
-keep class io.flutter.plugins.camera.** { *; }

##############################################
## Toastification
##############################################
-keep class com.toastification.** { *; }

##############################################
## OpenFileX
##############################################
-keep class com.jcraft.jsch.** { *; }
-keep class com.openfilex.** { *; }

##############################################
## URL Launcher
##############################################
-keep class io.flutter.plugins.urllauncher.** { *; }

##############################################
## Misc
##############################################
-keep class **.R$* { *; }
-dontwarn **.R

##############################################
## Remove debug log in release
##############################################
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** w(...);
    public static *** v(...);
    public static *** i(...);
}
