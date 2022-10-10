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
extends VBoxContainer

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
const OPTION_TILEMAP_THIS = 0
const OPTION_TILEMAP_ALL = 1

const OPTION_TILE_ALLTILE = 0
const OPTION_TILE_COLLISION = 1

const OPTION_OVERRIDE_NAV = 0
const OPTION_NEW_CREATE_NAV = 1
#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------
#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------
var group_label:Label = Label.new()
var button_this_tile_only:Button = Button.new()
var option_button_all:OptionButton = OptionButton.new()
var option_button_coli:OptionButton = OptionButton.new()
var option_button_nav_node:OptionButton = OptionButton.new()
var gap_h_con:HBoxContainer = HBoxContainer.new()
var gap_label:Label = Label.new()
var gap_edit:SpinBox = SpinBox.new()

var updating:bool = false
var _map:TileMap
var _scene_root:Node

#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------
#-----------------------------------------------------------
#12. optional built-in virtual _init method
#-----------------------------------------------------------
func _init(tilemap:TileMap):
	_map = tilemap


	alignment = BoxContainer.ALIGNMENT_CENTER
	size_flags_horizontal = SIZE_EXPAND_FILL

	add_child(group_label)
	group_label.size_flags_horizontal = SIZE_EXPAND_FILL
	group_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	group_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color( 0.27451, 0.27451, 0.27451,1)
	group_label.add_theme_stylebox_override("normal",stylebox)

	add_child(option_button_all)
	option_button_all.item_selected.connect(_gui_changed)

	add_child(option_button_coli)
	option_button_coli.item_selected.connect(_gui_changed)

	add_child(option_button_nav_node)
	option_button_nav_node.item_selected.connect(_gui_changed)

	add_child(gap_h_con)
	gap_h_con.add_child(gap_label)
#	gap_label.rect_min_size = Vector2(32,28)
	gap_label.size_flags_stretch_ratio = .5
	gap_label.size_flags_horizontal = SIZE_EXPAND_FILL
	gap_h_con.add_child(gap_edit)
	gap_edit.value_changed.connect(_gui_changed)
#	gap_edit.rect_min_size = Vector2(96,28)
	gap_edit.get_line_edit().text = "1"
	gap_edit.min_value = 1.0
	gap_edit.size_flags_stretch_ratio = .5
	gap_edit.size_flags_horizontal = SIZE_EXPAND_FILL

	add_child(button_this_tile_only)
#	button_this_tile_only.rect_min_size = Vector2(0,32)
	button_this_tile_only
	button_this_tile_only.size_flags_horizontal = SIZE_EXPAND_FILL
	button_this_tile_only.modulate = Color.LIGHT_GREEN
	button_this_tile_only.pressed.connect(_on_this_only_button_pressed)

	var lang = OS.get_locale_language()
	if lang == 'ja':
		group_label.text = "TileMap から Navigation2D 作成"
		option_button_all.add_item("このTileMapのみ",OPTION_TILEMAP_THIS)
		option_button_all.add_item("シーン上すべてのTileMap",OPTION_TILEMAP_ALL)
		option_button_coli.add_item("どんなタイルでもあれば穴にする",OPTION_TILE_ALLTILE)
		option_button_coli.add_item("コリジョンタイルのみ穴にする",OPTION_TILE_COLLISION)
		option_button_nav_node.add_item("Navigation2Dを上書き、なければ新規作成",OPTION_OVERRIDE_NAV)
		option_button_nav_node.add_item("Navigation2Dを新規作成",OPTION_NEW_CREATE_NAV)
		button_this_tile_only.text = "[Navigation2D作成] 実行"
		gap_label.text = "gap pixel"
	else:
		group_label.text = "TileMap To Navigation2D"
		option_button_all.add_item("Selected TileMap Only.",OPTION_TILEMAP_THIS)
		option_button_all.add_item("All TileMap at this Scene.",OPTION_TILEMAP_ALL)
		option_button_coli.add_item("All Tile.",OPTION_TILE_ALLTILE)
		option_button_coli.add_item("Collision Tile.",OPTION_TILE_COLLISION)
		option_button_nav_node.add_item("Override Navigation2D Node or Create new",OPTION_OVERRIDE_NAV)
		option_button_nav_node.add_item("Create new Navigation2D Node",OPTION_NEW_CREATE_NAV)
		button_this_tile_only.text = "[Create Navigation2D] Execute"
		gap_label.text = "gap pixel"

