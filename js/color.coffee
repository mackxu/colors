define () ->
    # 用于color1/color2的基类

    # 私有变量
    seed = 0;               # 干扰因子
    rgb = null              # 目标颜色的数组形式
    
    # 公有方法
    init: (@lvMap, @lv, @$grid) ->
        @$colors = @$grid.find 'span'
        
        @_generateSeed()
        @render()
        return
    render: () ->
        throw new Error 'render function is undefined'
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