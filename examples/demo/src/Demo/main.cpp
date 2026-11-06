#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <print>

#include "quartz/quartz.hpp"

int main(int argc, char *argv[]) {
	QCoreApplication::setOrganizationName("quartz");
	QCoreApplication::setApplicationName("demo");
	QGuiApplication app(argc, argv);

	std::println("Using quartz version {}", quartz::version::version_string());

	QQmlApplicationEngine engine;

	engine.loadFromModule("Demo", "Main");
	if (engine.rootObjects().isEmpty()) {
		return EXIT_FAILURE;
	}

	return app.exec();
}
