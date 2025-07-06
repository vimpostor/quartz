import QtQuick.Controls.Material
import Quartz

Chip {
	id: root
	property string category
	property alias model: combo.model
	property alias currentIndex: combo.currentIndex
	property bool isSelected: currentIndex + 1
	property string selectedText: isSelected ? combo.currentText : ""

	type: Chip.Type.Filter
	text: isSelected ? selectedText : category
	leftIco.name: isSelected ? "check" : ""
	rightIco.name: "arrow_drop_down"
	onClicked: combo.popup.open()
	onRightIconClicked: combo.popup.open()
	ComboBox {
		id: combo
		property int lastIndex: -1
		visible: false
		currentIndex: -1
		Material.accent: root.parent.Material.accent
		onActivated: (i) => {
			if (i == lastIndex) {
				currentIndex = -1
				lastIndex = -1
			} else {
				lastIndex = currentIndex
			}
		}
	}
}
