let s:next_msg_row = g:flocho_inset
let s:msgs = []

function! s:msg_close(timerid) abort
  let l:cur_msg = filter(copy(s:msgs), 'v:val.timerid == a:timerid')[0]
  if empty(l:cur_msg)
    echoe "Could not find relevant message"
  endif

  if bufnr() == l:cur_msg.bufid | return | endif

  " Remove from screen
  let l:cur_win = bufwinid(l:cur_msg.bufid)
  if l:cur_win != -1
    call nvim_win_close(l:cur_win, v:true)
  endif

  " Remove from arr
  let l:cur_msg_idx = index(s:msgs, l:cur_msg)
  if l:cur_msg_idx == -1
    echoe "Somethin' done goofed" | return
  else
    call remove(s:msgs, l:cur_msg_idx)
  endif

  let s:next_msg_row -= l:cur_msg.height + g:flocho_inset

  " Reorganise messages
  for l:msg in s:msgs
    let l:win_idx = bufwinid(l:msg.bufid)
    if l:win_idx == -1 | continue | endif
    if l:msg.row <= l:cur_msg.height + g:flocho_inset | continue | endif
    let l:msg.row -= l:cur_msg.height + g:flocho_inset
    let l:msg_copy = copy(l:msg)
    call remove(l:msg_copy, 'bufid')
    call remove(l:msg_copy, 'timerid')
    call nvim_win_set_config(l:win_idx, l:msg_copy)
  endfor

  call timer_stop(l:cur_msg.timerid)
endfunction

function! flocho#add_message(msg, ...) abort
  if g:flocho_width == -1 | let g:flocho_width = &columns / 3 | endif

  let l:msg_lines = split(a:msg, '\%' . g:flocho_width . 'c')
  let l:height = len(l:msg_lines)
  let l:column = &columns - g:flocho_width - g:flocho_inset - 1

  let l:opts = {
        \   'relative': 'editor',
        \   'row': s:next_msg_row,
        \   'col': l:column,
        \   'width': g:flocho_width,
        \   'height': l:height,
        \   'style': 'minimal'
        \ }

  let s:next_msg_row += l:height + g:flocho_inset

  let l:bufid = nvim_create_buf(v:false, v:true)
  call nvim_open_win(l:bufid, v:false, l:opts)

  call setbufvar(l:bufid, '&number',         0)
  call setbufvar(l:bufid, '&relativenumber', 0)
  call setbufvar(l:bufid, '&hidden',         1)
  call setbufvar(l:bufid, '&buftype',        'nofile')
  call setbufvar(l:bufid, '&winhighlight',   'Normal:' . get(a:, 1, g:flocho_default_hl))

  call nvim_buf_set_lines(bufid, 0, -1, 0, l:msg_lines)

  let l:opts.bufid = l:bufid
  let l:opts.timerid = timer_start(g:flocho_timeout, function('s:msg_close'), { 'repeat': -1 })
  call add(s:msgs, l:opts)
endfunction
