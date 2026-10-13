-- helper.lua
-- List features and usage of the schema.
local T = {}

function T.func(input, seg, env)
    local composition = env.engine.context.composition
    local segment = composition:back()
    if seg:has_tag("flypy_help") then
        local table = {
            { "帮助菜单", "→ /oh" },
            { "小鹤键位", "→ /ok" },
            { "以词定字", "→ 9首字 | 0尾字" },
            { "上下翻页", "→ .下一页 | ,上一页" },
            { "二候选", "→ ;键" },
            { "组字反查", "→ `L" },
            { "LaTeX 式", "→ lT" },
            { "选项切换", "→ /so | sO" },
            { "中文数字", "→ /nn | nN | oN (例: /nn123.45)" },
            { "计算器🆚", "→  =  | cC" },
            { "全角半角", "→ Ctrl+." },
            { "中英标点", "→ Ctrl+," },
            { "单字优先", "→ Ctrl+s (候选菜单中且编码为3–4个小写字母)" },
            { "声调筛选", "→ ni/I | ni/U | ni/N | ni/M (大写)" },
            { "词条置顶", "→ Ctrl+t" },
            { "词条降频", "→ Ctrl+j" },
            { "词条隐藏", "→ Ctrl+x" },
            { "词条删除", "→ Ctrl+d" },
            { "候选降权", "→ Ctrl+k" },
            { "注解切换", "→ Ctrl+n" },
            { "符号菜单", "→ /vs | Ctrl+p 返回" },
            { "EasyDict", "→ Ctrl+y" },
            { "切换英打", "→ Ctrl+g" },
            { "简拼展开", "→ 8" },
            { "表😂显隐", "→ Ctrl+Shift+4" },
            { "繁简切换", "→ Ctrl+Shift+5" },
            { "码区提示", "→ Ctrl+Shift+6" },
            { "中文造词", "→ grave(`)键" },
            { "英文造词", "→ asciitilde(~)键" },
            { "自由造词", "→ `=键(abcd`=xyz)" },
            { "方案选单", "→ Ctrl+grave(`)" },
            { "单词大写", "→ AZ 开头大写字母触发" },
            { "原始上屏", "→ Return | Ctrl+m" },
            { "转换后上屏", "→ Shift+Return" },
            { "上屏注解", "→ Ctrl+Shift+Return" },
            { "音节移动", "→ Tab / Shift+Tab" },
            { "临时英打", "→ 左 Shift" },
            { "邮箱后缀", "→ @ 键" },
            { "时间戳值", "→ timestamp | ots | /wts | /uts" },
            { "日期", "→ date | orq | /wd" },
            { "时间", "→ time | osj | /wt" },
            { "星期", "→ week | oxq | /wk" },
            { "农历", "→ /nl | nL | cL" },
            { "最近几天", "→ /wqt | /wzt | /wmt | /wht" },
            { "最近几周", "→ /wuz | /wlk | /wxz | /wnk" },
            { "最近几月", "→ /wuy | /wlm | /wxy | /wnm" },
            { "项目地址", "→ boomker/rime-fast-xhup" },
        }
        segment.prompt = "〔帮助菜单〕"
        for _, v in ipairs(table) do
            local cand = Candidate("help", seg.start, seg._end, v[1], " " .. v[2])
            cand.quality = 999
            yield(cand)
        end
    end
end

return T