#	保持データ復元
	if FileAccess.file_exists("user://tile_map_inspector.dat"):
		var fl = FileAccess.open("user://tile_map_inspector.dat", FileAccess.READ)
		var json = JSON.new()
		json.parse(fl.get_line())
		var data = json.get_data()
		if data and data.has("option_button_all"):
			option_button_all.select(data.option_button_all)
		if data and data.has("option_button_coli"):
			option_button_coli.select(data.option_button_coli)
		if data and data.has("gap_edit"):
			gap_edit.get_line_edit().text = data.gap_edit
			gap_edit.apply()
		if data and data.has("option_button_nav_node"):
			option_button_nav_node.select(data.option_button_nav_node)
#-----------------------------------------------------------
#13. built-in virtual _ready method
#-----------------------------------------------------------
#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------

#-----------------------------------------------------------
#15. public methods
#-----------------------------------------------------------

#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------

func _gui_changed(event):
	var fl = FileAccess.open("user://tile_map_inspector.dat",FileAccess.WRITE)
	var data = {
		option_button_all = option_button_all.selected,
		option_button_coli = option_button_coli.selected,
		option_button_nav_node = option_button_nav_node.selected,
		gap_edit = gap_edit.get_line_edit().text
	}
	fl.store_line(JSON.stringify(data))


func _on_this_only_button_pressed():
	if (updating):
		return
	updating = true
	make_outline_collision_hole()
	updating = false

func make_outline_collision_hole() -> void:
	var maps = []
	if option_button_all.selected == OPTION_TILEMAP_ALL:
		var root_node = _map.get_tree().get_root()
		var all_nodes = []
		maps = _get_all_node(root_node, all_nodes)
	else:
		maps.append(_map)
	var navPolyInstance = NavigationRegion2D.new()
	navPolyInstance.name = "NavigationRegion2D"
	navPolyInstance.navpoly = NavigationPolygon.new()

	var navpoly = navPolyInstance.navpoly
	navpoly.clear_outlines()
	navpoly.clear_polygons()

	# 全体のサイズを取得して全面ポリゴンを作る
	var right_x = 0
	var bottom_y = 0
	var left_x = 0
	var top_y = 0

	for map_v in maps:
		if !(map_v is TileMap):
			continue
		var map:TileMap = map_v
		var map_rect:Rect2 = map.get_used_rect()
		var right_bottom = Vector2i(map_rect.position + map_rect.size) * map.tile_set.tile_size
		var top_left = map_rect.position * Vector2(map.tile_set.tile_size)
		print("Cell Pos[",map.name,"] ",map_rect.position)
		print("Cell Size[",map.name,"] ",map_rect.size)
#		print("Real Size[",map.name,"] ",Vector2(width,height))
		# 最終的なRectは包括にしたいので一番大きかったらサイズ更新する
		if right_bottom.x > right_x:
			right_x = right_bottom.x
		if right_bottom.y > bottom_y:
			bottom_y = right_bottom.y
		if top_left.x < left_x:
			left_x = top_left.x
		if top_left.y < top_y:
			top_y = top_left.y

	# タイル全面ポリゴンを作成
	var gap_pixel = gap_edit.get_line_edit().text.to_int()

	var navpoly_pgon = PackedVector2Array()
	navpoly_pgon.append(Vector2(left_x - gap_pixel - 1,top_y - gap_pixel - 1))
	navpoly_pgon.append(Vector2(right_x + gap_pixel + 1, top_y - gap_pixel - 1))
	navpoly_pgon.append(Vector2(right_x + gap_pixel + 1,bottom_y + gap_pixel + 1))
	navpoly_pgon.append(Vector2(left_x - gap_pixel - 1,bottom_y + gap_pixel + 1))

