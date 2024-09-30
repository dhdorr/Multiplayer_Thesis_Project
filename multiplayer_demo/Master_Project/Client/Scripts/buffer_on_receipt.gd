class_name Buffer_On_Receipt extends Node

class Buffer_Listener extends Node:
	# Always gets written to by the Connection Manager
	# then consumed by the player
	var buffer : Array[Vector2]
	var first_packet_received := false
	# delay in number of frames
	var delay := 0
	var count := 0


	func _process(delta: float) -> void:
		if !first_packet_received and buffer.size() > 0:
			first_packet_received = true
			print("buffer on receipt has started")
			

	func _physics_process(delta: float) -> void:
		if first_packet_received:
			if count >= delay:
				# Delay packets sent from the server for x fames
				Buffer_Consumer.buffer.append(buffer.pop_front())
				#Buffer_Consumer.buffer.append_array(buffer.duplicate())
				#buffer.clear()
				count = 0
			else:
				count += 1


class Buffer_Consumer extends Node:
	# Client-facing interface for Buffer On Receipt
	static var buffer : Array[Vector2]
