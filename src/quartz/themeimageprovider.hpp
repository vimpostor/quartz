#pragma once

#include <QIcon>
#include <QQuickImageProvider>

/**
 * Register as image provider by calling on your QQmlApplicationEngine:
 * engine.addImageProvider(QLatin1String("theme"), new ThemeImageProvider(fallback));
 *
 * Then in QML use Image source: "image://theme/iconname"
 */
class ThemeImageProvider : public QQuickImageProvider {
public:
	explicit ThemeImageProvider(const QIcon& fallback_icon);

	QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize) override;
private:
	QIcon fallback;
};
