class_name RMQParserU16
extends RefCounted

static func forward(remaining_bytes:PackedByteArray, signal_data, on_error: Callable) -> RMQParseResult:
	var buffer := StreamPeerBuffer.new()
	buffer.big_endian = true
	buffer.data_array = remaining_bytes
	while buffer.get_available_bytes() < 2:
		await RMQParserUtils.wait_for_more_data(buffer, signal_data)
	return RMQParseResult.new(buffer.get_u16(), RMQParserUtils.get_remaining_bytes(buffer))