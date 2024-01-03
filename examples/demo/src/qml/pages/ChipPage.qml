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
				Chip {
					text: "Estimate"
				}
				Chip {
					leftIcoName: "directions_car"
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
				Chip {
					type: Chip.Type.Filter
					text: "Sans"
				}
				Chip {
					type: Chip.Type.Filter
					text: "Variable font"
					leftIcoName: "brand_family"
				}
				Chip {
					type: Chip.Type.Filter
					text: "Serif"
					leftIcoName: "check"
					rightIcoName: "arrow_drop_down"
				}
			}
		}
		GroupBox {
			anchors { left: parent.left; right: parent.right }
			title: "Input chips"
			ChipFlow {
				Chip {
					type: Chip.Type.Input
					text: "John"
				}
				Chip {
					type: Chip.Type.Input
					text: "Alice"
					rightIcoName: "close"
				}
				Chip {
					type: Chip.Type.Input
					text: "Bob"
					imageSource: "https://m1.material.io/assets/0B5-3BCtasWxEV2R6bkNDOUxFZ00/style-icons-product-human-best-do1.png"
					rightIcoName: "close"
				}
			}
		}
		GroupBox {
			anchors { left: parent.left; right: parent.right }
			title: "Suggestion chips"
			ChipFlow {
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
					leftIcoName: "directions_car"
				}
			}
		}
	}
}
