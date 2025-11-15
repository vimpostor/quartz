import QtQuick
import QtQuick.Controls.Material

ApplicationWindow {
	visible: true
	Shortcut {
		sequences: [StandardKey.Quit]
		onActivated: Qt.quit();
	}
}
