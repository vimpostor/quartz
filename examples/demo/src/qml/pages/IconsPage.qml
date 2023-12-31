import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import Quartz

Item {
	ColumnLayout {
		anchors.fill: parent
		anchors.topMargin: 4
		spacing: 8
		Search {
			id: search
			placeholderText: "Search icons"
			width: parent.width - 16
			Layout.alignment: Qt.AlignHCenter
			focus: true
		}
		ListView {
			clip: true
			Layout.fillWidth: true
			Layout.fillHeight: true
			ScrollBar.vertical: ScrollBar {}
			model: Codepoints.allIconNames()
			delegate: ItemDelegate {
				text: modelData
				width: parent ? parent.width : 0
				height: implicitHeight * (modelData.indexOf(search.text) != -1)
				visible: height
				Behavior on height {
					NumberAnimation {
						easing.type: Easing.OutCirc
						duration: 128
					}
				}
				onClicked: {
					Quartz.copyClipboard(modelData);
					snackbar.display("Copied \"" + modelData + "\"");
				}
				Icon {
					anchors { verticalCenter: parent.verticalCenter; right: parent.right; margins: 32 }
					name: modelData
					size: parent.height
				}
			}
		}
	}
	Snackbar {
		id: snackbar
	}
}
