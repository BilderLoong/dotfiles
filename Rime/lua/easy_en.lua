--[[
ecdict: 把ECDICT.dict.yaml里的text作为comment，code作为text输出
--]]

require("lib/string")
local easy_en = {}

local function escape_lua_pattern(literal)
    return literal:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
end

local function prepare_glob(input)
    local star_start = input:find("*", 1, true)
    local one_start = input:find("?", 1, true)
    if not star_start and not one_start then return nil end

    local wildcard_start = star_start
    if one_start and (not wildcard_start or one_start < wildcard_start) then
        wildcard_start = one_start
    end
    local prefix = input:sub(1, wildcard_start - 1)
    if not prefix:match("^[a-zA-Z]") then return nil end

    local tokens = {}
    for _, codepoint in utf8.codes(input:lower()) do
        local character = utf8.char(codepoint)
        if character == "*" then
            table.insert(tokens, { kind = "many" })
        elseif character == "?" then
            table.insert(tokens, { kind = "one" })
        else
            table.insert(tokens, { kind = "literal", pattern = escape_lua_pattern(character) })
        end
    end
    return { prefix = prefix, tokens = tokens }
end

local function utf8_characters(value)
    local characters = {}
    for _, codepoint in utf8.codes(value) do
        table.insert(characters, utf8.char(codepoint))
    end
    return characters
end

local function glob_matches(glob, value)
    local characters = utf8_characters(value:lower())
    local matched = {}

    local function match_from(pattern_index, character_index)
        local pattern_matches = matched[pattern_index]
        if pattern_matches and pattern_matches[character_index] ~= nil then
            return pattern_matches[character_index]
        end
        pattern_matches = pattern_matches or {}
        matched[pattern_index] = pattern_matches

        local token = glob.tokens[pattern_index]
        local result
        if not token then
            result = character_index > #characters
        elseif token.kind == "many" then
            result = match_from(pattern_index + 1, character_index)
                or (characters[character_index] ~= nil and match_from(pattern_index, character_index + 1))
        else
            local character = characters[character_index]
            result = character ~= nil
                and character:match("^" .. token.pattern .. "$") ~= nil
                and match_from(pattern_index + 1, character_index + 1)
        end

        pattern_matches[character_index] = result
        return result
    end

    return match_from(1, 1)
end

local function truncate_comment(comment)
    local MAX_LENGTH = 30
    if utf8.len(comment) > MAX_LENGTH then
        local comment_text = string.utf8_sub(comment, 1, MAX_LENGTH)
        comment_text = comment_text and comment_text:gsub("[;,.=(%a ]+$", "")
        return comment_text
    end
    return comment:gsub("[;,.=(%a ]+$", "")
end

function easy_en.init(env)
    local config = env.engine.schema.config
    local easy_en_schema = Schema("easy_en") -- schema_id
    env.tag = config:get_string("easy_en/tag") or "easy_en"
    env.prompt = config:get_string("easy_en/tips") or "英文"
    env.wildcard = config:get_string("easy_en/wildcard") or "*"
    env.mem = Memory(env.engine, easy_en_schema, "translator")
    env.expand_word_count = config:get_int("easy_en/word_search_limit") or 666
    env.en_comment_overwrite = config:get_bool("easy_en-ecdict/overwrite_comment") or false
    env.easydict_translate_key = config:get_string("key_binder/easydict_translate") or "Control+y"
end

function easy_en.fini(env)
    if env.mem then
        env.mem:disconnect()
        env.mem = nil
        collectgarbage('collect')
    end
end

function easy_en.processor(key, env)
    local engine = env.engine
    local context = engine.context
    local composition = context.composition
    if composition:empty() then return 2 end

    if context:has_menu() and (key:repr() == env.easydict_translate_key) then
        local cand = context:get_selected_candidate()
        local cand_text = cand.text:gsub("%p ", "")
        local osascript = "open " .. "easydict://query?text=" .. cand_text
        os.execute(osascript)

        context:clear()
        return 1
    end
    return 2
end

function easy_en.translator(input, seg, env)
    local engine = env.engine
    local schema = engine.schema
    local composition = engine.context.composition
    if composition:empty() then
        return
    end
    local segment = composition:back()
    local glob = prepare_glob(input)
    if input:find("*", 1, true) and not glob then return end

    if segment:has_tag(env.tag) or (schema.schema_id == "easy_en") or glob then
        if not (schema.schema_id == "easy_en") then
            segment.prompt = "〔" .. env.prompt .. "〕"
        end
        local tailer
        local header
        if glob then
            header = glob.prefix
        else
            tailer = string.match(input, "[^" .. env.wildcard .. "]+$") or ""
            header = string.match(input, "^[^" .. env.wildcard .. "]+")
        end
        env.mem:dict_lookup(header, true, env.expand_word_count) -- expand_search
        for dictentry in env.mem:iter_dict() do
            local matches
            if glob then
                matches = glob_matches(glob, dictentry.comment)
            else
                local code_tail = string.match(dictentry.comment:lower(), tailer .. "$") or ""
                matches = tailer and (code_tail == tailer)
            end
            if matches then
                local ph = Phrase(env.mem, "expand_en_word", seg.start, seg._end, dictentry)
                ph.comment = dictentry.comment:lower()
                yield(ph:toCandidate())
            end
        end
    end
end

function easy_en.filter(input, env)
    local en_cands = {}
    local separator = " 🔎 "
    local engine = env.engine
    local schema = engine.schema

    for cand in input:iter() do
        if schema.schema_id == "easy_en" then
            local comment = truncate_comment(cand.comment)
            cand.comment = separator .. comment
            table.insert(en_cands, cand)
        else
            yield(cand)
        end
        if #en_cands >= env.expand_word_count then break end -- 防止候选太多, 输入卡顿
    end

    for _, cand in ipairs(en_cands) do
        yield(cand)
    end
end

return {
    processor = { init = easy_en.init, func = easy_en.processor, fini = easy_en.fini },
    translator = { init = easy_en.init, func = easy_en.translator, fini = easy_en.fini },
    filter = { init = easy_en.init, func = easy_en.filter, fini = easy_en.fini },
}
