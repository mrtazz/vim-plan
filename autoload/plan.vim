if &cp || (exists('g:loaded_plan_vim') && g:loaded_plan_vim)
  finish
endif
let g:loaded_plan_vim = 1


let g:PlanBaseDir = get(g:, 'PlanBaseDir', $HOME . "/.plan")
let g:PlanTemplatePath = get(g:, 'PlanTemplatePath', "/templates/")


" set up some directory definitions
let s:dailiesDirectory = g:PlanBaseDir . "/dailies"
let s:notesDirectory = g:PlanBaseDir . "/notes"


function! plan#OpenDailyNote()
  let today = strftime("%Y%m%d")
  call plan#EnsureDirectoryExists(s:dailiesDirectory)
  let plan = s:dailiesDirectory . "/" . today . ".md"
  execute 'edit' plan
  if !filereadable(plan)
    "read in the template file if available
    let tmplPath = g:PlanTemplatePath . "daily"
    if filereadable(tmplPath)
      execute 'read ' . tmplPath
      call plan#replaceTemplateVariables()
    endif
  endif
  call plan#setupBuffer()
endfunction

function! plan#OpenNote()
  let note = strftime("%Y%m%d-%H%M%S")
  call plan#EnsureDirectoryExists(s:notesDirectory)
  let plan = s:notesDirectory . "/" . note . ".md"
  execute 'edit' plan
  call plan#setupBuffer()
endfunction



function! plan#replaceTemplateVariables()
  " replace occurrences of DATE with the actual date
  let thedate = strftime("%m\\/%d\\/%Y")
  silent exe "1,$g/%%DATE%%/s/%%DATE%%/" . thedate

  " replace occurrences of WEEKDAY with the current weekday
  let weekday = strftime("%A")
  silent exe "1,$g/%%WEEKDAY%%/s/%%WEEKDAY%%/" . weekday

  " replace occurrences of MONTH with the current month
  let month = strftime("%B")
  silent exe "1,$g/%%MONTH%%/s/%%MONTH%%/" . month

  " replace occurrences of YEAR with the current year
  let year = strftime("%Y")
  silent exe "1,$g/%%YEAR%%/s/%%YEAR%%/" . year

  " replace occurrences of WEEKNUMBER with the current weeknumber
  let weeknumber = strftime("%V")
  silent exe "1,$g/%%WEEKNUMBER%%/s/%%WEEKNUMBER%%/" . weeknumber

  "if the cursor was previously on a blank line, delete it
  if getline(line(".")-1) =~ '^\s*$'
      exec line(".")-1 . 'd'
  endif
endfunction

function! plan#GetCurrentPlanByYear()
  let planYear = strftime('%Y')
  let planFile = g:PlanBaseDir . planYear . "/year.md"
  call plan#EnsureDirectoryExists(g:PlanBaseDir . planYear)
  return planFile
endfunction

function! plan#GetCurrentPlanByMonth()
  let planMonth = strftime('%B')
  let planMonthNumber = strftime('%m')
  let planYear = strftime('%Y')
  let planFile = g:PlanBaseDir . planYear . "/" . planMonthNumber . '-' .planMonth . ".md"
  call plan#EnsureDirectoryExists(g:PlanBaseDir . planYear)
  return planFile
endfunction

function! plan#GetCurrentPlanByWeek()
  let planWeek = strftime('%V')
  let planYear = strftime('%Y')
  let planFile = g:PlanBaseDir . planYear . "/weeks/" . planWeek . ".md"
  call plan#EnsureDirectoryExists(g:PlanBaseDir . planYear . "/weeks")
  return planFile
endfunction

function! plan#OpenCurrentPlanByWeek()
  let plan = plan#GetCurrentPlanByWeek()
  execute 'edit' plan
  if !filereadable(plan)
    "read in the template file if available
    let tmplPath = g:PlanTemplatePath . "week"
    if filereadable(tmplPath)
      execute 'read ' . tmplPath
      call plan#replaceTemplateVariables()
    endif
  endif
  call plan#setupBuffer()
endfunction

function! plan#OpenCurrentPlanByMonth()
  let plan = plan#GetCurrentPlanByMonth()
  execute 'edit' plan
  if !filereadable(plan)
    "read in the template file if available
    let tmplPath = g:PlanTemplatePath . "month"
    if filereadable(tmplPath)
      execute 'read ' . tmplPath
      call plan#replaceTemplateVariables()
    endif
  endif
  call plan#setupBuffer()
endfunction

function! plan#OpenCurrentPlanByYear()
  let plan = plan#GetCurrentPlanByYear()
  execute 'edit' plan
  if !filereadable(plan)
    " read in the template file if available
    let tmplPath = g:PlanTemplatePath . "year"
    if filereadable(tmplPath)
      execute 'read ' . tmplPath
      call plan#replaceTemplateVariables()
    endif
  endif
  call plan#setupBuffer()
endfunction

function! plan#Today()
  let today = strftime("%A %m\/%d\/%Y")
  exe "normal a". today
endfunction

function! plan#EnsureDirectoryExists(dir)
  if !isdirectory(a:dir)
    call mkdir(a:dir, "p")
  endif
endfunction

function! plan#setupBuffer()
  execute 'lcd' g:PlanBaseDir
endfunction
