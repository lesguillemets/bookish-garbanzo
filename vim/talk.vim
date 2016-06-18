let channel=ch_open('localhost:4567')
func! MyHandler(channel, msg)
    echom "from the handler: " . a:msg
endfunc
" call ch_sendraw(channel, 'hi!\n')
nnoremap <space>e :call ch_evalexpr(channel, getline('.'))<CR>
nnoremap <space>s :call ch_sendexpr(channel, getline('.'), {'callback':"MyHandler"})<CR>
" call ch_close(channel)
