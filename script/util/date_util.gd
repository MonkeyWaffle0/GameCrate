class_name DateUtil
extends Node


static func prettify_date(date_str: String) -> String:
	# Split the input string by "-"
	var parts = date_str.split("-")
	if parts.size() != 3:
		return "Invalid date format"

	# Convert parts to integers
	var day = int(parts[0])
	var month = int(parts[1])
	var year = int(parts[2])

	# Store original month for display (month names are based on 1-12)
	var display_month = month

	# Adjust month and year for Zeller's Congruence:
	# For January and February, treat them as month 13 and 14 of the previous year.
	if month < 3:
		month += 12
		year -= 1

	# Zeller's Congruence variables:
	var q = day
	var K = year % 100
	var J = int(year / 100)

	# Compute the day of the week (h)
	# h = (q + int((13*(month+1))/5) + K + int(K/4) + int(J/4) + 5*J) % 7
	var h = (q + int((13 * (month + 1)) / 5) + K + int(K / 4) + int(J / 4) + 5 * J) % 7

	# Mapping from Zeller's output to weekday names:
	# h = 0 -> Saturday, 1 -> Sunday, 2 -> Monday, 3 -> Tuesday, 4 -> Wednesday, 5 -> Thursday, 6 -> Friday
	var weekday_names = ["Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
	var weekday = weekday_names[h]

	# Array of month names
	var month_names = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	var month_name = month_names[display_month - 1]

	# Return the formatted date (e.g., "Wednesday, March 5")
	return "%s, %s %d" % [weekday, month_name, day]


static func is_date_before_today(date_str: String) -> bool:
	# Split the date string into day, month, and year components
	var parts = date_str.split("-")
	if parts.size() != 3:
		push_error("Invalid date format. Expected DD-MM-YYYY")
		return false

	var input_day = int(parts[0])
	var input_month = int(parts[1])
	var input_year = int(parts[2])

	# Get the current date as a Dictionary with keys "year", "month", "day"
	var current_date = Time.get_datetime_dict_from_system()
	var current_year = current_date["year"]
	var current_month = current_date["month"]
	var current_day = current_date["day"]

	# Compare year, then month, then day
	if input_year < current_year:
		return true
	elif input_year == current_year:
		if input_month < current_month:
			return true
		elif input_month == current_month:
			if input_day < current_day:
				return true
	return false
