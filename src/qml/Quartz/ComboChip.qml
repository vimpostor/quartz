import QtQuick.Controls.Material
import Quartz

Chip {
	id: root
	property string category
	property alias model: combo.model
	property alias currentIndex: combo.currentIndex
	property string selectedText: checked ? combo.currentText : ""

	type: Chip.Type.Filter
	checked: currentIndex + 1
	text: checked ? selectedText : category
	leftIco.name: checked ? "check" : ""
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
