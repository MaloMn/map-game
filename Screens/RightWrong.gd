extends Control

onready var switcher = $"/root/SceneSwitcher"


func _ready() -> void:
	pass


func init(param):
	var anim = $AnimationPlayer
	
	var capital = param[0]
	var country = param[1]
	var answer = param[2]
	
	var agreen = Color(0,1,0,0.5)
	var green = Color(0,1,0,1)
	
	if country == answer:
		get_node("Overlay").color = agreen

		get_node('Capital').text = capital

		var c = get_node("Country")
		c.text = country
		c.add_color_override("font_color", green)

		var a = get_node("additional")
		a.text = "Well done!"
		a.add_color_override("font_color", green)
	
		anim.play("wrong_to_right")
		yield(anim, "animation_finished")
		switcher.next_level()
	else:
		get_node('Capital').text = capital
		get_node("Country").text = answer
		get_node("RealCountry").text = country
		
		anim.play("wrong_to_right")
		yield(anim, "animation_finished")
		switcher.next_level()
