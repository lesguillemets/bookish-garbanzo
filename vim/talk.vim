let channel=ch_open('localhost:4567', {'mode':'nl'})
" call ch_sendraw(channel, 'hi!\n')
nnoremap <space>s :echo ch_sendexpr(channel, getline('.'))<CR>
" call ch_close(channel)
