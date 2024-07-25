#include "getopts.hpp"

#include <ranges>

namespace quartz {
namespace getopts {

QStringList prepend_args(int argc, char *argv[], const char *prepend) {
	if (argc <= 0) {
		return {};
	}

	// start with the program name
	QStringList result = {argv[0]};

	if (prepend) {
		// add prepend args
		// just split prepend at every space for simplicity
		// in theory we would need to do more advanced parsing, e.g. respect ""
		for (const auto &word : std::views::split(std::string_view(prepend), " ")) {
			result.push_back(QString::fromUtf8(word));
		}
	}

	// add the remaining args
	for (auto i = 1; i < argc; ++i) {
		result.push_back(argv[i]);
	}

	return result;
}

}
}
