import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts
import Quartz

ToolButton {
	id: root
	property alias ico: icon
	padding: 0
	implicitWidth: icon.size
	implicitHeight: implicitWidth
	contentItem: RowLayout {
		Icon {
			id: icon
			Layout.fillWidth: true
			Layout.fillHeight: true
		}
		Label {
			text: root.text
			visible: root.text
			Layout.fillWidth: true
		}
	}
}
