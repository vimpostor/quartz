#include "util.hpp"

#include <QGuiApplication>

namespace quartz {
namespace util {

bool is_wayland() {
	return QGuiApplication::platformName() == "wayland";
}

}
}
