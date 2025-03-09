class_name UrlTextureRect
extends TextureRect


const IMAGE_BROKEN = preload("res://asset/icon/image-broken.svg")

@onready var loading_spinner: LoadingSpinner = %LoadingSpinner
@onready var error_texture: TextureRect = %ErrorTexture

var img_type: String


func _ready() -> void:
	error_texture.hide()
	loading_spinner.show()


func load_image(url: String) -> void:
	var http_request = HTTPRequest.new()
	add_child(http_request)

	http_request.request_completed.connect(_on_request_completed)
	img_type = url.substr(url.length() - 3, 3)
	http_request.request(url)



func _on_request_completed(_result, response_code: int, _headers, body: PackedByteArray) -> void:
	loading_spinner.hide()
	if response_code != 200:
		print("error " + str(response_code))
		error_texture.show()
		return

	var image := Image.new()
	var err
	if img_type == "jpg":
		err = image.load_jpg_from_buffer(body)
	elif img_type == "png":
		err = image.load_png_from_buffer(body)
	else:
		print("Unrecognized image type.")
		error_texture.show()
	if err == OK:
		texture = ImageTexture.create_from_image(image)
	else:
		error_texture.show()
		print("Error loading image from buffer: ", err)
