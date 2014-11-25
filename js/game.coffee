define [ 'dist/config', 'dist/color1', 'dist/color2' ], ( Conf, color1, color2 ) ->
	# 游戏模式有两种: 普通和双飞
	Colors = 
		color1: color1
		color2: color2

	timerID = null			# 倒计时id
	pause = false			# 游戏暂停
	lv = 0 					# 游戏局数
	lvMap = null			# 游戏的所有地图 每个模式不同
	colorConf = null
	currMap = 0				# 当前使用的地图的大小 [ 多处计算用到该值 ]
	finded = 0				# 本局找到的目标的颜色个数
	target = 0				# 该模式的目标颜色个数
	score = 0				# 总得分
	currTime = 0			# 当前倒计时数
	lvTxt = Conf['lv_txt']
	inited = false			# 用于模式切换

	$el = null				# 所有元素
	absent = -1 			# 字符串查找类选择器是否存在
	
	# 定制私有方法
	clearTimer = ->
		clearInterval timerID
		timerID = null
		return

	# Game的共有方法
	init: ( type, App ) ->
		$el = 
			room: $('#J_room')
			grid: $('#J_grid')
			pause: $('#J_pause')
			score: $('#J_score')
			cdown: $('#J_cdown')
			dialog: $('#J_dialog')
			btns: $('.btns')
			dContent: $( '.content' )
			dGameover: $( '.gameover' )
			dPause: $( '.pause' )
			dLvText: $( '.level-text' )

		# 根据type的值，获取对应的config和api
		@Color = Colors[type]
		colorConf = Conf[type]

		target = colorConf.target
		lvMap = colorConf.lvMap
		@App = App;
		# 做一些准备工作，并开启游戏
		@renderGrid();
		@resetGameData();						# 重置一些参数
		inited or @initEvent()
		inited = true
		@buildGame()
		return

	renderGrid: ->
		# 制定颜色网格大小
		size = Math.min(window.innerWidth, window.innerHeight);
		size = Math.min(size - 10, Conf.size);
		$el.grid.width(size).height(size);
		# 隐藏开始界面，显示游戏舞台
		$el.room.show()
		return

	initEvent: ->
		# 为页面元素绑定事件
		self = @
		clickType = self.App.clickType
		# 为颜色块添加监听事件
		$el.grid.on(clickType, 'span', $.proxy(self.selectColorHandle, self))
		$el.pause.on clickType, $.proxy(self.pause, self)
		# 为dialog的按钮添加监听事件
		$el.btns.on clickType, 'a', ->
			className = this.className
			# absent的值为－1
			if className.indexOf('btn-restart') isnt absent 				# 重来，再来
				self.restart()
				return
			else if className.indexOf('btn-resume') isnt absent 			# 继续
				self.resume()
				return
			else if className.indexOf('btn-toIndex') isnt absent 			# 返回主界面
				# 返回到游戏开始界面
				$('.page').hide().filter('.page-index').show();
				return
				
		# 为颜色网格添加适应布局
		$(window).on 'resize', $.proxy(self.renderGrid, self)
		return

	buildGame: ( next ) ->
		# 每一局都会执行
		finded = 0
		# 更新得分, 用于[init/nextLv/restart]
		$el.score.text score
		# 设置界面的初始倒计时数
		next or $el.cdown.text currTime
		# 构建网格颜色块
		@createMap()
		# 然后开启游戏倒计时(确保只设置一次)
		timerID = timerID or setInterval $.proxy( @tick, @ ), 1000
		return

	pause: ->
		pause = true
		$el.dialog.show()
		$el.dContent.hide()
		$el.dPause.show()
		return

	resume: ->
		pause = false
		$el.dialog.hide()
		return

	restart: ->
		clearTimer()			# 清除现有的定时器
		pause = false
		@resetGameData()		# 重置参数
		@buildGame()				# 新的征程开始吧
		$el.dialog.hide()
		return

	resetGameData: ->
		# 重置倒计时数
		currTime = colorConf.allTime
		# 当前得分
		score = 0
		# 当前的局数
		lv = 0
		return

	selectColorHandle: (e) ->
		block = e.target
		# 是目标元素且没有被选中的(后者双飞模式会用到)
		if $.data(block, 'target') is true and block.className.indexOf('checked') is -1
			finded += 1
			# 分数策略不同模式也应该不同
			score += Math.round currMap / 2
			
			block.className = 'checked'				# 高亮选中的目标色块
			@nextTv() if finded is target			# 判断是否可以进入下一局
		else
			# 如果选中失败
			currTime -= 1 
		return

	nextTv: ->
		lv += 1
		# 有限制条件的奖励时间 1 或 2
		currTime += Math.ceil Math.random() * 2 if currMap > 8 
		@buildGame true
		return

	tick: ->
		# 更新时间，提醒时间，判断是否结束
		if pause is true
			return				# 游戏暂停, 停止更新倒计时
		else 
			currTime -= 1
			# currTime < 6 and $el.cdown.addClass 'warn'
			if currTime < 6
				$el.cdown.addClass 'warn'
			else
				$el.cdown.removeClass 'warn'
			if currTime < 0 then @gameOver() else $el.cdown.text currTime
		return

	createMap: ->
		# 读取当前的map, 构建颜色块
		currMap = lvMap[lv] or lvMap[lvMap.length - 1]
		mapHTML = ('<span></span>' for i in [ 0 ... currMap * currMap ]).join('')
		# 把构建好的结构插入到grid
		# 需要移除之前的lv+n!!
		# full grid 用于固定样式
		# 由于游戏over时会隐藏grid，所以后面需要添加show()
		$el.grid.attr( 'class', 'full grid lv' + currMap)
			.html( mapHTML ).show();
		# 执行核心逻辑，渲染颜色块
		@Color.init currMap, lv, $el.grid 
		return  

	gameOver: ->
		# 取消现有定时器
		clearTimer();
		# 游戏的官封
		textLv = @Color.getTextLv lv
		lvT = Conf.lv_txt
		currLvT = lvT[textLv] or lvT[lvT.length - 1]
		$el.dLvText.text 'Lv' + lv + currLvT
		$el.grid.fadeOut 1000, ->
			$el.dialog.show()
			$el.dContent.hide()
			$el.dGameover.show()
			return
		return