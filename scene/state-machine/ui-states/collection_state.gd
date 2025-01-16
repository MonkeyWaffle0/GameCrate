class_name UiCollectionState
extends BaseState



@export var collection: Collection
@export var search_state: UiSearchState
@export var footer: Footer


func enter() -> void:
	footer.footer_changed.connect(_on_footer_changed)
	collection.show()
	collection.load_collection()


func exit() -> void:
	footer.footer_changed.disconnect(_on_footer_changed)
	collection.hide()


func _on_footer_changed(type: Footer.TabType) -> void:
	footer.do_selection(type)
	match type:
		Footer.TabType.SEARCH:
			state_change_requested.emit(search_state)
