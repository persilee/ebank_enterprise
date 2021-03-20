# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile
#-------------------------------------------定制化区域----------------------------------------------
#---------------------------------1.实体类---------------------------------


#-------------------------------------------------------------------------

#---------------------------------2.第三方包-------------------------------

# 簽裏眼sdk
-dontwarn rx.*
-dontwarn  sun.misc.**

-keepclassmembers class rx.internal.util.unsafe.*ArrayQuene*Field*{
 long producerIndex;
 long consumerIndex;
 }

-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueProducerNodeRef {
 rx.internal.util.atomic.LinkedQueueNode producerNode;
 rx.internal.util.atomic.LinkedQueueNode consumerNode;

 }

-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueConsumerNodeRef {
 rx.internal.util.atomic.LinkedQueueNode consumerNode;
 }


#处理反射类 不能混淆
#处理js交互 不能混淆
#处理第三方依赖库 不能混淆
#自定义
-keep class com.cqyuntong.asource.components.** { * ; }
-keep class com.cqyuntong.asource.** { * ;}
-keep class com.bufeng.videoSDKbase.** {*;}
-keep class com.bufeng.videoSDKbase.video.** {*;}
-keep class com.bufeng.videoSDKbase.utils.** {*;}

-keep class com.bufeng.videoSDKbase.utils.VideoUtil {*;}
-keep class com.bufeng.videoSDKbase.common.** {*;}
-keep class com.bufeng.videoSDKbase.base.** {*;}
-keep class com.bufeng.videoSDKbase.video.model.** {*;}
-keep class rx.internal.util.** { *; }
-keep class com.bufeng.videoSDKbase.retrofit.** { *; }


-keep class com.github.barteksc.pdfviewer.** {*;}
-keep class com.cloudroom.** {*;}
-keep public class com.cloudroom.** {*;}
-keep class * { native <methods>; }
-keep class com.cloudroom.cloudroomvideosdk.** { *; }
-keep class com.cloudroom.cloudroomvideosdk.model.** { *; }
-keep class com.cloudroom.tool.** { *; }
-keep class com.cloudroom.screencapture.** { *; }
-keep class org.crmedia.** { *; }
-keep class org.crmedia.clearvoice.** { *; }
-keep class org.crmedia.crvedemo.** { *; }
-keep class org.qtproject.qt5.android.** { *; }
-keep class org.qtproject.qt5.android.bearer.** { *; }
-keep class org.qtproject.qt5.android.accessibility.** { *; }




-keep class com.squareup.okhttp.* { *; }
-keep interface com.squareup.okhttp.** { *; }
-dontwarn com.squareup.okhttp.**
# okhttp 3
-keepattributes Signature
-keepattributes *Annotation*
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**

# Okio
-dontwarn com.squareup.**
-dontwarn okio.**
-keep public class org.codehaus.* { *; }
-keep public class java.nio.* { *; }
#----------okhttp end--------------
# 对于带有回调函数的onXXEvent、**On*Listener的，不能被混淆
-keepclassmembers class * {
    void *(**On*Event);
    void *(**On*Listener);
}



-keep public class com.webank.facelight.tools.WbCloudFaceVerifySdk{
    public <methods>;
    public static final *;
}
-keep public class com.webank.facelight.tools.WbCloudFaceVerifySdk$*{
    *;
}
-keep public class com.webank.record.**{
    public <methods>;
    public static final *;
}
-keep public class com.webank.facelight.ui.FaceVerifyStatus{
    *;
}
-keep public class com.webank.facelight.ui.FaceVerifyStatus$Mode{
    *;
}
-keep public class com.webank.facelight.tools.IdentifyCardValidate{
    public <methods>;
}
-keep public class com.tencent.youtulivecheck.**{
    *;
}
-keep public class com.webank.facelight.contants.**{
    *;
}
-keep public class com.webank.facelight.listerners.**{
    *;
}
-keep public class com.webank.facelight.Request.*$*{
    *;
}
-keep public class com.webank.facelight.Request.*{
    *;
}
-keep public class com.webank.facelight.config.FaceVerifyConfig {
    public <methods>;
}

