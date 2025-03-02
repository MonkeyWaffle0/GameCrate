class_name UiSesstionDetailsState
extends BaseState


func enter() -> void:
	super.enter()
	SessionService.listen_to_session(AppData.current_session.session_id)


func exit() -> void:
	super.exit()
