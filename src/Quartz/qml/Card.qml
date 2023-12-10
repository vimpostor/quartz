import QtQuick.Controls
import QtQuick.Controls.Material

Pane {
	padding: 0
	Material.elevation: 6
	Material.background: Material.theme == Material.Dark ? Material.color(Material.Grey, Material.Shade800) : Material.white
}
