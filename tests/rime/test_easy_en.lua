package.path = "./Rime/lua/?.lua;./Rime/lua/?/init.lua;" .. package.path

local easy_en = require("easy_en")

local function same_values(actual, expected, label)
    table.sort(actual)
    table.sort(expected)
    if #actual ~= #expected then
        error(label .. ": expected [" .. table.concat(expected, ", ") .. "] but got [" .. table.concat(actual, ", ") .. "]")
    end
    for index, value in ipairs(expected) do
        if actual[index] ~= value then
            error(label .. ": expected [" .. table.concat(expected, ", ") .. "] but got [" .. table.concat(actual, ", ") .. "]")
        end
    end
end

local function translate(input, entries, limit)
    local memory = { entries = {}, lookup_header = nil, lookup_limit = nil }
    function memory:dict_lookup(header, _, lookup_limit)
        self.lookup_header = header
        self.lookup_limit = lookup_limit
        self.entries = {}
        for _, entry in ipairs(entries) do
            local code = entry.comment
            if code:lower():sub(1, #header) == header:lower() then
                local suffix = code:sub(#header + 1)
                table.insert(self.entries, {
                    text = entry.text,
                    comment = suffix == "" and "" or "~" .. suffix,
                })
                if lookup_limit > 0 and #self.entries >= lookup_limit then break end
            end
        end
    end
    function memory:iter_dict()
        local index = 0
        return function()
            index = index + 1
            return self.entries[index]
        end
    end

    local segment = { start = 0, _end = #input }
    function segment:has_tag()
        return false
    end
    local composition = {}
    function composition:empty()
        return false
    end
    function composition:back()
        return segment
    end

    local results = {}
    _G.yield = function(candidate)
        table.insert(results, candidate)
    end
    _G.Phrase = function(_, _, _, _, entry)
        return {
            comment = entry.comment,
            toCandidate = function(self)
                return { text = entry.text, comment = self.comment }
            end,
        }
    end

    local env = {
        engine = {
            schema = { schema_id = "easy_en" },
            context = { composition = composition },
        },
        tag = "easy_en",
        prompt = "英文",
        wildcard = "*",
        expand_word_count = limit or 666,
        mem = memory,
    }
    easy_en.translator.func(input, { start = 0, _end = #input }, env)

    local words = {}
    for _, candidate in ipairs(results) do
        table.insert(words, candidate.text:lower())
    end
    return words, memory
end

local entries = {
    { text = "GLOB", comment = "GLOB" },
    { text = "glooooob", comment = "glooooob" },
    { text = "grab", comment = "grab" },
    { text = "grub", comment = "grub" },
    { text = "gxbfooob", comment = "gxbfooob" },
    { text = "globe", comment = "globe" },
    { text = "global", comment = "global" },
    { text = "glo", comment = "glo" },
    { text = "gøb", comment = "gøb" },
    { text = "gøøb", comment = "gøøb" },
    { text = "g+b", comment = "g+b" },
    { text = "g++b", comment = "g++b" },
    { text = "gxb", comment = "gxb" },
}

local glob_results, glob_memory = translate("g*l*b", entries, 300)
same_values(glob_results, { "glob", "glooooob" }, "g*l*b full match")
assert(glob_memory.lookup_header == "g", "g*l*b must look up from its first wildcard prefix")
assert(glob_memory.lookup_limit == 300, "wildcard search must preserve the configured lookup limit")

local double_star = translate("g**b", entries)
local single_star = translate("g*b", entries)
same_values(double_star, single_star, "g**b must behave like g*b")

local plain_results, plain_memory = translate("glob", entries)
-- The table translator supplies ordinary completion. This Lua path
-- leaves exact matches alone when Rime supplies an empty comment.
same_values(plain_results, {}, "plain glob leaves completion to the table translator")
assert(plain_memory.lookup_header == "glob", "plain completion must keep its original lookup prefix")
assert(plain_memory.lookup_limit == 666, "default lookup limit must remain 666")

local question_results, question_memory = translate("glo?", entries)
same_values(question_results, { "glob" }, "glo? must match one character only")
assert(question_memory.lookup_header == "glo", "glo? must look up from the first wildcard")

local mixed_results, mixed_memory = translate("g?o*", entries)
same_values(mixed_results, { "glo", "glob", "globe", "global", "glooooob" }, "g?o* must match one then zero-or-more characters")
assert(mixed_memory.lookup_header == "g", "prefix lookup must stop before the first wildcard")

local unicode_results = translate("g?b", entries)
same_values(unicode_results, { "g+b", "gxb", "gøb" }, "? must consume one Unicode character")

local literal_results = translate("g+*b", entries)
same_values(literal_results, { "g+b", "g++b" }, "Lua pattern metacharacters must stay literal")

print("PASS easy_en translator multi-star regression")
