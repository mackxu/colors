define(['game'], (Game)-> 

	$el = null

	App = 
		clickType: if ('ontouchstart' of window) then 'touchend' else 'click'
		init: () ->
			# 获取dom节点，添加监听事件
			$el = 
				loading: $('#J_loading')
				index: $('#J_index')
				room: $('#J_room')
				btnModes: $('#J_modes')

			this.initEvent();
			this.loading();
			return
		loading: () ->
			# 加载资源
			this.render();
			return
		render: () ->
			# 隐藏加载页，显示游戏开始页面
			setTimeout( () ->
				$el.loading.hide()
				$el.index.show()
				return;
			, 1000);
			return
		initEvent: () ->
			self = this
			# 为页面绑定事件
			$el.btnModes.on self.clickType, 'a', () ->
				mode = this.getAttribute( 'data-mode' ) 
				if mode
					$el.index.hide()
					Game.init mode, self
				return
			return
	return App;
)