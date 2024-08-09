let mapleader=" "

nnoremap <leader>h :h<Space>

vnoremap <leader>y "+y
vnoremap <leader>Y "+Y
vnoremap <leader>d "_d
vnoremap <leader>D "_D

nnoremap <silent> <Tab> >>
nnoremap <silent> <S-Tab> <<
xnoremap <silent> <Tab> >gv
xnoremap <silent> <S-Tab> <gv

nnoremap <silent> <C-S> :w<CR><Esc>
inoremap <silent> <C-S> <Esc>:w<CR>gi
vnoremap <silent> <C-S> <Esc>:w<CR>gv

nnoremap <silent> <C-Q> :q<CR>
inoremap <silent> <C-Q> <Esc>:q<CR>
xnoremap <silent> <C-Q> <Esc>:q<CR>

nnoremap <silent> <C-J> :m .+1<CR>==
nnoremap <silent> <C-K> :m .-2<CR>==
xnoremap <silent> <C-J> :m '>+1<CR>gv
xnoremap <silent> <C-K> :m '<-2<CR>gv

noremap <silent> <C-/> :set list!<CR>
noremap <silent> <C-\> :set wrap!<CR>
noremap <silent> <leader><Esc> :nohl<CR>

noremap <leader>bb :b#<CR>
noremap <leader>bd :bd<CR>
noremap <leader>bp :bp<CR>
noremap <leader>bn :bn<CR>

noremap gn :edit<Space>
noremap <silent> gb :Buffers<CR>
noremap <silent> <C-N> :Files<CR>
noremap <silent> <C-P> :GFiles<CR>
noremap <silent> <C-G> :GFiles?<CR>

noremap <C-W><C-K> :resize -5<CR>
noremap <C-W><C-J> :resize +5<CR>
noremap <C-W><C-H> :vertical resize -5<CR>
noremap <C-W><C-L> :vertical resize +5<CR>

