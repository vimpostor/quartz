#include "themeimageprovider.hpp"

ThemeImageProvider::ThemeImageProvider(const QIcon& fallback_icon) : QQuickImageProvider(QQuickImageProvider::Pixmap), fallback(fallback_icon) {
}

QPixmap ThemeImageProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize) {
	if (size) {
		*size = QSize(128, 128);
	}
	const auto icon = QIcon::fromTheme(id, fallback);
	if (requestedSize.isValid()) {
		return icon.pixmap(requestedSize);
	}
	return icon.pixmap(128, 128);
}
