extends Node2D
var peer = ENetMultiplayerPeer.new()
var address = "127.0.0.1"
var port: int = 9999
var connected_peers: Array = []
var is_server = false

func _ready():
	for arg in OS.get_cmdline_args():
		if arg == "--server":
			is_server = true
		elif arg == "--client":
			is_server = false
	if is_server:
		server()
	else:
		client()

func server():
	Log.l("Running server: ip: %s , port: %d" % [address, port])
	peer.create_server(port)
	multiplayer.set_multiplayer_peer(peer)
	peer.peer_connected.connect(func(peer_id): Log.l("player %d join to lobby" % peer_id); connected_peers.append(peer_id))
	peer.peer_disconnected.connect(remove_player)
	
func client():
	Log.l("Try to connect server at: ip: %s , port: %d" % [address, port])
	peer.create_client(address, port)
	multiplayer.set_multiplayer_peer(peer)
	multiplayer.connection_failed.connect(
		func(): Log.err("Client: failed connect to server")
		)
	multiplayer.connected_to_server.connect(func(): Log.l("Client: join to lobby"))
	multiplayer.server_disconnected.connect(server_disconnected)

func server_disconnected(): # Prototype
	pass

@rpc(any_peer)
func add_player(player_data):
	var rpc_sender = multiplayer.get_remote_sender_id()
	Log.l("add player: peer_id: %d" % rpc_sender)
	var player_character = preload("res://scenes/player.tscn").instantiate()
	player_character.set_multiplayer_authority(rpc_sender)
	player_character.name = str(rpc_sender)
	for key in player_data.keys():
		player_character.set(key, player_data[key])
	$players.add_child(player_character, true)

@rpc
func remove_player(peer_id):
	Log.l("destroy player: peer_id: %d" % peer_id)
	connected_peers.erase(peer_id)
	$players.get_node(str(peer_id)).queue_free()


func _on_gay_pressed():
	rpc_id(1, "add_player", {"uniform": "orange_uniform"})


func _on_button_pressed():
	rpc_id(1, "add_player", {"uniform": "black_uniform"})
