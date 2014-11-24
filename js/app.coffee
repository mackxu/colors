define ['dist/game'], (Game)-> 

	$el = null
	clickType = if ('ontouchstart' of window) then 'touchend' else 'click'

	# App的公有方法 
	init: ->
		# 获取dom节点，添加监听事件
		$el = 
			loading: $('#J_loading')
			index: $('#J_index')
			room: $('#J_room')
			btnModes: $('#J_modes')
		@clickType = clickType
		@initEvent();
		@loading();
		return
	loading: ->
		# 加载资源
		@render();
		return
	render: ->
		# 隐藏加载页，显示游戏开始页面
		setTimeout( ->
			$el.loading.hide()
			$el.index.show()
			return;
		, 1000);
		return
	initEvent: ->
		self = @
		# 为页面按钮绑定事件
		$el.btnModes.on self.clickType, 'a', ->
			mode = this.getAttribute( 'data-mode' ) 
			if mode
				$el.index.hide()
				Game.init mode, self
			return
		return