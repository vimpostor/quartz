import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quartz

Item {
	ColumnLayout {
		anchors.fill: parent
		spacing: 8
		TextField {
			id: search
			Layout.fillWidth: true
			placeholderText: "Search"
			focus: true
		}
		ListView {
			clip: true
			Layout.fillWidth: true
			Layout.fillHeight: true
			model: FolderListModel {
				folder: "qrc:/svg"
				showDirs: false
			}
			delegate: ItemDelegate {
				required property string fileName
				width: parent ? parent.width : 0
				icon.source: "/svg/" + text
				text: fileName
				visible: fileName.indexOf(search.text) != -1
				height: visible * implicitHeight
				onClicked: {
					Quartz.copyClipboard(text);
					snackbar.text = "Copied \"" + text + "\"";
					snackbar.open();
				}
			}
		}
	}
	Snackbar {
		id: snackbar
	}
}
