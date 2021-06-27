extends Node


var archiveType = ".zip"
var sceneType = ".tscn"
var lessonsServerFolder = "res://Lessons/"
var lessonsClientFolder = "res://DownloadedLessons/"

var port = 1237
var address = "127.0.0.1"

export(Resource) var ship
export(Resource) var lvl
export(bool) var useLogs = false
