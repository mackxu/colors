define () ->
	# 私有变量
	seed = 0;				# 干扰因子
	rgb = null				# 目标颜色的数组形式
	
	# 共有方法
	init: (@lvMap, @lv, @$colors) ->
		@_generateSeed()
		@render()
		return
	render: () ->
		# 根据lv的值，产生出目标颜色 
		targetColor = @getColor()
		lvColor = @getLvColor()
		targetBlock = Math.floor Math.random() * @lvMap * @lvMap
		# 渲染到颜色块上
		@$colors.css('background-color', lvColor)
			.eq(targetBlock)
			.css('background-color', targetColor).data('target', true)
		return
	getColor: () ->
		# 返回目标颜色
		tmpSeed = 255 - seed
		rgb = [
			Math.round Math.random() * tmpSeed
			Math.round Math.random() * tmpSeed
			Math.round Math.random() * tmpSeed
		]
		# 需要确保和底色不一致才行!!
		return "rgb(#{rgb.join()})"
	getLvColor: () ->
		# 根据制定的规则，返回干扰色
		lvRgb = $.map rgb, (value) ->
			return value + seed + 10

		return "rgb(#{lvRgb.join()})"
	getTextLv: () ->
		if 20 > @lv then 0 else Math.ceil (@lv - 20) / 10
	_generateSeed: () ->
		# 产生干扰因子，会随着lv变大而变小
		if @lv > 50
			seed = 5
		else if @lv > 40
			seed = 8
		else if @lv > 20
			seed = 10
		else
			# 获得的seed >= 15
			seed = 15 * Math.max( 9 - @lvMap, 1 )
		return 
