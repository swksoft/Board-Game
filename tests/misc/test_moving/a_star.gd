class_name A_Star extends Node

func find_shortest_path(start: Vector2i, goal: Vector2i, available_tiles: Array) -> Array:
	var open_set = [start]
	var came_from = {}
	var g_score = {}
	var f_score = {}
	
	for tile in available_tiles:
		g_score[tile] = INF
		f_score[tile] = INF
	
	g_score[start] = 0
	f_score[start] = heuristic_cost_estimate(start, goal)
	
	while open_set.size() > 0:
		open_set.sort_custom(func(a, b): return f_score[a] < f_score[b])
		var current = open_set.pop_front()
		
		if current == goal:
			return reconstruct_path(came_from, current)
		
		for neighbor in get_neighbors(current, available_tiles):
			var tentative_g_score = g_score[current] + 1
			
			if tentative_g_score < g_score[neighbor]:
				came_from[neighbor] = current
				g_score[neighbor] = tentative_g_score
				f_score[neighbor] = g_score[neighbor] + heuristic_cost_estimate(neighbor, goal)
				
				if not open_set.has(neighbor):
					open_set.append(neighbor)
	
	return [] # Retorna una lista vacía si no hay camino

func heuristic_cost_estimate(start: Vector2i, goal: Vector2i) -> float:
	var vector2_start = Vector2(start.x, start.y)
	var vector2_goal = Vector2(goal.x, goal.y)
	var distance = vector2_start.distance_to(vector2_goal)
	return distance

func reconstruct_path(came_from: Dictionary, current: Vector2i) -> Array:
	var total_path = [current]
	while current in came_from:
		current = came_from[current]
		total_path.push_front(current)
	return total_path

func get_neighbors(tile: Vector2i, available_tiles) -> Array:
	var neighbors = [
		tile + Vector2i(1, 0),
		tile + Vector2i(-1, 0),
		tile + Vector2i(0, 1),
		tile + Vector2i(0, -1)
	]
	
	# Filtrar los vecinos que están dentro de available_tiles
	return neighbors.filter(func(n):
		return n in available_tiles
	)
