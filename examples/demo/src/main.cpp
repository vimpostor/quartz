#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <iostream>

#include "quartz/Quartz/src/version.hpp"

int main(int argc, char *argv[]) {
	QGuiApplication app(argc, argv);

	std::cout << "Using quartz version " << Quartz::Version::version_string() << std::endl;

	QQmlApplicationEngine engine;
	engine.addImportPath(QStringLiteral(":/"));

	engine.loadFromModule("Demo", "Main");
	if (engine.rootObjects().isEmpty()) {
		return EXIT_FAILURE;
	}

	return app.exec();
}