#	navpoly.add_outline(navpoly_pgon)
#	navpoly.make_polygons_from_outlines()

	var pgon_array:Array[PackedVector2Array] = []
	var overlap_check_cell_array = {}

	for map_v in maps:
		if !(map_v is TileMap):
			continue
		var map:TileMap = map_v
		var tileset:TileSet = map.tile_set

		for layer_index in map.get_layers_count():
			var cells = map.get_used_cells(layer_index)
			for cell in cells:
				var tile_data:TileData = map.get_cell_tile_data(layer_index,cell,false)
				# コリジョンだけ対象ならコリジョン以外は無視
				if option_button_coli.selected == OPTION_TILE_COLLISION\
				and tile_data.get_collision_polygons_count(0) == 0:
					continue

#				var cell_real_size:Vector2 = cell * map.tile_set.tile_size
				var cell_real_coords:Vector2i = cell * map.tile_set.tile_size
				var cell_atlas_coords = map.get_cell_atlas_coords(layer_index, cell, false)
				var source_id = map.get_cell_source_id(layer_index,cell,false)
				var tilesetsrc_v = tileset.get_source(source_id)
				if !(tilesetsrc_v is TileSetAtlasSource):
					continue
				var tilesetsrc:TileSetAtlasSource = tilesetsrc_v
				var cell_size = tilesetsrc.get_tile_size_in_atlas(cell_atlas_coords)
				var cell_size_real = cell_size * map.tile_set.tile_size
				# 0.5 1 1.5 2
				# 2   3   4 5
#				print("a",cell_real_coords,cell_size_real)
				if cell_size.x != 1 or cell_size.y != 1:
					var x_center_offset:int = ((cell_size.x - 1.0) / 2.0) * map.tile_set.tile_size.x
					var y_center_offset:int = ((cell_size.y - 1.0) / 2.0) * map.tile_set.tile_size.y
#					print(cell_size.x)
#					print(x_center_offset)
#					print(tile_data.texture_offset.y)
					cell_real_coords.x = cell_real_coords.x - x_center_offset - tile_data.texture_offset.x
					cell_real_coords.y = cell_real_coords.y - y_center_offset - tile_data.texture_offset.y
#					print(cell_real_coords)
					pass
#				print("b",cell_real_coords,cell_size_real)

#				print(cell_size_real)
#				print(tile_data.texture_offset)
				var vertices = [Vector2i(0,0),Vector2i(cell_size_real.x,0),Vector2i(cell_size_real.x,cell_size_real.y),Vector2i(0,cell_size_real.y)]
				var one_pixel_vec2 = [Vector2i(-gap_pixel,-gap_pixel),Vector2i(gap_pixel,-gap_pixel),Vector2i(gap_pixel,gap_pixel),Vector2i(-gap_pixel,gap_pixel)]
				var new_poly:PackedVector2Array = []
				for ver_index in range(0,4):
					#角同士の接するものを隙間なくしたいので1ピクセル大きくとる
					new_poly.append(cell_real_coords + vertices[ver_index] + one_pixel_vec2[ver_index])

				# すでに同セルが入っている場合は無視
				if !overlap_check_cell_array.has(var_to_str(cell_real_coords)):
					pgon_array.append(new_poly)
					overlap_check_cell_array[var_to_str(cell_real_coords)] = cell_real_coords

	# ソートする
	# 左上→右上→次の行　のように並び替え
