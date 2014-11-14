define () ->
	d = 0;
	rgb = null				# 目标颜色的数组形式
	init: () ->
		return
	render: (lvMap, lv, $colors) ->
		# 根据lv的值，产生出目标颜色
		if lv > 50
			d = 5
		else if lv > 40
			d = 8
		else if lv > 20
			d = 10
		else
			# d >= 15
			d = 15 * Math.max 9 - lvMap, 1
		targetColor = this.getColor()
		lvColor = this.getLvColor()
		targetBlock = Math.floor Math.random() * lvMap * lvMap
		# 渲染到颜色块上
		$colors.css('background-color', lvColor)
			.eq(targetBlock)
			.css('background-color', targetColor).data('target', true)
		return
	getColor: () ->
		# 返回目标颜色
		temp = 255 - d
		rgb = [
			Math.round Math.random() * temp
			Math.round Math.random() * temp
			Math.round Math.random() * temp
		]
		# 需要确保和底色不一致才行
		return "rgb(#{rgb.join()})"
	getLvColor: () ->
		# 根据制定的规则，返回干扰色
		lvRgb = $.map rgb, (value) ->
			return value + d + 10

		return "rgb(#{lvRgb.join()})"
	getGameOverText: () ->
		return
