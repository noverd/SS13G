extends Control

@rpc
func send_message(mes: String):
	$Panel/Content.text += "\n" + mes

func _on_input_text_submitted(mes):
	$Panel/Content.text += "\n" + mes
	$Panel/Input.release_focus()
	rpc("send_message", mes)
