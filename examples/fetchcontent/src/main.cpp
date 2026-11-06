#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <print>

#include "quartz/version.hpp"

int main(int argc, char *argv[]) {
	QGuiApplication app(argc, argv);

	std::println("Using quartz version {}", quartz::version::version_string());

	QQmlApplicationEngine engine;

	engine.loadFromModule("FetchContent", "Main");
	if (engine.rootObjects().isEmpty()) {
		return EXIT_FAILURE;
	}

	return app.exec();
}
