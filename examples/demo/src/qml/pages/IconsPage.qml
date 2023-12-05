import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quartz

Item {
	FolderListModel {
		id: iconModel
		folder: "qrc:/svg"
		showDirs: false
	}
	ColumnLayout {
		anchors.fill: parent
		spacing: 8
		TextField {
			id: search
			Layout.fillWidth: true
			placeholderText: "Search"
		}
		ListView {
			clip: true
			Layout.fillWidth: true
			Layout.fillHeight: true
			Component {
				id: iconDelegate
				ItemDelegate {
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
			model: iconModel
			delegate: iconDelegate
		}
	}
	Snackbar {
		id: snackbar
	}
}
