extends Node2D
@onready var tile_map = $TileMap
var tile_data = [] # Array to store tile coordinates
var choosing_tiles = []

func randomize_list() -> Array:
	choosing_tiles = [1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 16, 17, 22, 24, 27, 28, 30, 31, 32, 33, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44]
	var i = choosing_tiles.size()
	var j = 0
	var temp = 0
	
	while i > 1:
		j = randi_range(1, i)
		temp = choosing_tiles[i-1] # Arrays are 0-based in GDScript
		choosing_tiles[i-1] = choosing_tiles[j-1]
		choosing_tiles[j-1] = temp
		i = i - 1
		
	return choosing_tiles


func create_world(world_size: int):
	var grid_size = world_size
	var half_size = grid_size / 2
	for x in range(-half_size, half_size):
		for y in range(-half_size, half_size):
			var file_atlas_to_index = FileAccess.open("res://Data/atlas_to_index.txt", FileAccess.READ)
			var lines = file_atlas_to_index.get_as_text().split("\n")
			randomize_list()
			var atlas_coord_str = lines[(choosing_tiles[0]) - 1]
			
			# Parse the string coordinates into Vector2i
			var coords = atlas_coord_str.split(",") # Assuming the format is "x,y"
			var atlas_coords = Vector2i(int(coords[0]), int(coords[1]))
			
			tile_data.append({
				"position": Vector2i(x, y),
				"atlas_coords": atlas_coords
			})
	var chosen_pos = Vector2i(0, 0) # Example position to check
	for tile in tile_data:
		if tile["position"] == chosen_pos:
			print(tile["atlas_coords"])
			break

func load_world(load_x: int, load_y: int):
	var half_x = load_x / 2
	var half_y = load_y / 2
	
	for tile in tile_data:
		var pos = tile["position"]
		# Only load tiles within the specified load range
		if pos.x >= -half_x and pos.x < half_x and pos.y >= -half_y and pos.y < half_y:
			tile_map.set_cell(0, pos, 1, tile["atlas_coords"])

func _ready():
	var file_constraints = FileAccess.open("res://Data/tile_neighbor_output.txt", FileAccess.READ)
	if file_constraints == null:
		print("Error: Could not open file")
		return
	
	# Read all lines into array
	var lines = file_constraints.get_as_text().split("\n")
	print(lines[64 - 1])
	file_constraints.close()
	
	# Create 100x100 grid of tiles centered at 0,0
	create_world(100)
	load_world(100, 100)
	

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_T:
		tile_map.clear()
		print("clear")
		load_world(20, 10)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


