class_name UiSearchState
extends BaseState


@export var search: Search
@export var collection_state: UiCollectionState
@export var footer: Footer


func enter() -> void:
	footer.do_selection(Enums.Page.SEARCH)
	footer.footer_changed.connect(_on_footer_changed)
	search.show()


func exit() -> void:
	footer.footer_changed.disconnect(_on_footer_changed)
	search.hide()


func _on_footer_changed(type: Enums.Page) -> void:
	footer.do_selection(type)
	match type:
		Enums.Page.COLLECTION:
			state_change_requested.emit(collection_state)
			Signals.page_changed.emit(Enums.Page.COLLECTION)
