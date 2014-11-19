define ['color'], ( Color ) ->
	# 颜色块会旋转90度
	gridRotate = 'grid-rotate'

	# 双飞模式的API
	Color2 = Object.create Color

	Color2.render =  () ->
		colorsNum = @$colors.length				# 总颜色块数
		if Math.random() < 0.5 then @$grid.addClass( gridRotate ) else @$grid.removeClass( gridRotate )
		# 根据lv的值，产生出目标颜色 
		targetColor = @getColor()
		lvColor = @getLvColor()
		targetBlock = Math.floor Math.random() * (colorsNum / 2)
		# 渲染颜色块
		@$colors.css('background-color', lvColor)
			.eq(targetBlock)
			.css('background-color', targetColor).data('target', true)

		targetColor = @getColor()
		lvColor = @getLvColor()
		# 此处的随机块用于过滤后颜色块数组
		targetBlock = Math.floor Math.random() * (colorsNum / 2)
		# 渲染后半部分的颜色块
		@$colors.slice(colorsNum / 2).css('background-color', lvColor)
			.eq(targetBlock)
			.css('background-color', targetColor).data('target', true)
		return

	return Color2
