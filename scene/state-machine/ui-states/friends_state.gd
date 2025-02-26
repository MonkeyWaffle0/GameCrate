class_name UiFriendsState
extends BaseState


@export var friends: Friends
@export var search_state: UiSearchState
@export var collection_state: UiCollectionState
@export var add_friends_state: UiAddFriendsState


func enter() -> void:
	super.enter()
	AppData.footer.footer_changed.connect(_on_footer_changed)
	friends.add_friends_pressed.connect(_on_add_friends)


func exit() -> void:
	super.exit()
	AppData.footer.footer_changed.disconnect(_on_footer_changed)
	friends.add_friends_pressed.disconnect(_on_add_friends)


func _on_add_friends() -> void:
	state_change_requested.emit(add_friends_state)


func _on_footer_changed(type: Enums.Page) -> void:
	AppData.footer.do_selection(type)
	match type:
		Enums.Page.COLLECTION:
			state_change_requested.emit(collection_state)
			Signals.page_changed.emit(Enums.Page.COLLECTION)
		Enums.Page.SEARCH:
			state_change_requested.emit(search_state)
			Signals.page_changed.emit(Enums.Page.SEARCH)
