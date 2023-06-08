extends KinematicBody

export var speed = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	# display available interfaces (debug only: can be deleted later)
	var noInterfaces = ARVRServer.get_interface_count()
	var interfaces = ARVRServer.get_interfaces()
	for i in noInterfaces:
		print(interfaces[i])
	# find mobile interfaces
	var arvr_interface = ARVRServer.find_interface("Native mobile");
	# initialise the interface
	if (arvr_interface and arvr_interface.initialize()):
		get_viewport().arvr = true
		get_viewport().hdr = false
	
func _physics_process(_delta):
	if Player.move :
		locomove()
	
func locomove():
	# y-value of the Y-axis of the basis vector is needed to determine if VRPlayer looks down (or up)
	# specifically, the value decreases below 0 when the player looks down
	var y_value = ARVRServer.get_hmd_transform().basis.y.y
	# y-value of the Z-axis of the basis vector is needed to determine if VRPlayer looks down (or up)
	# specifically, if this value increases above 0.4 (with y_value below 1) then the player looks down (below level)
	# alternatively, if this value descreases below 0.4 (with y-value below 1) then the player looks upward (above level)
	var z_value = ARVRServer.get_hmd_transform().basis.z.y
	
	# determines the currently facing direction -- needed later for moving in that direction
	var direction = -Vector3(
		ARVRServer.get_hmd_transform().basis.z.x, 
		0, 
		ARVRServer.get_hmd_transform().basis.z.z)
		
	# check on angle and decide how to move (using direction vector above)
	if (y_value < 0.9 && z_value > 0.4):
		# VRPlayer is looking downward (below level)
		translate(direction * speed)
	elif (y_value < 0.9 && z_value < 0.4):
		# VRPlayer is looking upward (above level)
		translate(-direction * speed)
	else:
		# VRPlayer is neighter looking up or down
		pass
