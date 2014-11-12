define(['game'], (Game)-> 

	App = 
		clickType: if ('ontouchstart' of window) then 'touchend' else 'click'
		init: () ->
			# 获取dom节点，添加监听事件
			this.$el = 
				loading: $('#J_loading')
				index: $('#J_index')
				room: $('#J_room')
				dialog: $('#J_dialog')

			this.initEvent();
			this.loading();
			return
		loading: () ->
			# 加载资源
			this.render();
			return
		render: () ->
			# 隐藏加载页，显示游戏开始页面
			self = this;
			setTimeout( () ->
				self.$el.loading[0].style.display = 'none'
				self.$el.index[0].style.display = 'block'
			, 1000);
			return
		initEvent: () ->
			# 为页面绑定事件
			return
	return App;
)