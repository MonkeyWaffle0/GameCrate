class_name UiCollectionState
extends BaseState



@export var collection: Collection
@export var search_state: UiSearchState
@export var friends_state: UiFriendsState
@export var sessions_state: UiSessionsState


func enter() -> void:
	AppData.footer.footer_changed.connect(_on_footer_changed)
	collection.load_collection()


func exit() -> void:
	AppData.footer.footer_changed.disconnect(_on_footer_changed)


func _on_footer_changed(type: Enums.Page) -> void:
	AppData.footer.do_selection(type)
	match type:
		Enums.Page.SEARCH:
			state_change_requested.emit(search_state)
			Signals.page_changed.emit(Enums.Page.SEARCH)
		Enums.Page.FRIENDS:
			state_change_requested.emit(friends_state)
			Signals.page_changed.emit(Enums.Page.FRIENDS)
		Enums.Page.SESSIONS:
			state_change_requested.emit(sessions_state)
			Signals.page_changed.emit(Enums.Page.SESSIONS)
