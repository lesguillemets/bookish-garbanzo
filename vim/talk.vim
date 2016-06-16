let channel=ch_open('localhost:4567', {'mode':'json'})
" call ch_sendraw(channel, 'hi!\n')
call ch_sendexpr(channel, getline('.'))
" call ch_close(channel)
