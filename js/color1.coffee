define ['dist/color'], (Color) ->
	Color1 = Object.create Color

	Color1.render = ->
		# 根据lv的值，产生出目标颜色 
		targetColor = @getColor()
		lvColor = @getLvColor()
		targetBlock = Math.floor Math.random() * @lvMap * @lvMap
		# 渲染到颜色块上
		@$colors.css('background-color', lvColor)
			.eq(targetBlock)
			.css('background-color', targetColor).data('target', true)
		return

	return Color1
	 
