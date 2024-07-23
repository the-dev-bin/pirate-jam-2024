class_name EnemyActionEntry
extends Resource

enum INTENT {ATTACK, DEFEND, DEBUFF, SUPPORT}

@export var likelihood: int
@export var id: String
@export var followup: String
@export var scene: PackedScene
@export var params: Dictionary
@export var intent: INTENT