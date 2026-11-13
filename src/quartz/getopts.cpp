#include "getopts.hpp"

#include <QRegularExpression>
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
		static const QRegularExpression spaces {"\\s+(?=([^\"]*\"[^\"]*\")*[^\"]*$)"};
		for (auto &word : QString(prepend).split(spaces)) {
			result.push_back(word.remove('"'));
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
