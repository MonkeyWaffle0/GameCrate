class_name UUID
extends Node


static func random_uuid() -> String:
	var uuid = PackedByteArray()
	for i in 32:
		uuid.append(randi() % 256) 

	var hex_string = ""
	for byte in uuid:
		hex_string += "%02x" % byte

	return "%s-%s-%s-%s-%s" % [
		hex_string.substr(0, 8),
		hex_string.substr(8, 4),
		hex_string.substr(12, 4),
		hex_string.substr(16, 4),
		hex_string.substr(20, 12)
	]