#	pgon_array.sort_custom(self,"_customComparison")

	var cell_counts = pgon_array.size()
	var indivisual_poligon_counts = 0
	var merge_counts = 0

	var polygon_islands:Array[PackedVector2Array] = [navpoly_pgon]
	var polygon_holes = []

	var merged_polygons:Array = []

	for pol_v in pgon_array:
		var pol:PackedVector2Array = pol_v
		polygon_islands = ClipperSingleton.clip_polygons(polygon_islands,[pol]) #TODO

	var simply_islands = []
	for pool_vec2_array in polygon_islands:
		var vec2array = PackedVector2Array([])
		var index:int = 0
		var remove_indexs = {}
		pool_vec2_array.append(pool_vec2_array[0])
		pool_vec2_array.reverse()
		pool_vec2_array.append(pool_vec2_array[1])
		pool_vec2_array.reverse()
		for vec_1 in pool_vec2_array:
			var vec_2:Vector2 = pool_vec2_array[index + 1]
			var vec_3:Vector2 = pool_vec2_array[index + 2]
			var angle_rad_1_to_2 = vec_1.angle_to_point(vec_2)
			var angle_rad_2_to_3 = vec_2.angle_to_point(vec_3)
			var angle_1_to_2:int = convert(rad_to_deg(angle_rad_1_to_2),TYPE_INT)
			var angle_2_to_3:int = convert(rad_to_deg(angle_rad_2_to_3),TYPE_INT)

			if angle_1_to_2 == angle_2_to_3:
				remove_indexs[index + 1] = true
				print(vec_2)
				pass

			index += 1
			if index + 3 > pool_vec2_array.size():
				break
		remove_indexs[0] = true
		remove_indexs[pool_vec2_array.size() - 1] = true
		index = 0
		for vec2 in pool_vec2_array:
			if !remove_indexs.has(index):
				vec2array.append(vec2)
			pass
			index += 1
		simply_islands.append(vec2array)
		pass


	for pool_vec2_array in simply_islands:
		navpoly.add_outline(pool_vec2_array)
	navpoly.make_polygons_from_outlines()

	if option_button_nav_node.selected == OPTION_OVERRIDE_NAV:
		# すでにNavigation2DNodeがあればNavigationPolygonInstanceを削除して新しく追加する
		for node in _map.get_tree().edited_scene_root.get_children():
			if node is NavigationRegion2D:
#				for nav_child_index in range(0,node.get_child_count()):
#					# 一番上のだけ消す
#					if node.get_child(nav_child_index) is NavigationPolygonInstance:
#						node.remove_child(node.get_child(nav_child_index))
#						break
#					pass
				_map.get_tree().edited_scene_root.remove_child(node)
				_map.get_tree().edited_scene_root.add_child(navPolyInstance)
				navPolyInstance.set_meta("_edit_group_", true)
				navPolyInstance.set_meta("_edit_lock_", true)
				navPolyInstance.owner = _map.get_tree().edited_scene_root
				# おわり
				return

		# なかったら新規作成
		navPolyInstance.set_meta("_edit_group_", true)
		navPolyInstance.set_meta("_edit_lock_", true)
		_map.get_tree().edited_scene_root.add_child(navPolyInstance)
		navPolyInstance.owner = _map.get_tree().edited_scene_root
	else:
		# 「新規作成する」が選択されているので新規作成する
		navPolyInstance.set_meta("_edit_group_", true)
		navPolyInstance.set_meta("_edit_lock_", true)
		_map.get_tree().edited_scene_root.add_child(navPolyInstance)
		navPolyInstance.owner = _map.get_tree().edited_scene_root

func _get_all_node(node:Node, array:Array)-> Array:
	for n in node.get_children():
		array.append(n)
		array = _get_all_node(n, array)
	return array

# Sort用比較関数
func _customComparison(a:PackedVector2Array, b:PackedVector2Array):
	# 全部1マスタイルで形式が同じなので左上点のみで比較する
	var a_v:Vector2 = a[0]
	var b_v:Vector2 = b[0]

#	左上→右上→次の行　のように並び替え
#	yで昇順ソートし、yが同じならxで昇順ソート
	if a_v.y == b_v.y:
		return a_v.x < b_v.x
	return a_v.y < b_v.y

	return false
