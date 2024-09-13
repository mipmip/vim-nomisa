let g.nomisa_file_templates = ''
let g.nomisa_extension_handlers = {}
let g.nomisa_extension_handlers.svg = 'inkscape'
let g.nomisa_extension_handlers.png = 'gimp'
let g.nomisa_extension_handlers.jpg = 'gimp'
let g.nomisa_extension_handlers.gif = 'gimp'

" - create dirs if not exist
" - always use current file as path starting point

function! NewOrModifyInSpecializedApplication()

  "find path undercursor
  "let wordUnderCursor = expand("<cword>")
  let currentLine   = getline(".")

 " ![](images/test2.svg)

  if match(currentLine,"(") > 0
    let path = split(currentLine,"(")[1]
    if match(path, ")") > 0
      let path = split(path, ")" )[0]

      let file_ext = fnamemodify(path, ':e')
      echo file_ext

      if filereadable(path)
        echo "SpecificFile exists"
      else
        echo "create file"
        call system("cp tpl960x700.svg " . path )
      endif

      call system("inkscape " . path )

    end
  end


  echo "Edit in inkscape" path
endfunction


