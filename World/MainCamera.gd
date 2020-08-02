extends Camera2D

onready var ScreenShakeTimer = $ScreenShakeTimer
var shake = 0

func _ready() -> void:
	ScreenShakeTimer.connect('timeout', self, 'stop_shaking')
	Events.connect('add_screen_shake', self, 'screen_shake')

func _process(delta: float) -> void:
	offset_h = rand_range(-shake, shake)
	offset_v = rand_range(-shake, shake)

func stop_shaking():
	shake = 0

func screen_shake(amount, duration):
	shake = amount
	ScreenShakeTimer.wait_time = duration
	ScreenShakeTimer.start()
