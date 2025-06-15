import QtQuick
import QtQuick.Controls.Material

ApplicationWindow {
	visible: true
	Shortcut {
		sequence: StandardKey.Quit
		onActivated: Qt.quit();
	}
}
