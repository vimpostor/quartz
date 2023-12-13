#include "signals.hpp"

#ifdef Q_OS_UNIX

#include <iostream>
#include <ranges>
#include <signal.h>
#include <sys/socket.h>

namespace quartz {

Signals::Signals(const std::initializer_list<int> &sigs, std::function<void(void)> callback) {
	this->callback = callback;
	if (socketpair(AF_UNIX, SOCK_STREAM, 0, signal_fd)) {
		std::cerr << "Could not create HUP socketpair" << std::endl;
	}
	sn = new QSocketNotifier(signal_fd[1], QSocketNotifier::Read, this);
	connect(sn, &QSocketNotifier::activated, this, &Signals::handle_qt_signal);
	setup_signal_handlers(sigs);
}

void Signals::handle_unix_signal(int) {
	char a = 1;
	// only very few, async-signal-safe methods are allowed in the signal handler
	std::ignore = write(signal_fd[0], &a, sizeof(a));
}

void Signals::handle_qt_signal() {
	sn->setEnabled(false);
	char a;
	std::ignore = read(signal_fd[1], &a, sizeof(a));

	this->callback();

	sn->setEnabled(true);
}

void Signals::setup_signal_handlers(const std::initializer_list<int> &sigs) {
	struct sigaction act;

	act.sa_handler = Signals::handle_unix_signal;
	sigemptyset(&act.sa_mask);
	act.sa_flags = 0;
	act.sa_flags |= SA_RESTART;

	std::ranges::for_each(sigs, [&](const auto &s) {
		if (sigaction(s, &act, nullptr)) {
			std::cerr << "Could not setup signal handler" << std::endl;
			return;
		}
	});
}

}

#endif
