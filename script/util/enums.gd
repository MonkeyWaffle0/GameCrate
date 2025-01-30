class_name Enums
extends Node


enum Page { SEARCH, COLLECTION, FRIENDS, SESSIONS }


static func page_to_string(page: Page) -> String:
	match page:
		Page.SEARCH: return "Search"
		Page.COLLECTION: return "Collection"
		Page.FRIENDS: return "Friends"
		Page.SESSIONS: return "Sessions"
	return ""
