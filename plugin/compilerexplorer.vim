" compilerexplorer.vim - TODO
" Maintainer:   Matthias Kretz <m.kretz@gsi.de>
" Version:      1.0

let s:root_path = resolve(expand("<sfile>:p:h:h"))

function! s:ApplyCompileSettings()
    let g:COMPILER_EXPLORER_COMPILER = substitute(getbufline('Compiler Settings', 1)[0], '^Compiler: *', '', '')
    let g:COMPILER_EXPLORER_MCA = substitute(getbufline('Compiler Settings', 2)[0], '^MCA: *', '', '')
endfunction

function! s:CompileSettings()
    silent topleft split Compiler Settings
    silent resize 2
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal winfixheight
    let l:old_undolevels = &undolevels
    set undolevels=-1
    normal ggdG
    if exists('g:COMPILER_EXPLORER_COMPILER')
        silent exec ":normal iCompiler: " . g:COMPILER_EXPLORER_COMPILER
    else
        silent exec ":normal iCompiler: $CXX -S -masm=intel -O2 -std=c++17 -march=skylake-avx512"
    endif
    if exists('g:COMPILER_EXPLORER_MCA')
        silent exec ":normal oMCA: " . g:COMPILER_EXPLORER_MCA
    else
        silent exec ":normal oMCA: llvm-mca --mcpu=sandybridge"
    endif
    let &undolevels = l:old_undolevels
    inoremap <buffer> <CR> <ESC>:call <SID>Compile()<CR>
    nnoremap <buffer> o i
    nnoremap <buffer> O i
    nnoremap <buffer> dd 0d$
    autocmd CursorMoved,CursorMovedI <buffer> call s:BoundedMovement()
endfunction

function! s:BoundedMovement()
    let l:prefix_offsets = [11, 6]
    let l:pos = getpos('.')
    let l:line = getline('.')
    let l:min_col = l:prefix_offsets[l:pos[1] - 1]
    if l:pos[1] == 1
        if l:line !~ '^Compiler: '
            silent substitute/^[Compiler: ]*/Compiler: /
            silent call cursor(l:pos[1], l:min_col)
        endif
    else
        if l:line !~ '^MCA: '
            silent substitute/^[MCA: ]*/MCA: /
            silent call cursor(l:pos[1], l:min_col)
        endif
    endif
    if l:pos[2] < l:min_col
        silent call cursor(l:pos[1], l:min_col)
    endif
endfunction

function! s:Compile()
    cclose
    silent call s:ApplyCompileSettings()
    echo "Compiling. Please wait."
    redraw

    let l:id = win_gotoid(bufwinid(s:buf_name))
    silent vertical leftabove split log
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    normal ggdG

    "Start g:COMPILER_EXPLORER_COMPILER . " -x c++ -o - - | egrep -v -e '^\\s+\\.(weak|align|hidden|section|type|file|text|p2align|cfi|size|globl|ident)' -e '^.LF' > ce.tmp"
    silent let l:tmp = append(line('$'), systemlist(g:COMPILER_EXPLORER_COMPILER . " -x c++ -o - - | egrep -v -e '^\\s+\\.(weak|align|hidden|section|type|file|text|p2align|cfi|size|globl|ident)' -e '^.LF' > ce.tmp", bufnr(s:buf_name)))
    silent let l:tmp = append(line('$'), systemlist(g:COMPILER_EXPLORER_COMPILER . " -x c++ -o - - | egrep -v -e '^\\s+\\.(weak|align|hidden|section|type|file|text|p2align|cfi|size|globl|ident)' -e '^.LF' > ce.tmp", bufnr(s:buf_name)))
    silent exec ":%s/^<stdin>/ce.cpp/e"
    silent let l:tmp = append(line('$'), systemlist("awk -f ".s:root_path."/ce.awk ce.tmp | c++filt > ce.asm"))
    silent let l:tmp = append(line('$'), systemlist("sed -n '/ret/q;p' ce.tmp | " . g:COMPILER_EXPLORER_MCA . " > ce.mca"))
    silent !rm ce.tmp
    "silent let l:tmp = append(line('$'), systemlist("rm ce.tmp"))
    if getline(1, '$') == ['']
        bdelete
    else
        cbuffer
        let l:id = win_getid()
        botright copen
        silent resize 10
        setlocal winfixheight
        let l:id = win_gotoid(l:id)
    endif
    redraw!
endfunction

function! s:CompilerExplorer()
    if exists('s:buf_name')
        call s:Compile()
    else
        silent tabedit ce.cpp
        let s:buf_name = bufname("%")
        setlocal noswapfile
        "autocmd CursorHold <buffer> call s:Compile()

        silent vertical botright split ce.asm
        silent vertical resize 80
        setlocal autoread
        setlocal ro
        setlocal noswapfile
        setlocal nobuflisted
        setlocal nomodifiable
        setlocal wrap
        setlocal winfixwidth
        setlocal nospell

        silent vertical botright split ce.mca
        silent vertical resize 100
        setlocal autoread
        setlocal ro
        setlocal noswapfile
        setlocal nobuflisted
        setlocal nomodifiable
        setlocal nowrap
        setlocal winfixwidth
        setlocal nospell

        call s:CompileSettings()
        let l:id = win_gotoid(bufwinid(s:buf_name))
    endif
endfunction

nmap <silent> <F6> :call <SID>CompilerExplorer()<CR>

" vim: sw=4 et ai
