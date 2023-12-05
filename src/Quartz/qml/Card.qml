import QtQuick.Controls
import QtQuick.Controls.Material

Pane {
	padding: 0
	Material.elevation: 6
	Material.background: Material.theme == Material.Dark ? Material.color(Material.BlueGrey, Material.Shade900) : Material.white
}
