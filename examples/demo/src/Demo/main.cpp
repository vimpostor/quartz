#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <iostream>

#include "quartz/quartz.hpp"

int main(int argc, char *argv[]) {
	QCoreApplication::setOrganizationName("quartz");
	QCoreApplication::setApplicationName("demo");
	QGuiApplication app(argc, argv);

	std::cout << "Using quartz version " << quartz::version::version_string() << std::endl;

	QQmlApplicationEngine engine;

	engine.loadFromModule("Demo", "Main");
	if (engine.rootObjects().isEmpty()) {
		return EXIT_FAILURE;
	}

	return app.exec();
}
