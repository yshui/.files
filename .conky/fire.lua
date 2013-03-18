do
	require 'imlib2'
	local onfire=false
	local threshold=72
	local notify=74
	local critical=86
	function conky_pconfire()
		local tmp=tonumber(conky_parse('${acpitemp}'))
		if tmp<threshold and not onfire then
			return ""
		end
		local per=((tmp-threshold)*0.7*255)/(critical-threshold+0.0)
		if tmp<threshold then
			per=0
			onfire=false
		else
			onfire=true
		end
		imlib_set_cache_size(0)
		imlib_set_font_cache_size(512 * 1024)
		imlib_set_color_usage(128)
		imlib_context_set_dither(1)
		imlib_context_set_display(conky_window.display)
		imlib_context_set_visual(conky_window.visual)
		imlib_context_set_drawable(conky_window.drawable)
		imlib_context_set_color(0xff,0x20,0x00,per)
		local buffer = imlib_create_image(conky_window.width, conky_window.height)
		if buffer == nil then
			return ""
		end
		imlib_context_set_image(buffer)
		imlib_image_clear()
		imlib_image_fill_rectangle(0, 0, conky_window.width, conky_window.height)
		imlib_render_image_on_drawable(0, 0)
		imlib_free_image()
		return ""
	end
end
