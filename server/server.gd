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
	print("Running server: ip: %s , port: %d" % [address, port])
	peer.create_server(port)
	multiplayer.set_multiplayer_peer(peer)
	peer.peer_connected.connect(add_player)
	peer.peer_disconnected.connect(remove_player)
	
func client():
	print("Running client: ip: %s , port: %d" % [address, port])
	peer.create_client(address, port)
	multiplayer.set_multiplayer_peer(peer)

func add_player(peer_id):
	print("add player: peer_id: %d" % peer_id)
	connected_peers.append(peer_id)
	var player_character = preload("res://scenes/player.tscn").instantiate()
	player_character.set_multiplayer_authority(peer_id)
	player_character.name = str(peer_id)
	$players.add_child(player_character)

@rpc
func remove_player(peer_id):
	print("destroy player: peer_id: %d" % peer_id)
	connected_peers.erase(peer_id)
	$players.get_node(str(peer_id)).queue_free()
