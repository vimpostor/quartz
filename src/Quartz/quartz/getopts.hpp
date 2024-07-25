#pragma once

#include <QStringList>

namespace quartz {
namespace getopts {

QStringList prepend_args(int argc, char *argv[], char *prepend);

}
}
