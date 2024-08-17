extends HBoxContainer

@onready var score_label: Label = $Score

func set_score(score: int):
	visible = score > 0
	score_label.text = str(score)
