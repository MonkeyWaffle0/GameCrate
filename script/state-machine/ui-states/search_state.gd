class_name UiSearchState
extends BaseState


@export var collection_state: UiCollectionState
@export var friends_state: UiFriendsState
@export var sessions_state: UiSessionsState


func enter() -> void:
	AppData.footer.do_selection(Enums.Page.SEARCH)
	AppData.footer.footer_changed.connect(_on_footer_changed)


func exit() -> void:
	AppData.footer.footer_changed.disconnect(_on_footer_changed)


func _on_footer_changed(type: Enums.Page) -> void:
	AppData.footer.do_selection(type)
	match type:
		Enums.Page.COLLECTION:
			state_change_requested.emit(collection_state)
			Signals.page_changed.emit(Enums.Page.COLLECTION)
		Enums.Page.FRIENDS:
			state_change_requested.emit(friends_state)
			Signals.page_changed.emit(Enums.Page.FRIENDS)
		Enums.Page.SESSIONS:
			state_change_requested.emit(sessions_state)
			Signals.page_changed.emit(Enums.Page.SESSIONS)
