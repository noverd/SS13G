extends Node

func l(data, level="INFO"):
	print("[%s][%s] %s" % [level, Time.get_time_string_from_system(), data])

func err(err, con: bool = false):
	assert(con, err)
	
