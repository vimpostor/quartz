import QtQuick
import QtQuick.Controls.Material
import Quartz

DropArea {
	anchors.fill: parent
	onDropped: (drop) => {
		snackbar.text = drop.urls[0];
		snackbar.open();
	}
	Snackbar {
		id: snackbar
		timeout: 2000
	}
	Label {
		text: "Drop files here"
		anchors.centerIn: parent
	}
}
