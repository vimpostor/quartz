import QtQuick
import QtQuick.Controls.Material
import Quartz

DropArea {
	onDropped: (drop) => snackbar.display(drop.urls[0]);
	Snackbar {
		id: snackbar
	}
	Label {
		text: "Drop files here"
		anchors.centerIn: parent
	}
}
