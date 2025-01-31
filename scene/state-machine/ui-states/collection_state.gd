class_name UiCollectionState
extends BaseState



@export var collection: Collection
@export var search_state: UiSearchState


func enter() -> void:
	super.enter()
	AppData.footer.footer_changed.connect(_on_footer_changed)
	collection.load_collection()


func exit() -> void:
	super.exit()
	AppData.footer.footer_changed.disconnect(_on_footer_changed)


func _on_footer_changed(type: Enums.Page) -> void:
	AppData.footer.do_selection(type)
	match type:
		Enums.Page.SEARCH:
			state_change_requested.emit(search_state)
			Signals.page_changed.emit(Enums.Page.SEARCH)
