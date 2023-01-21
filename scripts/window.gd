extends Window
class_name BaseWindow

func _on_close_requested():
	queue_free() 
