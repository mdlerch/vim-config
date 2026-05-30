--------------------------------------------------------------------------------
-- Helper Utilities Module
-- Purpose: Houses all custom helper functions, statusline generators, and logic.
-- What goes here:
--  * Local state variables used by custom functions (e.g. writing_on, toggle_max_prev).
--  * Custom editing, terminal, layout, and preview launcher functions.
--  * Statusline rendering logic.
-- Functions are returned in a table 'M' to be cleanly required elsewhere.
--------------------------------------------------------------------------------
local M = {}


-- Smart close
function M.smart_close()
    if vim.bo.readonly or not vim.bo.modifiable or vim.fn.expand('%:t:r'):match("test") or vim.bo.filetype == "rdoc" then
        if #vim.fn.filter(vim.fn.range(1, vim.fn.bufnr('$')), 'buflisted(v:val)') <= 1 then
            vim.cmd("quit")
        else
            vim.cmd("bdelete")
        end
        return
    end

    local has_file = vim.fn.expand('%') ~= ""

    if vim.fn.winnr('$') == 1 then
        if has_file then
            vim.cmd("write")
        end
        if #vim.fn.filter(vim.fn.range(1, vim.fn.bufnr('$')), 'buflisted(v:val)') > 1 then
            vim.cmd("bdelete")
        else
            vim.cmd("quit")
        end
    else
        if has_file then
            vim.cmd("write")
        end
        vim.cmd("close")
    end
end

