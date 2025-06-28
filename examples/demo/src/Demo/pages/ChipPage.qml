import QtQuick
import QtQuick.Controls.Material
import Quartz

Item {
	Column {
		anchors.fill: parent
		anchors.margins: 16
		spacing: 16
		GroupBox {
			anchors { left: parent.left; right: parent.right }
			title: "Assist chips"
			ChipFlow {
				anchors.left: parent.left
				anchors.right: parent.right
				Chip {
					text: "Estimate"
				}
				Chip {
					leftIco.name: "directions_car"
					text: "Directions"
				}
				Chip {
					text: "Walk"
				}
			}
		}
		GroupBox {
			anchors { left: parent.left; right: parent.right }
			title: "Filter chips"
			ChipFlow {
				anchors.left: parent.left
				anchors.right: parent.right
				Chip {
					type: Chip.Type.Filter
					text: "Sans"
				}
				Chip {
					type: Chip.Type.Filter
					text: "Variable font"
					leftIco.name: "brand_family"
				}
				Chip {
					type: Chip.Type.Filter
					text: "Serif"
					leftIco.name: "check"
					rightIco.name: "arrow_drop_down"
				}
			}
		}
		GroupBox {
			anchors { left: parent.left; right: parent.right }
			title: "Input chips"
			ChipFlow {
				anchors.left: parent.left
				anchors.right: parent.right
				Chip {
					type: Chip.Type.Input
					text: "John"
				}
				Chip {
					type: Chip.Type.Input
					text: "Alice"
					rightIco.name: "close"
				}
				Chip {
					type: Chip.Type.Input
					text: "Bob"
					imageSource: "https://m1.material.io/assets/0B5-3BCtasWxEV2R6bkNDOUxFZ00/style-icons-product-human-best-do1.png"
					rightIco.name: "close"
				}
			}
		}
		GroupBox {
			anchors { left: parent.left; right: parent.right }
			title: "Suggestion chips"
			ChipFlow {
				anchors.left: parent.left
				anchors.right: parent.right
				Chip {
					type: Chip.Type.Suggestion
					text: "Yes!"
				}
				Chip {
					type: Chip.Type.Suggestion
					text: "Cannot wait!"
				}
				Chip {
					type: Chip.Type.Suggestion
					text: "Let's go!"
					leftIco.name: "directions_car"
				}
			}
		}
		GroupBox {
			anchors { left: parent.left; right: parent.right }
			title: "Custom chips"
			ChipFlow {
				anchors.left: parent.left
				anchors.right: parent.right
				ComboChip {
					category: "Style"
					model: ["Outlined", "Rounded", "Sharp"]
				}
			}
		}
	}
}
