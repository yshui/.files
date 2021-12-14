local utils = require 'mp.utils'
function dirname(str)
    if str:match(".-/.-") then
        local name = string.gsub(str, "(.*/)(.*)", "%1")
        local f = string.gsub(str, "(.*/)(.*)", "%2")
        return name, f
    else
        return '.',  str
    end
end
function string:starts(Start)
   return string.sub(self,1,string.len(Start))==Start
end
function load_sub(e)
    local f = mp.get_property("path")
    local dir, f = dirname(f)
    if not f:match(".-%..-") then
        return
    end

    local pre = string.gsub(f, "(.*)%.(.*)", "%1")

    d = utils.readdir(dir)
    if d == nil then
        return
    end
    for _, x in pairs(d) do
        -- check ext
        if x:match(".-%..-") then
            local ext = string.gsub(x, ".*%.", "")
            -- print(x, ext)
            if (ext == "ass" or ext == "srt" or ext == "ssa") and
               x:starts(pre) then
               mp.commandv("sub-add", dir.."/"..x)
               return
           end
        end
    end
end

mp.register_event("start-file", load_sub)
