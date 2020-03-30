"           ,--,                        ,---,               
"   .--., ,--.'|                      ,--.' |               
" ,--.'  \|  | :     ,---.            |  |  :       ,---.   
" |  | /\/:  : '    '   ,'\           :  :  :      '   ,'\  
" :  : :  |  ' |   /   /   |   ,---.  :  |  |,--. /   /   | 
" :  | |-,'  | |  .   ; ,. :  /     \ |  :  '   |.   ; ,. : 
" |  : :/||  | :  '   | |: : /    / ' |  |   /' :'   | |: : 
" |  |  .''  : |__'   | .; :.    ' /  '  :  | | |'   | .; : 
" '  : '  |  | '.'|   :    |'   ; :__ |  |  ' | :|   :    | 
" |  | |  ;  :    ;\   \  / '   | '.'||  :  :_:,' \   \  /  
" |  : |  |  ,   /  `----'  |   :    :|  | ,'      `----'   
" |  |,'   ---`-'            \   \  / `--''                 
" `--'                        `----'                        
" 
let g:flocho_default_hl = get(g:, 'flocho_default_hl', 'NormalFloat')
let g:flocho_width      = get(g:, 'flocho_width',      -1)
let g:flocho_timeout    = get(g:, 'flocho_timeout',    2500)
let g:flocho_inset      = get(g:, 'flocho_inset',      1)

command! -nargs=1 -complete=highlight Echohl let g:flocho_default_hl = <f-args>
command! -nargs=1 Echo    call flocho#add_message(<q-args>)
command! -nargs=1 Echomsg call flocho#add_message(<q-args>, 'Normal')
command! -nargs=1 Echoerr call flocho#add_message(<q-args>, 'ErrorMsg')
