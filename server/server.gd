extends Node2D
var peer = ENetMultiplayerPeer.new()
var address = "127.0.0.1"
var port: int = 9999
var connected_peers = []
var is_server = false
func _ready():
	for arg in OS.get_cmdline_args():
		if arg == "--server":
			is_server = true
			print("SERVER")
	if is_server:
		server()
	else:
		client()
	
		
func server():
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	
	add_player(multiplayer.get_unique_id())
	
	peer.peer_connected.connect(
		func(new_peer_id):
			await get_tree().create_timer(1).timeout
			rpc("add_newly_connected_player_character", new_peer_id)
			rpc_id(new_peer_id, "add_previously_connected_player_characters", connected_peers)
			add_player(new_peer_id)
	)
	
func client():
	peer.create_client(address, port)
	multiplayer.multiplayer_peer = peer

func add_player(peer_id):
	connected_peers.append(peer_id)
	var player_character = preload("res://scenes/player.tscn").instantiate()
	player_character.set_multiplayer_authority(peer_id)
	add_child(player_character)
	
@rpc	
func add_newly_connected_player_character(new_peer_id):
	add_player(new_peer_id)
	
@rpc
func add_previously_connected_player_characters(peer_ids):
	for peer_id in peer_ids:
		add_player(peer_id)
