#pragma once

#include <QJSEngine>
#include <QQmlEngine>

// unfortunately macros don't support namespaces, so don't bother with one

#define SINGLETON(TYPE) \
	static TYPE *get() { \
		static TYPE s; \
		return &s; \
	}

#define QML_CPP_SINGLETON(TYPE) \
	TYPE() = delete; \
	explicit TYPE(bool) {}; \
	static TYPE *get() { \
		static TYPE s {true}; \
		return &s; \
	} \
	static TYPE *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine) { \
		auto res = get(); \
		QJSEngine::setObjectOwnership(res, QJSEngine::CppOwnership); \
		return res; \
	}
