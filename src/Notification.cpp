#include "Notification.hpp"

#include <QImage>
#include <QStandardPaths>
#include <QTemporaryFile>
#include <QUrl>

#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
#include <QtDBus/QDBusInterface>
#include <QtDBus/QDBusReply>
#elifdef Q_OS_ANDROID
#include <QBuffer>
#include <QJniEnvironment>
#include <QJniObject>
#include <jni.h>
#include <QtCore/private/qandroidextras_p.h>
#endif

void Notification::send() const
{
#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
    QDBusInterface interface(
        "org.freedesktop.Notifications",
        "/org/freedesktop/Notifications",
        "org.freedesktop.Notifications");

    // Might need some further work
    QString tempIconPath = icon;
    if(QFile::exists(icon))
    {
        QTemporaryFile tempFile(
            QStandardPaths::writableLocation(QStandardPaths::TempLocation)
             + "/notificationIcon.png"
        );
        tempFile.setAutoRemove(false);

        QImage(icon).save(&tempFile, "png");

        tempIconPath = QUrl::fromLocalFile(tempFile.fileName()).toString();
    }

    const QDBusReply<uint> reply = interface.callWithArgumentList(QDBus::AutoDetect, "Notify", {
        appName, replacesId, tempIconPath, title, message, actions, hints, timeout
    });

    if(reply.error().isValid())
        qDebug() << reply.error();
#elifdef Q_OS_ANDROID
    static const QJniObject activity = QNativeInterface::QAndroidApplication::context();

    static const auto channelId = QJniObject::fromString(qApp->applicationName());
    static const auto channelName = QJniObject::fromString(qApp->applicationName() + " notifier");

    auto notificationManager =
        activity.callObjectMethod(
            "getSystemService",
            "(Ljava/lang/String;)Ljava/lang/Object;",
            QJniObject::fromString("notification").object());

    static const auto importance =
        QJniObject::getStaticField<jint>("android/app/NotificationManager", "IMPORTANCE_DEFAULT");

    static const QJniObject notificationChannel(
        "android/app/NotificationChannel",
        "(Ljava/lang/String;Ljava/lang/CharSequence;I)V",
        channelId.object(), channelName.object(), importance);

    notificationManager.callMethod<void>(
        "createNotificationChannel",
        "(Landroid/app/NotificationChannel;)V",
        notificationChannel.object());

    const QJniObject builder(
        "android/app/Notification$Builder",
        "(Landroid/content/Context;Ljava/lang/String;)V",
        activity.object(), channelId.object());

    static const auto flags =
        QJniObject::getStaticField<jint>("android/content/Intent", "FLAG_ACTIVITY_NEW_TASK") |
        QJniObject::getStaticField<jint>("android/content/Intent", "FLAG_ACTIVITY_CLEAR_TASK");
    static const auto flagImmutable =
        QJniObject::getStaticField<jint>("android/app/PendingIntent", "FLAG_IMMUTABLE");

    static const QJniObject openIntent(
        "android/content/Intent",
        "(Landroid/content/Context;Ljava/lang/Class;)V",
        activity.object(),
        activity.objectClass());

    QJniObject pendingIntent;
    if(openIntent.isValid())
    {
        openIntent.callObjectMethod("setFlags", "(I)Landroid/content/Intent;", flags);
        pendingIntent = QJniObject::callStaticObjectMethod(
            "android/app/PendingIntent", "getActivity",
            "(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;",
            activity.object(), 0, openIntent.object(), flagImmutable);
    }

    QJniEnvironment env;

    bool iconValid = !icon.isEmpty();

    if(iconValid)
    {
        QImage iconImage(icon);
        QBuffer iconBuffer;

        if(iconImage.save(&iconBuffer, "png"))
        {
            const auto iconData = iconBuffer.buffer();
            const auto byteArrayObj = QJniObject::fromLocalRef(env->NewByteArray(iconData.size()));

            env->SetByteArrayRegion(
                byteArrayObj.object<jbyteArray>(),
                0, iconData.size(),
                reinterpret_cast<const jbyte*>(iconData.constData()));

            const auto bitmap = QJniObject::callStaticObjectMethod(
                "android/graphics/BitmapFactory", "decodeByteArray",
                "([BII)Landroid/graphics/Bitmap;",
                byteArrayObj.object<jbyteArray>(), 0, iconData.size());

            const auto iconObject = QJniObject::callStaticObjectMethod(
                "android/graphics/drawable/Icon", "createWithBitmap",
                "(Landroid/graphics/Bitmap;)Landroid/graphics/drawable/Icon;",
                bitmap.object());

            builder.callObjectMethod(
                "setSmallIcon",
                "(Landroid/graphics/drawable/Icon;)Landroid/app/Notification$Builder;",
                iconObject.object());

            builder.callObjectMethod(
                "setLargeIcon",
                "(Landroid/graphics/drawable/Icon;)Landroid/app/Notification$Builder;",
                iconObject.object());
        }
        else
            iconValid = false;
    }

    if(!iconValid)
    {
        static const auto transparentId = QJniObject::getStaticField<jint>(
            "android/R$color",
            "transparent"
        );

        builder.callObjectMethod("setSmallIcon", "(I)Landroid/app/Notification$Builder;", transparentId);
    }

    if(pendingIntent.isValid())
        builder.callObjectMethod(
            "setContentIntent",
            "(Landroid/app/PendingIntent;)Landroid/app/Notification$Builder;",
            pendingIntent.object());

    builder.callObjectMethod(
        "setContentTitle",
        "(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;",
        QJniObject::fromString(title).object());

    builder.callObjectMethod(
        "setContentText",
        "(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;",
        QJniObject::fromString(message).object());

    builder.callObjectMethod("setAutoCancel", "(Z)Landroid/app/Notification$Builder;", false);

    notificationManager.callMethod<void>(
        "notify", "(ILandroid/app/Notification;)V", 0,
        builder.callObjectMethod("build", "()Landroid/app/Notification;"));
#endif
}
