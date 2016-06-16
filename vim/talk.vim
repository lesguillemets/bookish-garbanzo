let channel=ch_open('localhost:4567', {'mode':'nl'})
call ch_sendraw(channel, 'hi!\n')
" call ch_close(channel)
