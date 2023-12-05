#pragma once

#include <QGuiApplication>

#include "macros.hpp"
#include "util.hpp"
#include "version.hpp"

class Quartz : public QObject {
	Q_OBJECT
	QML_ELEMENT
	QML_SINGLETON
public:
	QML_CPP_SINGLETON(Quartz)

	Q_INVOKABLE void copyClipboard(const QString &text);
};