-- convert endlines from dos to unix
function M.dos2unix()
    vim.cmd([[%s/\r//g]])
end

-- place output of vim command into new split
function M.grab(cmd)
    local message = vim.api.nvim_exec(cmd, true)
    vim.cmd("10new")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(message, "\n"))
    vim.bo.modified = false
    vim.bo.readonly = true
end

-- Launchers
local function jobstart(cmd)
    vim.fn.jobstart(cmd)
end

-- Launch PDF
function M.launch_pdf(args)
    local pdfviewer = "zathura"
    local file = args ~= "" and args or (vim.fn.expand("%:r") .. ".pdf")
    jobstart(pdfviewer .. " " .. file .. " 2> /dev/null")
end

-- Launch PNG
function M.launch_png(args)
    local pngviewer = "gpicview"
    local file = args ~= "" and args or (vim.fn.expand("%:r") .. ".png")
    jobstart(pngviewer .. " " .. file .. " 2> /dev/null")
end

-- Launch HTML
function M.launch_html(args)
    local htmlviewer = "chromium"
    local file = args ~= "" and args or (vim.fn.expand("%:r") .. ".html")
    jobstart(htmlviewer .. " " .. file)
end

-- Fuzzy launch
function M.fuzzy_launch(launcher, ext)
    local sourcer = 'find -iname "*.' .. ext .. '"'
    local sinker = launcher
    vim.fn['fzf#run']({
        source = sourcer,
        sink = sinker,
        down = '40%',
        options = '--color dark,pointer:110,hl+:110,bg+:234'
    })
end

-- Smart motion to beginning of line
function M.big_h(vis)
    local oldcol = vim.fn.col('.')
    vim.cmd('norm! g^')
    local newcol = vim.fn.col('.')
    if newcol == oldcol then
        vim.cmd('norm! g0')
    end
    if vis == 1 then
        vim.cmd('norm! m>`>gv')
    end
end

-- Smart motion to end of the line
function M.big_l(vis)
    local oldcol = vim.fn.col('.')
    vim.cmd('norm! g$')
    if vim.fn.getline('.'):sub(vim.fn.col('.'), vim.fn.col('.')):match('%s') then
        vim.cmd('norm! ge')
    end
    local newcol = vim.fn.col('.')
    if newcol == oldcol then
        vim.cmd('norm! g$')
    end
    if vis == 1 then
        vim.cmd('norm! m>`>gv')
    end
end

-- remove trailing whitespace on current line
function M.kill_white_space()
    if vim.bo.modifiable and not vim.bo.readonly then
        local save_query = vim.fn.getreg('/')
        vim.cmd([[s/\s\+$//e]])
        vim.fn.setreg('/', save_query)
    end
end

-- If a buffer named term:// is in a window, jump to it
function M.term_jump()
    for winnum = 1, vim.fn.winnr('$') do
        if vim.fn.bufname(vim.fn.winbufnr(winnum)):match("term://") then
            vim.cmd(winnum .. "wincmd w")
            return
        end
    end
    for bufnum = 1, vim.fn.bufnr('$') do
        if vim.fn.bufname(bufnum):match("term://") then
            vim.cmd("split")
            vim.cmd("buffer " .. vim.fn.bufname(bufnum))
            return
        end
    end
end

-- Toggle maximize a window
local toggle_max_prev = ""
function M.toggle_max()
    if vim.fn.winnr('$') == 1 then
        if vim.fn.tabpagenr('$') == 1 then
            print("Only tab remaining")
            return
        elseif toggle_max_prev == "" then
            print("Not a maximized tab")
        else
            vim.cmd("close")
            vim.cmd("tabn " .. toggle_max_prev)
            toggle_max_prev = ""
        end
    else
        toggle_max_prev = vim.fn.tabpagenr()
        vim.cmd("tab sp")
    end
end

-- WritingToggle
local writing_on = false
local oldtw = 80
function M.writing_toggle()
    if not writing_on then
        oldtw = vim.bo.textwidth
        local mainwindow = vim.fn.winnr()
        local mycolumns = vim.bo.textwidth + vim.wo.numberwidth + vim.wo.foldcolumn
        vim.cmd("vnew padding_test")
        vim.bo.readonly = true
        vim.cmd(mainwindow .. "wincmd w")
        vim.bo.textwidth = 0
        vim.cmd("vertical resize " .. mycolumns)
        writing_on = true
    else
        vim.bo.textwidth = oldtw
        vim.cmd("bdelete padding_test")
        writing_on = false
    end
end

-- List F-keys info
function M.list_f_keys()
    local message = [[
F1 Built-in make (all) 
F2 Built-in clean 
F3 set in project? 
F4 Built-in diff 
F5 WritingToggle 
F6 NONE 
F7 NONE
F8 NONE
F9 close all folds 
F10 open all folds 
F11 redo folding 
F12 re-sync syntax 
]]
    vim.cmd("12new")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(message, "\n"))
    vim.bo.modified = false
    vim.bo.readonly = true
end

-- Statusline generator
function M.set_statusline(winnum)
    local unactive = not (winnum == vim.fn.winnr())

    local function status_color(num, is_unactive)
        local shift = 0
        if is_unactive then
            shift = 3
        end
        return "%" .. (num + shift) .. "*"
    end

    local thefilename = vim.fn.expand('%')
    local statline = ""

    if vim.api.nvim_win_get_width(0) > 100 then
        statline = statline .. status_color(2, unactive)
    end

    statline = statline .. status_color(1, unactive)
    statline = statline .. ' '
    if #thefilename < 30 then
        statline = statline .. '%f '
    else
        statline = statline .. '///%t '
    end

    statline = statline .. status_color(3, unactive)
    statline = statline .. '%R %m '
    statline = statline .. status_color(1, unactive)
    statline = statline .. '%='
    
    if vim.api.nvim_win_get_width(0) > 100 then
        statline = statline .. (vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding)
    end
    
    statline = statline .. ' ' .. status_color(2, unactive) .. ' %Y '
    statline = statline .. status_color(1, unactive)
    
    if vim.api.nvim_win_get_width(0) > 100 then
        statline = statline .. ' %{noscrollbar#statusline(20,"-","=")}'
    end
    
    statline = statline .. ' %5l:%-3c [%L]'
    return statline
end

return M
