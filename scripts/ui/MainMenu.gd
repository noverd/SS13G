extends Control


func _ready():
	TranslationServer.set_locale("ru")


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/test.tscn")
