local inserts =
{
	{
		"options_dialog_screen.lua",
		{ "widgets", 5, "tabs" },
		{
			{
				name = [[New Widget]],
				isVisible = true,
				noInput = false,
				anchor = 1,
				rotation = 0,
				x = 0,
				y = 0,
				w = 0,
				h = 0,
				sx = 1,
				sy = 1,
				ctor = [[group]],
				children =
				{
					{
						name = [[tabButton]],
						isVisible = true,
						noInput = false,
						anchor = 1,
						rotation = 0,
						x = -246,
						xpx = true,
						y = 0,
						ypx = true,
						w = 160,
						wpx = true,
						h = 28,
						hpx = true,
						sx = 1,
						sy = 1,
						ctor = [[button]],
						clickSound = [[SpySociety/HUD/menu/click]],
						hoverSound = [[SpySociety/HUD/menu/rollover]],
						hoverScale = 1.1,
						rawstr = [[UI TWEAKS]],
						halign = MOAITextBox.CENTER_JUSTIFY,
						valign = MOAITextBox.CENTER_JUSTIFY,
						text_style = [[font1_16_r]],
						images =
						{
							{
								file = [[tab.png]],
								name = [[inactive]],
							},
							{
								file = [[tab_hover.png]],
								name = [[hover]],
							},
							{
								file = [[tab_active.png]],
								name = [[active]],
							},
							{
								file = [[tab_selected.png]],
								name = [[selected_inactive]],
							},
							{
								file = [[tab_selected_hover.png]],
								name = [[selected_hover]],
							},
							{
								file = [[tab_selected_active.png]],
								name = [[selected_active]],
							},
						},
					},
				},
			},
			{
				name = [[New Widget]],
				isVisible = true,
				noInput = false,
				anchor = 1,
				rotation = 0,
				x = 0,
				y = 0,
				w = 0,
				h = 0,
				sx = 1,
				sy = 1,
				ctor = [[group]],
				children =
				{
					{
						name = [[uitrOptionsList]],
						isVisible = true,
						noInput = false,
						anchor = 1,
						rotation = 0,
						x = -10,
						xpx = true,
						y = -212 - 12,
						ypx = true,
						w = 600,
						wpx = true,
						h = 380,
						hpx = true,
						sx = 1,
						sy = 1,
						ctor = [[listbox]],
						item_template = [[]],
						scrollbar_template = [[listbox_vscroll]],
						orientation = 2,
						item_spacing = 30,
					},
					{
						name = [[uitrResetOptionsBtn]],
						isVisible = true,
						noInput = false,
						anchor = 1,
						rotation = 0,
						x = -215,
						xpx = true,
						y = -433,
						ypx = true,
						w = 190,
						wpx = true,
						h = 38,
						hpx = true,
						sx = 1,
						sy = 1,
						ctor = [[button]],
						clickSound = [[SpySociety/HUD/menu/click]],
						hoverSound = [[SpySociety/HUD/menu/rollover]],
						hoverScale = 1,
						hotkey = 13,
						halign = MOAITextBox.RIGHT_JUSTIFY,
						valign = MOAITextBox.CENTER_JUSTIFY,
						text_style = [[font1_16_r]],
						offset =
						{
							x = -15,
							xpx = true,
							y = 0,
							ypx = true,
						},
						images =
						{
							{
								file = [[white.png]],
								name = [[inactive]],
								color =
								{
									0.30588236451149,
									0.533333361148834,
									0.533333361148834,
									0.39215686917305,
								},
							},
							{
								file = [[white.png]],
								name = [[hover]],
								color =
								{
									0.549019634723663,
									1,
									1,
									0.39215686917305,
								},
							},
							{
								file = [[white.png]],
								name = [[active]],
								color =
								{
									0.549019634723663,
									1,
									1,
									0.39215686917305,
								},
							},
						},
					},
					{
						name = [[uitrReloadWarning]],
						isVisible = false,
						noInput = false,
						anchor = 1,
						rotation = 0,
						x = 220,
						xpx = true,
						y = -400,
						ypx = true,
						w = 400,
						wpx = true,
						h = 50,
						hpx = true,
						sx = 1,
						sy = 1,
						ctor = [[label]],
						halign = MOAITextBox.LEFT_JUSTIFY,
						valign = MOAITextBox.RIGHT_JUSTIFY,
						text_style = [[font1_16_r]],
						color =
						{
							1,
							0.8,
							0.5,
							1,
						},
					},
				},
			},
		},
	},
	{
		"options_dialog_screen.lua",
		{ "skins" },
		{
			name = [[ComboOption]],
			isVisible = true,
			noInput = false,
			anchor = 1,
			rotation = 0,
			x = 0,
			y = 0,
			w = 0,
			h = 0,
			sx = 1,
			sy = 1,
			ctor = [[group]],
			children =
			{
				{
					name = [[dropTxt]],
					isVisible = true,
					noInput = false,
					anchor = 1,
					rotation = 0,
					x = 0,
					xpx = true,
					y = 4,
					ypx = true,
					w = 580,
					wpx = true,
					h = 28,
					hpx = true,
					sx = 1,
					sy = 1,
					ctor = [[label]],
					halign = MOAITextBox.LEFT_JUSTIFY,
					valign = MOAITextBox.RIGHT_JUSTIFY,
					text_style = [[font1_16_r]],
					color =
					{
						0.549019634723663,
						1,
						1,
						1,
					},
				},
				{
					name = [[widget]],
					isVisible = true,
					noInput = false,
					anchor = 1,
					rotation = 0,
					x = 117 - 10,
					xpx = true,
					y = 2,
					ypx = true,
					w = 322,
					wpx = true,
					h = 28,
					hpx = true,
					sx = 1,
					sy = 1,
					ctor = [[combobox]],
					arrow_size = 20,
					text_style = [[font1_16_r]],
					arrow_image = [[arrow_down.png]],
					bg_image = [[]],
					bg_color =
					{
						1,
						1,
						1,
						1,
					},
					can_edit = false,
				},
				{
					name = [[line]],
					isVisible = true,
					noInput = false,
					anchor = 1,
					rotation = 0,
					x = 0,
					xpx = true,
					y = -10,
					ypx = true,
					w = 580,
					wpx = true,
					h = 1,
					hpx = true,
					sx = 1,
					sy = 1,
					ctor = [[image]],
					color =
					{
						0.219607844948769,
						0.376470595598221,
						0.376470595598221,
						1,
					},
					images =
					{
						{
							file = [[white.png]],
							name = [[]],
							color =
							{
								0.219607844948769,
								0.376470595598221,
								0.376470595598221,
								1,
							},
						},
					},
				},
				{
					name = [[sectionHeaderLine]],
					isVisible = false,
					noInput = false,
					anchor = 1,
					rotation = 0,
					x = 0,
					xpx = true,
					y = 19,
					ypx = true,
					w = 580,
					wpx = true,
					h = 3,
					hpx = true,
					sx = 1,
					sy = 1,
					ctor = [[image]],
					color =
					{
						0.219607844948769,
						0.376470595598221,
						0.376470595598221,
						1,
					},
					images =
					{
						{
							file = [[white.png]],
							name = [[]],
							color =
							{
								0.219607844948769,
								0.376470595598221,
								0.376470595598221,
								1,
							},
						},
					},
				},
				{
					name = [[uitrNeedsCampaignWarning]],
					isVisible = false,
					noInput = false,
					anchor = 1,
					rotation = 0,
					x = 150,
					xpx = true,
					y = 3,
					ypx = true,
					w = 400,
					wpx = true,
					h = 28,
					hpx = true,
					sx = 1,
					sy = 1,
					ctor = [[label]],
					halign = MOAITextBox.LEFT_JUSTIFY,
					valign = MOAITextBox.RIGHT_JUSTIFY,
					text_style = [[font1_16_r]],
					color =
					{
						1,
						0.8,
						0.5,
						1,
					},
				},
			},
		},
	},
	{
		"options_dialog_screen.lua",
		{ "skins" },
		{
			name = [[CheckOption]],
			isVisible = true,
			noInput = false,
			anchor = 1,
			rotation = 0,
			x = 0,
			y = 0,
			w = 0,
			h = 0,
			sx = 1,
			sy = 1,
			ctor = [[group]],
			children =
			{
				{
					name = [[widget]],
					isVisible = true,
					noInput = false,
					anchor = 1,
					rotation = 0,
					x = 0,
					xpx = true,
					y = 0,
					ypx = true,
					w = 580,
					wpx = true,
					h = 28,
					hpx = true,
					sx = 1,
					sy = 1,
					ctor = [[checkbox]],
					check_size = 32,
					halign = MOAITextBox.LEFT_JUSTIFY,
					valign = MOAITextBox.LEFT_JUSTIFY,
					text_style = [[font1_16_r]],
					color =
					{
						0.549019634723663,
						1,
						1,
						1,
					},
					images =
					{
						{
							file = [[checkbox_no2.png]],
							name = [[no]],
						},
						{
							file = [[checkbox_yes2.png]],
							name = [[yes]],
						},
						{
							file = [[]],
							name = [[maybe]],
						},
					},
				},
				{
					name = [[line]],
					isVisible = true,
					noInput = false,
					anchor = 1,
					rotation = 0,
					x = 0,
					xpx = true,
					y = -10,
					ypx = true,
					w = 580,
					wpx = true,
					h = 1,
					hpx = true,
					sx = 1,
					sy = 1,
					ctor = [[image]],
					color =
					{
						0.219607844948769,
						0.376470595598221,
						0.376470595598221,
						1,
					},
					images =
					{
						{
							file = [[white.png]],
							name = [[]],
							color =
							{
								0.219607844948769,
								0.376470595598221,
								0.376470595598221,
								1,
							},
						},
					},
				},
				{
					name = [[sectionHeaderLine]],
					isVisible = false,
					noInput = false,
					anchor = 1,
					rotation = 0,
					x = 0,
					xpx = true,
					y = 19,
					ypx = true,
					w = 580,
					wpx = true,
					h = 3,
					hpx = true,
					sx = 1,
					sy = 1,
					ctor = [[image]],
					color =
					{
						0.219607844948769,
						0.376470595598221,
						0.376470595598221,
						1,
					},
					images =
					{
						{
							file = [[white.png]],
							name = [[]],
							color =
							{
								0.219607844948769,
								0.376470595598221,
								0.376470595598221,
								1,
							},
						},
					},
				},
				{
					name = [[uitrNeedsCampaignWarning]],
					isVisible = false,
					noInput = false,
					anchor = 1,
					rotation = 0,
					x = 240,
					xpx = true,
					y = 3,
					ypx = true,
					w = 400,
					wpx = true,
					h = 28,
					hpx = true,
					sx = 1,
					sy = 1,
					ctor = [[label]],
					halign = MOAITextBox.LEFT_JUSTIFY,
					valign = MOAITextBox.RIGHT_JUSTIFY,
					text_style = [[font1_16_r]],
					color =
					{
						1,
						0.8,
						0.5,
						1,
					},
				},
			},
		},
	},
	{
		"options_dialog_screen.lua",
		{ "skins" },
		{
			name = [[OptionSpacer]],
			isVisible = true,
			noInput = false,
			anchor = 1,
			rotation = 0,
			x = 0,
			y = 0,
			w = 0,
			h = 0,
			sx = 1,
			sy = 1,
			ctor = [[group]],
			children = {},
		},
	},
}

return inserts
