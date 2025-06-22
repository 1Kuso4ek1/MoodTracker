#pragma once
#include <QLocale>

class DateFormatter
{
public:
    static QString format(const QDateTime& date);

private:
    static QString formatRussian(const QDateTime& date, const QDate& today);
    static QString formatInternational(const QDateTime& date, const QDate& today);
};
