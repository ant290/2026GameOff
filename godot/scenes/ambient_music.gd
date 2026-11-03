extends AudioStreamPlayer

const JAZZ_VOL_2_CLUB_DIZZY_MAIN = preload("uid://wyrltgn53rd")
const JAZZ_VOL_2_DREAMSTATE_MAIN = preload("uid://cfp1ye37lvwuu")
const JAZZ_VOL_2_FRUIT_SALAD_MAIN = preload("uid://10ryh6vbygtd")
const JAZZ_VOL_2_RAINY_DAY_MAIN = preload("uid://bdoqfrp3b8qnw")
const JAZZ_VOL_2_THE_HEIGHTS_MAIN = preload("uid://0j530aephcqf")

var music_scenes : Array[AudioStream] = [
	JAZZ_VOL_2_CLUB_DIZZY_MAIN,
	JAZZ_VOL_2_DREAMSTATE_MAIN,
	JAZZ_VOL_2_FRUIT_SALAD_MAIN,
	JAZZ_VOL_2_RAINY_DAY_MAIN,
	JAZZ_VOL_2_THE_HEIGHTS_MAIN
]

var currentTrackIndex := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finished.connect(_on_music_finished)
	_play_music(music_scenes[currentTrackIndex])

func _on_music_finished() -> void:
	currentTrackIndex = (currentTrackIndex + 1) % music_scenes.size()
	_play_music(music_scenes[currentTrackIndex])

func _play_music(music: AudioStream) -> void:
	stream = music
	play()
