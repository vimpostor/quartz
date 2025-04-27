#include "quartz.hpp"

#include <QClipboard>

void Quartz::copyClipboard(const QString &text) {
	QGuiApplication::clipboard()->setText(text);
}
