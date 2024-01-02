import QtQuick.Controls.Material
import Quartz

Button {
	property alias name: icon.name

	width: 56
	height: 56
	highlighted: true
	topInset: 0
	bottomInset: 0
    Material.roundedScale: Material.LargeScale
	Icon {
		id: icon
		size: 24
		anchors.centerIn: parent
	}
}
