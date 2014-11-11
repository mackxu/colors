define [ 'config', 'color1', 'color2' ], ( config, color1, color2 ) ->
	# 游戏模式有两种: 普通和双飞
	Api = 
		color1: color1
		color2: color2

	Game = 
		init: ( type, $room, App ) ->
			this.api = Api[type]		# 根据参数确定开启哪种游戏模式
			return
	return Game;