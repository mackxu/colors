define [ 'config', 'color1', 'color2' ], ( Conf, color1, color2 ) ->
	# 游戏模式有两种: 普通和双飞
	Colors = 
		color1: color1
		color2: color2

	timerID = null			# 倒计时id
	pause = false			# 游戏暂停
	lv = 0 					# 游戏局数
	lvMap = null			# 游戏的所有地图 每个模式不同
	colorConf = null
	currMap = 0				# 当前使用的地图行数 [ 多处计算用到该值 ]
	finded = 0				# 本局找到的目标的颜色个数
	target = 0				# 该模式的目标颜色个数
	score = 0				# 总得分
	currTime = 0			# 当前倒计时数
	lvTxt = Conf['lv_txt']
	inited = false			# 用于模式切换

	$el = null				# 所有元素
	
	# 定制私有方法
	clearTimer = () ->
		clearInterval timerID
		timerID = null
		return

	# 公开的方法
	init: ( type, App ) ->
		$el = 
			room: $('#J_room')
			grid: $('#J_grid')
			pause: $('#J_pause')
			score: $('#J_score')
			cdown: $('#J_cdown')
			dialog: $('#J_dialog')
			btnWrap: $('.btn-wrap')
			dContent: $( '.content' )
			dGameover: $( '.gameover' )
			dPause: $( '.pause' )
			dLvText: $( '.level-text' )

		# 根据type的值，获取对应的config和api
		this.Color = Colors[type]
		colorConf = Conf[type]
		target = colorConf.target
		lvMap = colorConf.lvMap
		this.App = App;

		this.renderUI();
		this.reset();						# 重置一些参数
		inited or this.initEvent();
		inited = true
		this.build();
		return
	renderUI: () ->
		# 制定颜色网格大小
		size = Math.min(window.innerWidth, window.innerHeight);
		size = Math.min(size - 10, Conf.size);
		$el.grid.width(size).height(size);
		# 隐藏开始界面，显示游戏舞台
		$el.room[0].style.display = 'block'
		return
	initEvent: () ->
		self = this
		clickType = self.App.clickType
		# 为颜色块添加监听事件
		$el.grid.on(clickType, 'span', $.proxy(self.selectColor, self))
		$el.pause.on clickType, $.proxy(self.pause, self)
		# 为dialog的按钮添加监听事件
		$el.btnWrap.on clickType, 'a', () ->
			if this.className.indexOf('btn-restart') isnt -1
				self.restart()
				return
			else if this.className.indexOf('btn-resume') isnt -1
				self.resume()
				return
			else if this.className.indexOf('btn-toIndex') isnt -1
				# 返回到游戏开始界面
				$('.page').hide().eq(1).show();
				return
				
		# 为颜色网格添加适应布局
		$(window).on 'resize', $.proxy(self.renderUI, self)

		return
	build: ( next ) ->
		# 每一局都会执行
		finded = 0
		# 构建网格颜色块
		this.createMap()
		# 更新得分
		$el.score.text score
		# 设置界面的初始倒计时数
		next or $el.cdown.text currTime
		# 然后开启游戏倒计时(确保只设置一次)
		timerID = timerID or setInterval $.proxy( this.tick, this ), 1000
		return
	pause: () ->
		pause = true
		$el.dialog.show()
		$el.dContent.hide()
		$el.dPause.show()
		return
	resume: () ->
		pause = false
		$el.dialog.hide()
		return
	restart: () ->
		clearTimer()			# 清除现有的定时器
		pause = false
		this.reset()			# 重置参数
		this.build()			# 新的征程开始吧
		$el.dialog.hide()
		return
	reset: () ->
		# 重置倒计时数
		currTime = colorConf.allTime
		# 当前得分
		score = 0
		# 当前的局数
		lv = 0
		return
	selectColor: (e) ->
		if $.data(e.target, 'target') is true
			finded += 1
			score += Math.round currMap / 2
			# 判断是否可以进入下一局
			this.nextTv() if finded is target
		else
			# 如果选中失败
			currTime -= 1 
		return
	nextTv: () ->
		lv += 1
		# 有限制条件的奖励时间 1 或 2
		currTime += Math.ceil Math.random() * 2 if currMap > 8 
		this.build true
		return
	tick: () ->
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
			if currTime < 0 then this.gameOver() else $el.cdown.text currTime
		return
	createMap: () ->
		# 读取当前的map, 构建颜色块
		currMap = lvMap[lv] or lvMap[lvMap.length - 1]
		mapHTML = ('<span></span>' for i in [ 0 ... currMap * currMap ]).join('')
		# 把构建好的结构插入到grid
		# 需要移除之前的lv+n!!
		# full grid 用于固定样式
		# 由于游戏over时会隐藏grid，所以后面需要添加show()
		$el.grid.attr( 'class', 'full grid lv' + currMap)
			.html( mapHTML ).show();
		# 渲染颜色块 待优化该逻辑
		this.Color.init currMap, lv, $el.grid.find('span') 
		return  
	gameOver: () ->
		# 取消现有定时器
		clearTimer();
		# 游戏的官封
		textLv = this.Color.getTextLv lv
		lvT = Conf.lv_txt
		currLvT = lvT[textLv] or lvT[lvT.length - 1]
		$el.dLvText.text 'Lv' + lv + currLvT
		$el.grid.fadeOut 1000, () ->
			$el.dialog.show()
			$el.dContent.hide()
			$el.dGameover.show()
			return
		return