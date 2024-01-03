import QtQuick
import QtQuick.Controls.Material
import Quartz

Item {
	Card {
		anchors.centerIn: parent
		width: parent.width / 2
		height: width
		Label {
			text: "Hello world!"
			anchors.centerIn: parent
		}
	}
}
