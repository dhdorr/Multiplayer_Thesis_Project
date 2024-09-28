extends Node

var network_latency := 50.0

@onready var e_server := UDPServer.new()

var peers : Array[PacketPeerUDP]

func _ready() -> void:
	start_server()


func start_server() -> void:
	e_server.listen(12345)


func check_for_new_client_connections() -> void:
	e_server.poll()
	if e_server.is_connection_available():
		print("here?")
		var peer : PacketPeerUDP = e_server.take_connection()
		var packet := peer.get_packet()
		print("Accepted peer: %s:%s" % [peer.get_packet_ip(), peer.get_packet_port()])
		print("Received data: %s" % [packet.get_string_from_utf8()])
		
		var response : PackedByteArray = "welcome!".to_utf8_buffer()
		peer.put_packet(response)
		peers.append(peer)


func _process(delta: float) -> void:
	check_for_new_client_connections()
	
	for p in peers:
		#print(p)
		if p.get_available_packet_count() > 0:
			p.put_packet("help me!".to_utf8_buffer())
			print("HELP PLEASE: %s" % p.get_packet().get_string_from_utf8())
