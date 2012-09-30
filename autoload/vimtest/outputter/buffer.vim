" AUTHOR: kanno <akapanna@gmail.com>
" License: This file is placed in the public domain.
let s:save_cpo = &cpo
set cpo&vim

let s:outputter = {
\   'config': {
\     'name'     : '[vimtest]',
\     'filetype' : 'vimtest',
\     'append'   : 0,
\     'split'    : 'split',
\   }
\ }

function! s:outputter.init()
  let self._append = self.config.append
  let self.config.split = winwidth(0) * 2 < winheight(0) * 5 ? "split" : "vertical split"
endfunction

function! s:outputter.out(runners)
  let winnr = winnr()
  call s:open_result_window(self.config)
  if !self._append
    silent % delete _
  endif

  call self.output(a:runners)

  execute winnr 'wincmd w'
endfunction

function! s:outputter.output(runners)
  let str = vimtest#outputter#string#new()
  let data = str.out(a:runners)
  silent $ put = data
endfunction

function! s:open_result_window(config)
  let sname = s:escape_file_pattern(a:config.name)
  if !bufexists(a:config.name)
    execute a:config.split
    edit `=a:config.name`
    nnoremap <buffer> q <C-w>c
    setlocal bufhidden=hide buftype=nofile noswapfile nobuflisted
  elseif bufwinnr(sname) != -1
    execute bufwinnr(sname) 'wincmd w'
  else
    execute a:config.split
    execute 'buffer' bufnr(sname)
  endif
  if &l:filetype !=# a:config.filetype
    let &l:filetype = a:config.filetype
  endif
endfunction

function! s:escape_file_pattern(pat)
  return join(map(split(a:pat, '\zs'), '"[".v:val."]"'), '')
endfunction

function! vimtest#outputter#buffer#new()
  return deepcopy(s:outputter)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
