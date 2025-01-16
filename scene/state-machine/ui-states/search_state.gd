class_name UiSearchState
extends BaseState


@export var search: Search
@export var collection_state: UiCollectionState
@export var footer: Footer


func enter() -> void:
	footer.footer_changed.connect(_on_footer_changed)
	search.show()


func exit() -> void:
	footer.footer_changed.disconnect(_on_footer_changed)
	search.hide()


func _on_footer_changed(type: Footer.TabType) -> void:
	footer.do_selection(type)
	match type:
		Footer.TabType.COLLECTION:
			state_change_requested.emit(collection_state)
