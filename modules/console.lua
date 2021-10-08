getgenv().console_enabled = getgenv().console_enabled == nil and true or getgenv().console_enabled

local console = {
    print = {color = 'white'};
    error = {color = 'red'};
    warn = {color = 'brown'};
    info = {color = 'light_magenta'};
    hook = {color = 'cyan'};
    success = {color = 'light_green'};
}
local consoletext = {}

local function consoleprint(str)
    if console_enabled then
        table.insert(consoletext,#consoletext+1,str)
        rconsoleprint(str)
    end
end

for i,v in next, console do
    setmetatable(v,{
        __call = function(t,str,noprefix)
            consoleprint('@@'..v.color:upper()..'@@')
            consoleprint('\n '..(noprefix == true and tostring(str) or '['..os.date("%X",os.time())..'] ['..i..'] | '..tostring(str)))
        end;
    })
end

return console, consoletext
