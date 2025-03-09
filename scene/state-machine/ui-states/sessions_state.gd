class_name UiSessionsState
extends BaseState


@export var sessions: Sessions
@export var collection_state: UiCollectionState
@export var friends_state: UiFriendsState
@export var search_state: UiSearchState
@export var create_session_state: UiCreateSessionState
@export var session_details_state: UiSesstionDetailsState


func enter() -> void:
	super.enter()
	sessions.create_session_pressed.connect(_on_create_session)
	AppData.footer.footer_changed.connect(_on_footer_changed)
	sessions.session_selected.connect(_on_session_selected)


func exit() -> void:
	super.exit()
	sessions.create_session_pressed.disconnect(_on_create_session)
	AppData.footer.footer_changed.disconnect(_on_footer_changed)
	sessions.session_selected.disconnect(_on_session_selected)


func _on_create_session() -> void:
	state_change_requested.emit(create_session_state)


func _on_session_selected(session: Session) -> void:
	print("in state")
	AppData.current_session = session
	state_change_requested.emit(session_details_state)


func _on_footer_changed(type: Enums.Page) -> void:
	AppData.footer.do_selection(type)
	match type:
		Enums.Page.COLLECTION:
			state_change_requested.emit(collection_state)
			Signals.page_changed.emit(Enums.Page.COLLECTION)
		Enums.Page.SEARCH:
			state_change_requested.emit(search_state)
			Signals.page_changed.emit(Enums.Page.SEARCH)
		Enums.Page.FRIENDS:
			state_change_requested.emit(friends_state)
			Signals.page_changed.emit(Enums.Page.FRIENDS)
