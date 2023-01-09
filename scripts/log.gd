extends Node

func l(data, level="[color=green]INFO[/color]"):
	print_rich("[%s][%s] %s" % [level, Time.get_time_string_from_system(), data])

func err(err, con: bool = false):
	if con:
		return
	print_rich("[[color=red]ERROR[/color]][%s] %s" % [Time.get_time_string_from_system(), err])
	
