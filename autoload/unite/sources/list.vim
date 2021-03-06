" unite source: list
"
" File: autoload/unite/sources/list.vim
" Version: 0.1
" License: MIT License {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

let s:save_cpo = &cpo
set cpo&vim

let s:source = {
      \ 'name' : 'list',
      \ 'description' : 'Vim list',
      \ 'syntax': 'uniteSource__list',
      \ 'action_table' : {},
      \ 'hooks': {},
      \ 'default_action' : 'yank_and_exit',
      \ }

function! s:source.gather_candidates(args, context)
  let list_name=get(a:args, 0, '')
  let s:return_row=get(a:args, 1, '')
  exe 'let list=g:'.list_name
  " call confirm (get(a:args, 0, ''))
  let candidates = []

  let row=0
  for elt in list
    let row+=1
    call add(candidates, {
          \ 'word': elt,
          \ 'source__row': row,
          \})
  endfor

  return candidates
endfunction

" Hooks {{{
function! s:source.hooks.on_syntax(args, context)
  " call confirm('hook')
endfunction
" }}}

" Actions {{{
let s:source.action_table.yank_and_exit = {
      \ 'description': 'Yank to register u',
      \ }
function! s:source.action_table.yank_and_exit.func(candidate)
  if s:return_row
    let @u=a:candidate.source__row
  else
    let text=a:candidate.word
    " echohl Question | echo 'In @u:' | echohl Normal
    " echo text
    let @u=text
  endif
endfunction

" }}}

function! unite#sources#list#define()
  return s:source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set fdm=marker:
