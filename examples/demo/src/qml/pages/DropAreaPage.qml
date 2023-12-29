import QtQuick
import QtQuick.Controls.Material
import Quartz

DropArea {
	anchors.fill: parent
	onDropped: (drop) => snackbar.display(drop.urls[0]);
	Snackbar {
		id: snackbar
	}
	Label {
		text: "Drop files here"
		anchors.centerIn: parent
	}
}
