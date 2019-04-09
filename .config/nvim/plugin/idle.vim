" Registered idle callbacks
let s:idle_callbacks = []
" The idle timer
let s:idle_timer = -1
" How long have us idled
let s:idle_time = 0

func s:arm_idle_timer()
	let l:timeout = -1
	for c in s:idle_callbacks
		if c[0] < s:idle_time
			continue
		endif
		if l:timeout == -1 || c[0] < l:timeout
			let l:timeout = c[0]
		endif
	endfor
	let s:idle_timer = timer_start(l:timeout, function('s:idle_callback'), {"repeat": -1})
endfunc
func s:idle_callback(timer)
	let l:min = -1
	let l:Cb = 0

	for c in s:idle_callbacks
		if l:min == -1 || c[0] < min
			let l:min = c[0]
			let l:Cb = c[1]
		endif
	endfor

	call l:Cb()

	let l:info = timer_info(s:idle_timer)[0]
	call timer_stop(s:idle_timer)
	let s:idle_time += l:info["time"]

	call s:arm_idle_timer()
endfunc

func s:input_callback(type)
	if s:idle_timer >= 0
		call timer_stop(s:idle_timer)
		let s:idle_time = 0
	endif
	call s:arm_idle_timer()
endfunc

func s:add_idle_callback(timeout, cb)
	call add(s:idle_callbacks, [a:timeout, a:cb])
	if s:idle_timer == -1
		call s:arm_idle_timer()
	endif
endfunc

func s:trampoline(str)
	execute a:str
endfunc

func s:add_idle_callback_str(timeout, ...)
	call s:add_idle_callback(a:timeout, function('s:trampoline', [ join(a:000, " ") ]))
endfunc

autocmd InsertCharPre * call s:input_callback("insert")
autocmd CursorMoved * call s:input_callback("move")
autocmd CursorMovedI * call s:input_callback("movei")

command! -nargs=* OnIdle call s:add_idle_callback_str(<f-args>)
