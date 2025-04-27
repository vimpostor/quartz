#pragma once

#include <QFile>
#include <QHash>

#include "macros.hpp"

class Codepoints : public QObject {
	Q_OBJECT
	QML_ELEMENT
	QML_SINGLETON
public:
	QML_CPP_SINGLETON(Codepoints)

	Q_INVOKABLE QString icon(QString name);
	Q_INVOKABLE QList<QString> allIconNames();
	static QString codepointToStr(const int32_t codepoint);
private:
	QHash<QString, int> codepoints;
	void init();
};
