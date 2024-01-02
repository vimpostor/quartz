#include "codepoints.hpp"

#ifndef NDEBUG
#include <iostream>
#endif

QString Codepoints::icon(QString name) {
	// only load the codepoints file on demand on first access
	init();

	if (codepoints.contains(name)) {
		return codepointToStr(codepoints.value(name));
	}

#ifndef NDEBUG
	std::cerr << "Icon " << name.toStdString() << " does not exist." << std::endl;
#endif
	return QString();
}

QList<QString> Codepoints::allIconNames() {
	init();
	auto res = codepoints.keys();
	res.sort();
	return res;
}

QString Codepoints::codepointToStr(const int32_t codepoint) {
	return QString(static_cast<QChar>(codepoint));
}

void Codepoints::init() {
	if (codepoints.size()) {
		// already init
		return;
	}

	QFile f {":/MaterialSymbols.codepoints"};
	if (f.open(QFile::ReadOnly)) {
		QTextStream in {&f};
		while (!in.atEnd()) {
			const auto line = in.readLine();
			if (line.size()) {
				// example: settings e8b8
				auto split = line.split(' ', Qt::SkipEmptyParts);
				if (split.size() == 2) {
					const auto name = split.at(0);
					const auto hex = split.at(1).toInt(nullptr, 16);
					codepoints.emplace(name, hex);
				}
			}
		}
	}
}
