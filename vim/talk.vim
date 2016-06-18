let channel=ch_open('localhost:4567')
" call ch_sendraw(channel, 'hi!\n')
nnoremap <space>s :echo ch_evalexpr(channel, getline('.'))<CR>
" call ch_close(channel)
