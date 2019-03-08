" Registered idle callbacks
let s:idle_callbacks = []
" The idle timer
let s:idle_timer = -1
" How long have us idled
let s:idle_time = 0

func s:arm_idle_timer()
	let l:timeout = -1
	for c in s:idle_callbacks
		if c[0] <= s:idle_time
			continue
		endif

		if l:timeout == -1 || c[0] < l:timeout
			let l:timeout = c[0]
		endif
	endfor
	let s:idle_timer = timer_start(l:timeout-s:idle_time, function('s:idle_callback'))
endfunc
func s:idle_callback(timer)
	let l:min = -1
	let l:cb = 0

	for c in s:idle_callbacks
		if l:min == -1 || c[0] < min
			let l:min = c[0]
			let l:cb = c[1]
		endif
	endfor

	execute l:cb

	echo timer_info()
	let l:info = timer_info(s:idle_timer)[0]
	call timer_stop(s:idle_timer)
	echo l:info
	let s:idle_time += l:info["time"]

	call s:arm_idle_timer()
endfunc

func s:input_callback()
	if s:idle_timer >= 0
		call timer_stop(s:idle_timer)
		let s:idle_time = 0
	endif
	call s:arm_idle_timer()
endfunc

func s:add_idle_callback(timeout, ...)
	let l:cb = join(a:000, " ")
	call add(s:idle_callbacks, [a:timeout, l:cb])
	if s:idle_timer == -1
		let s:idle_timer = timer_start(a:timeout, function('s:idle_callback'))
	endif
endfunc

autocmd InsertCharPre * call s:input_callback()

command! -nargs=* OnIdle call s:add_idle_callback(<f-args>)
