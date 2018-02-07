if &cp || (exists('g:loaded_plan_vim') && g:loaded_plan_vim)
  finish
endif
let g:loaded_plan_vim = 1

if !exists("g:PlanPath")
  let g:PlanPath = "~/.plan/"
endif

function! GetCurrentPlanByMonth()
  let planMonth = strftime('%B')
  let planYear = strftime('%Y')
  let planFile = g:PlanPath . planYear . "/" . planMonth . ".md"
  execute 'edit' planFile
endfunction

function! GetCurrentPlanByWeek()
  let planWeek = strftime('%V')
  let planYear = strftime('%Y')
  let planFile = g:PlanPath . planYear . "/week" . planWeek . ".md"
  execute 'edit' planFile
endfunction

command! OpenWeekPlan :call GetCurrentPlanByWeek()
command! OpenMonthPlan :call GetCurrentPlanByMonth()
