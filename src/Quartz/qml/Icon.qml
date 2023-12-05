import QtQuick
import QtQuick.Controls.Material
import Quartz

ToolButton {
	property string name;
	property int size: 24
	hoverEnabled: false

	focusPolicy: hoverEnabled ? Qt.StrongFocus : Qt.NoFocus
	icon.source: "/svg/" + name
	display: AbstractButton.IconOnly
	icon.width: width
	icon.height: height
	implicitWidth: size
	implicitHeight: implicitWidth
	padding: 0
	text: name
}
