" Plugin: mlirview.vim

" Initialize a dictionary to store loc mappings
let g:mlirview_loc_map = {}
let g:mlirview_hl_match_id = -1

" Function to parse loc metadata from lowered MLIR
function! mlirview#ParseLocMap(lowered_file)
  let g:mlirview_loc_map = {}
  let l:line_num = 1
  for l:line in readfile(a:lowered_file)
    if match(l:line, 'loc("') >= 0
      let l:match = matchlist(l:line, 'loc("\zs[^:]*:\zs\d*\ze:')
      if len(l:match) > 1
        let l:source_line = str2nr(l:match[1])
        if !has_key(g:mlirview_loc_map, l:source_line)
          let g:mlirview_loc_map[l:source_line] = []
        endif
        call add(g:mlirview_loc_map[l:source_line], l:line_num)
      endif
    endif
    let l:line_num += 1
  endfor
endfunction

" Function to highlight corresponding lines in the lowered file
function! mlirview#HighlightLowered()
  " Get the current line in the source file
  let l:current_line = line('.')

  " Clear existing highlights
  if g:mlirview_hl_match_id != -1
    call matchdelete(g:mlirview_hl_match_id)
    let g:mlirview_hl_match_id = -1
  endif

  " Highlight corresponding lines in the lowered file
  if has_key(g:mlirview_loc_map, l:current_line)
    let l:lowered_lines = g:mlirview_loc_map[l:current_line]
    for l:line in l:lowered_lines
      let g:mlirview_hl_match_id = matchaddpos('Search', [l:line])
    endfor
  endif
endfunction

" Command to open files side-by-side
command! -nargs=2 MLIRView call mlirview#Open(<f-args>)
function! mlirview#Open(source_file, lowered_file)
  " Parse the loc mappings from the lowered file
  call mlirview#ParseLocMap(a:lowered_file)

  " Open the source file on the left and the lowered file on the right
  execute "edit " . a:source_file
  execute "vsplit " . a:lowered_file

  " Switch back to the source window and set up autocmd
  wincmd h
  autocmd CursorMoved <buffer> call mlirview#HighlightLowered()
endfunction

" Clear highlights on closing files
autocmd BufUnload * call matchdelete(g:mlirview_hl_match_id)
