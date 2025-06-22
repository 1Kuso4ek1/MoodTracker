#include "DateFormatter.hpp"

#include <QDate>

QString DateFormatter::format(const QDateTime& date)
{
    const auto today = QDate::currentDate();

    if(QLocale::system().language() == QLocale::Russian)
        return formatRussian(date, today);
    return formatInternational(date, today);
}

QString DateFormatter::formatRussian(const QDateTime& date, const QDate& today)
{
    const QLocale russian(QLocale::Russian, QLocale::Russia);

    if(date.date() == today)
        return "сегодня, " + russian.toString(date, "d MMMM hh:mm");
    if(date.date() == today.addDays(-1))
        return "вчера, " + russian.toString(date, "d MMMM hh:mm");
    if(date.date() >= today.addDays(-6))
    {
        const auto dayOfWeek = russian.dayName(date.date().dayOfWeek(), QLocale::LongFormat);
        return dayOfWeek.toLower() + ", " + russian.toString(date, "d MMMM hh:mm");
    }

    return russian.toString(date, "d MMMM yyyy");
}

QString DateFormatter::formatInternational(const QDateTime& date, const QDate& today)
{
    const QLocale english(QLocale::English, QLocale::UnitedStates);

    if(date.date() == today)
        return "today, " + english.toString(date, "d MMMM hh:mm");
    if(date.date() == today.addDays(-1))
        return "yesterday, " + english.toString(date, "d MMMM hh:mm");
    if(date.date() >= today.addDays(-6))
    {
        const auto dayOfWeek = english.dayName(date.date().dayOfWeek(), QLocale::LongFormat);
        return dayOfWeek.toLower() + ", " + english.toString(date, "d MMMM hh:mm");
    }

    return english.toString(date, "d MMMM yyyy");
}
