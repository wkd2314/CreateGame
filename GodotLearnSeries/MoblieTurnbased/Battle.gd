extends Node

onready var enemy = $Enemy

# signal up <> call down
func _on_SwordButton_pressed():
	enemy.hp -= 4
