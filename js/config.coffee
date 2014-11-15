define () ->
	lang = 
		zh: 
			lv_txt: ["瞎子", "色盲", "色郎", "色狼", "色鬼", "色魔", "超级色魔", "变态色魔", "孤独求色"]
		en: 
			lv_txt: ["Blind", "Very weak", "Weak", "Just so so", "Not bad", "Nice one", "  Great", "Amazing", "Insane"]
	_config = 
		lv_txt: lang['zh'].lv_txt
		size: 500
		color1:
			target: 1
			allTime: 60
			addTime: 1
			lvMap: [2, 3, 4, 5, 5, 6, 6, 7, 7, 7, 8, 8, 8, 8, 8, 8, 9]
		color2: 
			target: 2
			allTime: 1200
			addTime: 3
			lvMap: [4, 4, 6, 6, 6, 6, 6, 6, 8] 