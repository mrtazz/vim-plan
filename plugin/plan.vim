command! OpenWeekPlan :call plan#OpenCurrentPlanByWeek()
command! OpenMonthPlan :call plan#OpenCurrentPlanByMonth()
command! OpenYearPlan :call plan#OpenCurrentPlanByYear()

map <leader>pw :OpenWeekPlan<CR>
map <leader>pm :OpenMonthPlan<CR>
map <leader>py :OpenYearPlan<CR>
