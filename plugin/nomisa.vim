let s:plugin_path = fnamemodify( fnamemodify(resolve(expand('<sfile>:p')), ':h') , ':h')

let g:nomisa_templates_path = s:plugin_path . '/nomisa_templates/'
let g:nomisa_extension_handlers = {}
let g:nomisa_extension_handlers.svg = 'inkscape'
let g:nomisa_extension_handlers.png = 'gimp'
let g:nomisa_extension_handlers.jpg = 'gimp'
let g:nomisa_extension_handlers.gif = 'gimp'

function s:getExtensionHandler(extension)
  if has_key(g:nomisa_extension_handlers, a:extension)
    return  g:nomisa_extension_handlers[a:extension]
  endif
  return ''
endfunction

function s:getTemplateFile(extension)

  let tplfiles = split(glob(g:nomisa_templates_path .a:extension . "/*." . a:extension), '\n')
  if len(tplfiles) == 0
    echo "Nomisa: no template file found for " . a:extension
    return ""
  elseif len(tplfiles) == 1
    return tplfiles[0]
  else
    return tplfiles[0]
  end
endfunction

function s:openTemplate(path)
  let path = a:path
  let root_dir = expand('%:h')
    let file_path = root_dir . '/' . path
    let file_dir = fnamemodify(file_path, ':h')
    let file_ext = tolower(fnamemodify(path, ':e'))

    if !filereadable(file_path)
      if !isdirectory(file_dir)
        call system("mkdir -p " . file_dir)
      endif

      let tpl_file = s:getTemplateFile(file_ext)
      if( tpl_file != "")
        call system("cp " . tpl_file  . " " . file_path )
      endif
    endif

    if filereadable(file_path)
      let handler = s:getExtensionHandler(file_ext)
      if handler != ''
        call system( handler ." " . file_path )
      endif
    end

endfunction

"test/images.svg"

function! NewOrModifyInSpecializedApplicationVS()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) != 1
      echom "Select one line containing a valid file path"
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    echom join(lines, "\n")

    let path = join(lines, "\n")

    call s:openTemplate(path)

endfunction

"![](test/images.svg)"
function! NewOrModifyInSpecializedApplication()

  let currentLine   = getline(".")

  if match(currentLine,"(") > 0
    let path = split(currentLine,"(")[1]
    if match(path, ")") > 0

      let path = split(path, ")" )[0]
      call s:openTemplate(path)

    end
  end
endfunction

command! Nomisa :call NewOrModifyInSpecializedApplication()
command! NomisaVisSel :call NewOrModifyInSpecializedApplicationVS()
