define [ 'config', 'color1', 'color2' ], ( Conf, color1, color2 ) ->
	# 游戏模式有两种: 普通和双飞
	Color = 
		color1: color1
		color2: color2

	timerID = null			# 倒计时id
	pause = false			# 游戏暂停
	lv = 0 					# 游戏局数
	lvMap = null			# 游戏的地图 每个模式不同
	finded = 0				# 本局找到的目标的颜色个数
	score = 0				# 总得分
	currTime = 0			# 当前倒计时
	lvTxt = Conf['lv_txt']
	inited = false			# 用于模式切换

	Game = 
		init: ( type, App ) ->
			this.$el = 
				room: $('#J_room')
				grid: $('#J_grid')
				pause: $('#J_pause')
				dialog: $('#J_dialog')

			this.Color = Color[type]				# 根据参数确定开启哪种游戏模式
			this.mode = Conf[type]
			lvMap = this.mode.lvMap
			this.App = App;

			this.renderUI();
			inited and this.reset();				# 重置一些参数
			inited or this.initEvent();
			inited = true
			this.start();
			return
		renderUI: () ->
			# 制定颜色网格大小
			size = Math.min(window.innerWidth, window.innerHeight);
			size = Math.min(size - 20, Conf.size);
			this.$el.grid.width(size).height(size);
			# 隐藏开始界面，显示游戏舞台
			this.$el.room[0].style.display = 'block'
			return
		initEvent: () ->
			self = this
			$el = self.$el
			clickType = self.App.clickType

			$el.grid.on(clickType, 'span', $.proxy(self.selectColor, self))
			# $el.pause.on clickType, $.proxy(self.pause, self)
			# $el.resume.on clickType, $.proxy(self.resume, self)
			# $el.restart.on clickType, $.proxy(self.restart, self)
			# 为颜色网格添加适应布局
			$(window).on 'resize', $.proxy(self.renderUI, self)

			return
		start: ( next ) ->
			# 每一局都会执行
			finded = 0
			pause = false 				# 确保从restart后的倒计时是正常的
			lv = if next then lv + 1 else 0
			# 构建网格颜色块
			this.createMap()
			# 更新分数和时间

			# 开启游戏倒计时
			return
		pause: () ->
			return
		resume: () ->
			return
		restart: () ->
			return
		reset: () ->
			currTime = this.mode.allTime
			lv = 0
		selectColor: (e) ->
			if $.data(e.target, 'target')
				this.nextTv();
			return
		nextTv: () ->
			currTime += this.mode.addTime
			this.start true
			return
		tick: () ->
			return
		createMap: () ->
			# 读取当前的map, 构建颜色块
			curMap = lvMap[lv] or lvMap[lvMap.length - 1]
			mapHTML = ('<span></span>' for i in [ 0 ... curMap * curMap ])
			# 把构建好的结构插入到grid
			# 需要移除之前的lv+n
			this.$el.grid
				.addClass('lv' + curMap)
				.html( mapHTML.join('') )
			# 渲染颜色块 待优化该逻辑
			this.Color.render curMap, lv, this.$el.grid.find('span') 
			return  
		gameOver: () ->
			return

	return Game;