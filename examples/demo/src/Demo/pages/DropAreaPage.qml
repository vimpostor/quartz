import QtQuick
import QtQuick.Controls.Material
import Quartz

DropArea {
	onDropped: (drop) => {
		snackbar.display(drop.urls[0]);
		listView.model.push(drop.urls[0]);
	}
	Snackbar {
		id: snackbar
	}
	Label {
		text: "Drop files here"
		anchors.centerIn: parent
		visible: !listView.count
	}
	ListView {
		id: listView
		anchors.fill: parent
		model: []
		delegate: IconButton {
			ico.name: "upload_file"
			text: modelData
			width: parent.width
			DragArea {
				anchors.fill: parent
				target: parent.ico
				dragUri: modelData
			}
		}
	}
}
