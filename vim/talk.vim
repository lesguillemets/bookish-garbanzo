let channel=ch_open('localhost:4567', {'mode':'json'})
" call ch_sendraw(channel, 'hi!\n')
nnoremap <space>s :call ch_sendexpr(channel, getline('.'))<CR>
" call ch_close(channel)
