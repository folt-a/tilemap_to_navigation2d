#-----------------------------------------------------------
#01. tool
#-----------------------------------------------------------
@tool
#-----------------------------------------------------------
#02. class_name
#-----------------------------------------------------------
#-----------------------------------------------------------
#03. extends
#-----------------------------------------------------------
extends EditorInspectorPlugin


#-----------------------------------------------------------
#04. # docstring
## hoge
#-----------------------------------------------------------
#-----------------------------------------------------------
#05. signals
#-----------------------------------------------------------
#-----------------------------------------------------------
#06. enums
#-----------------------------------------------------------
#-----------------------------------------------------------
#07. constants
#-----------------------------------------------------------
#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------
#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------
var is_tilemap:bool = false
var tilemap:TileMap

var TileMapInspector = load("res://addons/tilemap_to_navigation2d/tile_map_inspector.gd")


#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------
#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------
#-----------------------------------------------------------
#12. optional built-in virtual _init method
#-----------------------------------------------------------
#-----------------------------------------------------------
#13. built-in virtual _ready method
#-----------------------------------------------------------
#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------
func _can_handle(object):
	if object is TileMap:
		tilemap = object
		return true
	return false

func _parse_end(onject):
	add_custom_control(TileMapInspector.new(tilemap))


#-----------------------------------------------------------
#15. public methods
#-----------------------------------------------------------

#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------
