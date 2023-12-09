import QtQuick
import QtQuick.Controls.Material
import Quartz

ToolButton {
	property alias ico: ic
	padding: 0
	implicitWidth: ic.size
	implicitHeight: implicitWidth
	Icon {
		id: ic
		anchors.fill: parent
	}
}
