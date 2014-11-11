define(['game'], (Game)-> 

	App = 
		clickType: if ('ontouchstart' of window) then 'touchend' else 'click'
		init: () ->
			# 获取dom节点，添加监听事件

			this.initEvent();
			this.loading();
			return
		loading: () ->
			# 加载资源
			return
		render: () ->
			# 隐藏加载页，显示游戏开始页面
			return
		initEvent: () ->
			# 为页面绑定事件
			return
	return App;
)