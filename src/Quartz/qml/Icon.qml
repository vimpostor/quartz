import QtQuick
import QtQuick.Controls.Material
import Quartz

Label {
	property string name;
	property int size: 24
	// variable font axes
	property bool filled: false // range: {false, true}
	property int weight: 400 // range: [100, 700]
	property int grade: 0 // range: [-25, 200]
	property int opticalSize: 24 // range: [20, 48]

	width: size
	height: size
	text: Codepoints.icon(name)
	font.family: Icons.family
	font.pixelSize: size
	// TODO: Uncomment with Qt 6.7
	// font.variableAxes: { "FILL": filled, "wght": weight, "GRAD": grade, "opsz": opticalSize }
	horizontalAlignment: Text.AlignHCenter
	verticalAlignment: Text.AlignVCenter
}
