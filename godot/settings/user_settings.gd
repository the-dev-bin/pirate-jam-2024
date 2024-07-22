extends Node

signal on_value_change(key, value)

const SECTION: String = "user"
const SETTINGS_FILE: String = "user://settings.cfg"

const MASTERVOLUME_ENABLED: String = "mastervolume_enabled"
const MUSICVOLUME_ENABLED: String = "musicvolume_enabled"
const SOUNDVOLUME_ENABLED: String = "soundvolume_enabled"
const MASTERVOLUME: String = "mastervolume"
const MUSICVOLUME: String = "musicvolume"
const SOUNDVOLUME: String = "soundvolume"
const GAME_LANGUAGE: String = "game_locale"

const AUDIO_BUS_MASTER: String = "Master"
const AUDIO_BUS_SOUND: String = "Sound"
const AUDIO_BUS_MUSIC: String = "Music"

var USER_SETTING_DEFAULTS: Dictionary = {
	MASTERVOLUME_ENABLED:true,
	MUSICVOLUME_ENABLED:true,
	SOUNDVOLUME_ENABLED:true,
	MASTERVOLUME:100,
	MUSICVOLUME:70,
	SOUNDVOLUME:100,
	GAME_LANGUAGE:"en"
}

var config:ConfigFile

func _ready() -> void:
	config = ConfigFile.new()
	config.load(SETTINGS_FILE)
	_configure_audio()
	_configure_language()

func set_value(key: String, value: Variant) -> void:
	config.set_value(SECTION, key, value)
	config.save(SETTINGS_FILE)
	if key == MASTERVOLUME:
		_update_volume(MASTERVOLUME, AUDIO_BUS_MASTER)
	if key == SOUNDVOLUME:
		_update_volume(SOUNDVOLUME, AUDIO_BUS_SOUND)
	if key == MUSICVOLUME:
		_update_volume(MUSICVOLUME, AUDIO_BUS_MUSIC)
	if key == MASTERVOLUME_ENABLED:
		_mute_bus(MASTERVOLUME_ENABLED, AUDIO_BUS_MASTER)
	if key == MUSICVOLUME_ENABLED:
		_mute_bus(MUSICVOLUME_ENABLED, AUDIO_BUS_MUSIC)
	if key == SOUNDVOLUME_ENABLED:
		_mute_bus(SOUNDVOLUME_ENABLED, AUDIO_BUS_SOUND)
	if key == GAME_LANGUAGE:
		TranslationServer.set_locale(value)
	emit_signal("on_value_change", key, value)

func get_value(key: String) -> Variant:
	return config.get_value(SECTION, key, _get_default(key))

func get_value_with_default(key: String, default: Variant) -> Variant:
	return config.get_value(SECTION, key, default)

func _get_default(key: String) -> Variant:
	if USER_SETTING_DEFAULTS.has(key):
		return USER_SETTING_DEFAULTS[key]
	return null

func _configure_audio() -> void:
	_update_volume(MASTERVOLUME, AUDIO_BUS_MASTER)
	_update_volume(MUSICVOLUME, AUDIO_BUS_MUSIC)
	_update_volume(SOUNDVOLUME, AUDIO_BUS_SOUND)
	_mute_bus(MASTERVOLUME_ENABLED, AUDIO_BUS_MASTER)
	_mute_bus(MUSICVOLUME_ENABLED, AUDIO_BUS_MUSIC)
	_mute_bus(SOUNDVOLUME_ENABLED, AUDIO_BUS_SOUND)
	
func _update_volume(property: Variant, bus: Variant) -> void:
	var current: Variant = (get_value_with_default(property, USER_SETTING_DEFAULTS[property]) -100) / 2
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), current)

func _mute_bus(property: Variant, bus: Variant) -> void:
	var enabled : bool = get_value_with_default(property, USER_SETTING_DEFAULTS[property])
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), not enabled)

func _configure_language() -> void:
	TranslationServer.set_locale(get_value_with_default(GAME_LANGUAGE, USER_SETTING_DEFAULTS[GAME_LANGUAGE])) 
