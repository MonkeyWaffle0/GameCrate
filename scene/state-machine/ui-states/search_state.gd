class_name UiSearchState
extends BaseState


@export var collection_state: UiCollectionState


func enter() -> void:
	super.enter()
	AppData.footer.do_selection(Enums.Page.SEARCH)
	AppData.footer.footer_changed.connect(_on_footer_changed)


func exit() -> void:
	super.exit()
	AppData.footer.footer_changed.disconnect(_on_footer_changed)


func _on_footer_changed(type: Enums.Page) -> void:
	AppData.footer.do_selection(type)
	match type:
		Enums.Page.COLLECTION:
			state_change_requested.emit(collection_state)
			Signals.page_changed.emit(Enums.Page.COLLECTION)
