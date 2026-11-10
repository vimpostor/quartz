import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

SearchField {
	id: searchfield
	signal searched()
	height: 56
	font.pointSize: 16
	onSearchTriggered: searched();
	onSearchButtonPressed: searched();
	background: Rectangle {
		implicitHeight: searchfield.height
		radius: 16
		color: Material.color(Material.Grey, Material.theme == Material.Light ? Material.Shade100 : Material.Shade800)
		layer.enabled: true
		layer.effect: RoundedElevationEffect {
			elevation: 3
		}
	}
}