-keep class com.tencent.youtuface.**{
    *;
}
-keep class com.tencent.youtulivecheck.**{
    *;
}
-keep class com.tencent.youtufacetrack.**{
    *;
}
-keep class com.tencent.youtufacelive.model.**{
    *;
}
-keep class com.tencent.youtufacelive.tools.FileUtils{
public <methods>;
}
-keep class com.tencent.youtufacelive.tools.YTUtils{
    public <methods>;
}
-keep class com.tencent.youtufacelive.tools.YTFaceLiveLogger{
    public <methods>;
}
-keep class com.tencent.youtufacelive.tools.YTFaceLiveLogger$IFaceLiveLogger{
     *;
}
-keep class com.tencent.youtufacelive.IYTMaskStateListener{
    *;
}
-keep class com.tencent.youtufacelive.YTPreviewHandlerThread{
    public static *;
    public <methods>;
}
-keep class com.tencent.youtufacelive.YTPreviewHandlerThread$IUploadListener{
     *;
}
-keep class com.tencent.youtufacelive.YTPreviewHandlerThread$ISetCameraParameterListener{
     *;
}
-keep class com.tencent.youtufacelive.YTPreviewMask{
    public <methods>;
}
-keep class com.tencent.youtufacelive.YTPreviewMask$TickCallback{
    *;
}
-keeppackagenames com.webank.mbank.permission_request
# 保留自定义控件(继承自View)不能被混淆
-keep public class * extends android.view.View {
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
    public void set*(***);
    *** get* ();
}
################云刷脸混淆规则 faceverify-END########################

#############webank normal混淆规则-BEGIN###################
#不混淆内部类
-keepattributes Signature

-keep, allowobfuscation @interface com.webank.normal.xview.Inflater
-keep, allowobfuscation @interface com.webank.normal.xview.Find
-keep, allowobfuscation @interface com.webank.normal.xview.BindClick

-keep @com.webank.normal.xview.Inflater class *
-keepclassmembers class * {
    @com.webank.normal.Find *;
    @com.webank.normal.BindClick *;
}

-keep public class com.webank.normal.net.*$*{
    *;
}
-keep public class com.webank.normal.net.*{
    *;
}
-keep public class com.webank.normal.thread.*$*{
   *;
}
-keep public class com.webank.normal.thread.*{
   *;
}
-keep public class com.webank.normal.tools.WLogger{
    *;
}
-keep public class com.webank.normal.tools.*{
*;
}

#wehttp混淆规则
-dontwarn com.webank.mbank.okio.**

-keep class com.webank.mbank.wehttp.**{
    public <methods>;
}
-keep interface com.webank.mbank.wehttp.**{
    public <methods>;
}
-keep public class com.webank.mbank.wehttp.WeLog$Level{
    *;
}
-keep class com.webank.mbank.wejson.WeJson{
    public <methods>;
}
-keep public class com.webank.mbank.wehttp.WeReq$ErrType{
     *;
}
#webank normal包含的第三方库bugly
-keep class com.tencent.bugly.webank.**{
    *;
}
###########webank normal混淆规则-END#######################
# 簽裏眼sdk

#wehttp混淆规则
-dontwarn com.webank.mbank.okio.**

-keep class com.webank.mbank.wehttp.**{
    public <methods>;
}
-keep interface com.webank.mbank.wehttp.**{
    public <methods>;
}
-keep public class com.webank.mbank.wehttp.WeLog$Level{
    *;
}
-keep class com.webank.mbank.wejson.WeJson{
    public <methods>;
}
-keep public class com.webank.mbank.wehttp.WeReq$ErrType{
     *;
}
#webank normal包含的第三方库bugly
-keep class com.tencent.bugly.webank.**{
    *;
}
###########webank normal混淆规则-END#######################


## support:appcompat-v7
-keep public class android.support.v7.widget.** { *; }
-keep public class android.support.v7.internal.widget.** { *; }
-keep public class android.support.v7.internal.view.menu.** { *; }

-keep public class * extends android.support.v4.view.ActionProvider {
    public <init>(android.content.Context);
}

#-------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------

#-------------------------------------------基本不用动区域--------------------------------------------
#---------------------------------基本指令区----------------------------------
-optimizationpasses 5
-dontskipnonpubliclibraryclassmembers
-printmapping proguardMapping.txt
-optimizations !code/simplification/cast,!field/*,!class/merging/*
-keepattributes *Annotation*,InnerClasses
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
#----------------------------------------------------------------------------

#---------------------------------默认保留区---------------------------------
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.Preference
-keep public class * extends android.view.View
-keep public class com.android.vending.licensing.ILicensingService
-keep class android.support.** {*;}

-keep public class * extends android.view.View{
    *** get*();
    void set*(***);
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
-keep class **.R$* {
 *;
}
-keepclassmembers class * {
    void *(**On*Event);
}
#----------------------------------------------------------------------------