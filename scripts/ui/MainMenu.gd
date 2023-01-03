extends Control


func _ready():
	TranslationServer.set_locale("ru")
	for i in OS.get_cmdline_args():
		if i == "--server":
			get_tree().change_scene_to_file("res://scenes/test.tscn")


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/test.tscn")
