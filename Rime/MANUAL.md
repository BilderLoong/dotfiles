# Rime manual: 飞鹤快拼

This manual describes this local configuration, not every feature in the upstream project.
The base project is [boomker/rime-fast-xhup](https://github.com/boomker/rime-fast-xhup).

The reference files are the schema, its custom patch, the global settings, and the active Lua modules.
The deployed settings in `~/Library/Rime/build/` also served as a check.
Examples were checked with the installed Rime engine in a separate test folder.
The tests did not use your live user dictionaries.

## Contents

1. [Quick start](#1-quick-start)
2. [Current setup](#2-current-setup)
3. [Select and edit text](#3-select-and-edit-text)
4. [Chinese input and shape codes](#4-chinese-input-and-shape-codes)
5. [English input and word creation](#5-english-input-and-word-creation)
6. [Candidate records](#6-candidate-records)
7. [Prefixes and commands](#7-prefixes-and-commands)
8. [Date, time, and lunar date](#8-date-time-and-lunar-date)
9. [Chinese numbers](#9-chinese-numbers)
10. [Calculator](#10-calculator)
11. [Symbols, emoji, and paired punctuation](#11-symbols-emoji-and-paired-punctuation)
12. [LaTeX snippets](#12-latex-snippets)
13. [Options and display](#13-options-and-display)
14. [Prediction](#14-prediction)
15. [Files, changes, and deployment](#15-files-changes-and-deployment)
16. [Inactive features and known limits](#16-inactive-features-and-known-limits)
17. [Source map](#17-source-map)
18. [Full symbol-code reference](#18-full-symbol-code-reference)

## 1. Quick start

1. Select the macOS **鼠须管 / Squirrel** input method.
2. Make sure Rime is in Chinese mode, shown as **中**.
3. Type `nihc`.
4. Select **你好** from the candidate list.
5. Push `Space` to insert the selected text.

A **candidate** is a text item that Rime offers for your input.
The **input code** is the text you type before you select a candidate.
**Commit** means insert the selected text into the application.

| Task | Input or key | Example |
|---|---|---|
| Chinese word | Xiaohé double-pinyin | `nihc` → `你好` |
| One character with shape codes | Two pronunciation keys, `/`, shape keys | `ni/rx` → `你` |
| Help | `/oh` or `oH` | Shows a reference list |
| Rime options | `Ctrl` + backtick | Opens `方案选单` |
| Local configuration menu | `/so` or `sO` | Shows display and input options |
| Date | `date` | Shows several date formats |
| Time | `time` | Shows several time formats |
| Calculator | `=` or `cC` | `=1+2` → `3` |
| Symbols | `/vs` | Shows symbol categories |
| Switch to the English schema | `Ctrl+g` during input | Type `hello`, then push `Ctrl+g` |

**Key names:** `Ctrl` means the Control key, not the Command key.
`Return` means Enter.
A backtick is `` ` ``.
An apostrophe is `'`.
Uppercase prefixes are case-sensitive. For example, use `nL`, not `nl`.

## 2. Current setup

| Item | Local setting |
|---|---|
| Main schema | `flypy_xhfast`, displayed as `飞鹤快拼` |
| Input method | Xiaohé double-pinyin plus shape codes |
| Candidate page | Five items |
| Candidate layout | Stacked list with horizontal text |
| Schema font setting | `25` points |
| Input-code display | Double-pinyin, not full pinyin |
| Default comment mode | Shape-code hints |
| Emoji | Enabled when the schema resets |
| Extended character option | Enabled when the schema resets |
| Chinese user dictionary | Enabled |
| Main automatic sentence creation | Disabled |
| Grammar model | Disabled: `grammar/language` is empty |
| Direct shape codes | Enabled in the custom patch |
| Modified left/right-hand pronunciation rules | Disabled |

The source settings define the defaults.
The `/so` menu can change the deployed settings without changing the source files.
Saved options can also change the state you see at startup.

Only `flypy_xhfast` appears in the configured schema list.
`easy_en` remains available through `Ctrl+g`.
`flyhe_fast`, `flypy_reverse`, and `flypy_radical` supply supporting dictionaries or functions.
`melt_eng` exists as a separate schema file, but this configuration does not select it.

The active Chinese dictionary imports the main characters, base words, mixed terms, and `flypy_ext1`.
The separate extended character dictionary, `flypy_chars_ext`, is not imported.
Thus, the extended-character option does not add that dictionary.

**Local file requirement:** `cn_dicts/ext/flypy_ext1.dict.yaml` exists in `~/Library/Rime`, but not in this Stow package.
A copy of this package alone does not include that required dictionary.

Sources: [main schema](flypy_xhfast.schema.yaml), [custom patch](flypy_xhfast.custom.yaml), [global patch](default.custom.yaml), [dictionary imports](flypy_xhfast.dict.yaml).

## 3. Select and edit text

### Candidate selection

These keys apply while a candidate list is open, unless the table gives another condition.

| Key | Action | Condition or example |
|---|---|---|
| `Space` | Commit the highlighted candidate | Normal text input |
| `1`–`5` | Select an item on the current page | Five candidates per page |
| `Up` / `Down` | Move the candidate highlight | Candidate menu |
| `;` | Commit candidate 2 | It is not a third-candidate key |
| `.` | Next candidate page | Candidate menu |
| `,` | Previous candidate page | After you move beyond the first page |
| `Page Down` / `Page Up` | Next / previous page | Candidate menu |
| `9` | Commit the first character of a word | Normal Chinese input |
| `0` | Commit the last character of a word | Normal Chinese input |
| `8` | Toggle short-code phrase priority | A menu with 3–6 lowercase input letters |

Example: when **你好** is highlighted, `9` inserts **你**, and `0` inserts **好**.
The `9` and `0` actions do not apply to every utility menu.
They require a normal `abc` or `paging` segment.

The `-` and `=` keys are not aliases for `9` and `0`.
`Ctrl+q` is not the configured alias for `8`.

### Input editing

| Key | Action |
|---|---|
| `Esc` | Cancel the current input |
| `Backspace` | Remove or revert the preceding input |
| `Delete` | Delete at the input cursor |
| `Ctrl+Backspace` | Remove a syllable |
| `Left` / `Right` | Move one input character without wraparound |
| `Shift+Left` / `Shift+Right` | Move by syllable |
| `Shift+Tab` / `Tab` | Send the previous / next syllable movement |
| `Home` / `Ctrl+a` | Move to the start of the input |
| `End` / `Ctrl+e` | Move to the end of the input |
| `Return` / `Ctrl+m` | Commit the raw input code |
| `Shift+Return` | Commit the displayed input code |
| `Ctrl+Shift+Return` | Commit the candidate comment |
| `Shift+Delete` / `Ctrl+k` | Reduce the learned priority of a candidate |

Example: type `nihc`, then push `Return` to insert `nihc`, not `你好`.
With the default display, `Shift+Return` can insert `ni hc`.

`Ctrl+k` does not reset every word frequency.
It sends Rime's `delete_candidate` action through `Shift+Delete`.
It differs from the custom global hide action on `Ctrl+d`.

### Temporary English mode

| Key | Local behavior |
|---|---|
| Left `Shift` alone | Enter temporary English mode during input |
| Right `Shift` alone | No Rime mode action |
| Left or right `Ctrl` alone | No Rime mode action |
| `Caps Lock` | Keep normal Caps Lock behavior |

In temporary English mode, `Return` commits the English text and returns to Chinese input.
macOS settings can take priority over Rime's Caps Lock setting.
For example, the system can use Caps Lock to switch to the `ABC` input method.

Sources: [global settings](default.yaml), [bindings](flypy_xhfast.custom.yaml), [character selection](lua/select_char.lua), [navigation](lua/easy_navigator.lua).

## 4. Chinese input and shape codes

### Double-pinyin

Each full syllable normally uses two keys.
The first key represents the initial sound.
The second key represents the final sound.

| Input | Pronunciation | Text example |
|---|---|---|
| `ni` | ni | `你` |
| `hc` | hao | `好` |
| `nihc` | ni hao | `你好` |
| `vsgo` | zhong guo | `中国` |

Use `/ok` to look for a double-pinyin key.
Examples: `/okian` offers `m`, and `/okin` offers `b`.
The same table includes shape components. For example, `/okc` includes `艹`.

Special initial keys are `v` for **zh**, `i` for **ch**, and `u` for **sh**.
The active sound aliases also permit selected `u`/`v` variants for `j`, `q`, `x`, and `y`.
The broader `l/n`, `zh/z`, `ch/c`, `sh/s`, and `in/ing` aliases remain commented out.

The full local lookup table is [flypy_keymap.txt](flypy_keymap.txt).

### One-character shape input

A character has two pronunciation keys and up to two shape keys.
Candidate comments show the shape code and its components.

| Input | Meaning | Result example |
|---|---|---|
| `ni/r` | Pronunciation `ni`, first shape key `r` | Narrows the candidate list |
| `ni/rx` | Pronunciation `ni`, shape code `rx` | `你` |
| `nirx` | Direct shape code, without `/` | `你` |
| ``ni`rx`` | Shape code with a backtick separator | `你` |
| `mk/oo` | Pronunciation `ming`, shape code `oo` | `明` |
| `uu/i` | Pronunciation `shu`, first shape key `i` | `输` |

A unique slash-based character match can commit automatically.
For example, `ni/rx` inserted **你** in the isolated engine test.
A direct code can remain in the candidate menu until you select it or type the next character.

### Two-character word hints

The local code adds shape hints to two-character Chinese words.
It reads the second character's shape code before the first character's shape code.

For **你好**, the shapes are **好 = nz** and **你 = rx**.
The combined order is `nzrx`.
A visible hint such as `~nzr〔女子｜亻〕` follows that order.
The `~` in this comment is a hint mark. It is not an instruction to type the English-creation prefix.

| Input | What it does |
|---|---|
| `nihc/` | Builds shape-filter candidates for the word |
| `nihc/n` | Filters with the first shape key of the second character |
| `nihc/nz` | Uses both shape keys of the second character |
| `nihc/nr` | Uses the first shape key of each character, second character first |
| `uiui/oz` | Offers `适时` in the shape-filter candidates |

Word filtering uses a limited candidate search.
A word outside that search can remain unavailable.
Do not assume every two-character word has the same ranking or automatic-commit behavior.

### Character-first mode

- Push `Ctrl+;` to toggle character-first mode at any time.
- Push `Ctrl+s` to toggle it during a candidate menu with 3–4 lowercase input letters.

The `Ctrl+s` condition is narrower than the upstream help suggests.
A two-letter code such as `ni` does not satisfy that condition.

The selector can commit a unique direct character match when the next lowercase key arrives.
Automatic word commit is not active.

### Tone filtering

Use `/` followed by an uppercase tone key after a two-letter pronunciation code.

| Key | Tone | Example |
|---|---|---|
| `I` | First tone | `ni/I` |
| `U` | Second tone | `ni/U` |
| `N` | Third tone | `ni/N` offers `你` |
| `M` | Fourth tone | `ni/M` |

Do not omit the slash. `niN` is not the same input as `ni/N`.
If no candidate matches, the code can show `⭕️`.

### Short-code phrases

The fuzzy translator searches with 2–7 lowercase letters.
It can offer Chinese, English, or mixed phrases from the supporting dictionary.
The code also tries a special three-character-word search for four-letter input.

Push `8` to change phrase priority for 3–6 lowercase letters.
This action changes the candidate order. It does not commit a phrase.
Selections from this translator can learn in `flyhe_fast.userdb`.

### Compose a phrase precisely

Use backticks to separate pronunciation and shape parts.
Example: ``ni`rxhc`nz`` offers **你好**.
You can also select characters by syllable.

This composition mode does not save a new phrase through its own user dictionary.
For a persistent custom code, use [Chinese code assignment](#chinese-code-assignment).

### Character lookup from components

Use the prefix `` `L `` followed by component double-pinyin codes.
Example: `` `Lriyt `` includes **明**, from **日 + 月**.
Select the required character from the list.
Other characters can share those components.

The lookup can show pronunciation and decomposition comments.
Use `` `L `` here. The recognized aliases `rL` and `oL` do not strip their prefixes for this table.
They produced no candidates in the isolated test.

Sources: [spelling rules](flypy_xhfast.schema.yaml), [selector](lua/cand_selector.lua), [fuzzy translator](lua/flypy_fuzzy.lua), [radical dictionary](flypy_radical.dict.yaml).

## 5. English input and word creation

### English candidates inside Chinese mode

Type an English word to get English candidates beside Chinese candidates.
Candidate order depends on the dictionaries and your learned choices.
An English candidate is not always first.

Append `'` to expose English completions that the normal filter suppresses.
Example: `beautiful'` offers **beautiful** and **beautifully**.

Use `*` between a known start and end for a wildcard search.
Example: `ab*t` searches words that start with `ab` and end with `t`.
The main schema limits this search to 300 dictionary entries.
Thus, a word can exist in the dictionary but stay outside this search.

### Dedicated English schema

1. Type a word, such as `hello`.
2. Push `Ctrl+g`.
3. Select an English candidate.

Push `Ctrl+g` again during non-empty input to return to `flypy_xhfast`.
This action switches schemas. It differs from temporary English mode on Left `Shift`.

The English schema includes an English-to-Chinese reverse dictionary.
Its candidate comments can show Chinese definitions.
The current comment-toggle code uses a different configuration name from that dictionary.
Do not rely on `Ctrl+n` to toggle these definitions.

### Capital letters

| Input style | Candidate behavior |
|---|---|
| `Tool` | Offers a title-case candidate such as `Tool` |
| `TOol` | Offers an uppercase candidate such as `TOOL` |
| `TOOL` | Offers uppercase candidates |

The raw mixed-case candidate can also appear.
Select the case you need instead of assuming the first candidate is correct.

### Add an English word

For a plain word:

1. Type the word followed by a backslash, such as `hermestest\`.
2. Select the new-word candidate.
3. Push `Space` to commit it.

The next input `hermestest` can use the saved user-dictionary entry without deployment.
The backslash form accepts letters and needs at least two letters for the new-word candidate.
An existing exact custom-file record does not produce a duplicate new-word candidate.

For text with spaces or digits, use `~`:

1. Type `~iPhone,28`.
2. Select **iPhone 28**.
3. Push `Space`.

A comma represents a space in this mode.
The recognized characters include letters, digits, `&`, `,`, `.`, `/`, `_`, and `-`.
You do not need a final `;` for the tested `~iPhone,28` example.

English creation appends to `en_dicts/en_custom.dict.yaml`.
Plain alphabetic text also updates `easy_en.userdb` immediately.
Text with digits takes a different save branch. Do not assume it has the same immediate English lookup behavior.
The text-file entry remains available for a later dictionary deployment.

### Chinese code assignment

Use this form:

```text
existing_phrase_code`=new_custom_code
```

Tested example:

```text
vsgovsyhdmuitd`=cctv
```

1. Type the example.
2. Select **中国中央电视台**.
3. Push `Space`.
4. Type `cctv` to get the saved phrase.

The new code can use letters and hyphens.
A slash can pass the recognizer, but the save check rejects it.
The code saves this entry in `free_user_dict.userdb`.

### Mixed Chinese and English spaces

The active filter can add spaces inside a mixed candidate.
Example: `VIP中P` becomes `VIP 中 P`.
This does not mean Rime adds a space between every separate Chinese and English commit.
The separate leading-space processor is disabled.

### Easydict

Push `Ctrl+y` while a candidate menu is open to send the highlighted text to Easydict.
This requires the macOS Easydict application and its `easydict://` URL handler.
The current code launches `open` and clears the input.
This application action was not run during the manual tests.
The code does not safely quote every possible candidate, so avoid unusual shell characters with this shortcut.

Sources: [English module](lua/easy_en.lua), [word creation](lua/cn_en_custom.lua), [capitalization](lua/word_autocaps.lua), [space filter](lua/word_append_space.lua), [English schema](easy_en.schema.yaml).

## 6. Candidate records

These actions need an open candidate menu.
Highlight the candidate before you push the key.

| Key | Action | Scope |
|---|---|---|
| `Ctrl+t` | Pin or unpin the selected text | Current input code |
| `Ctrl+d` | Hide the selected text globally | All input codes |
| `Ctrl+x` | Hide the selected text for this code | Current input code |
| `Ctrl+j` | Move the selected text behind three other candidates | Current input code |

Pinned candidates show `ᵀᴼᴾ`.
Fixed custom phrases can show `📌`.
A pin can remove spaces from the stored text.

**Important:** `Ctrl+d` does not delete the dictionary entry.
It adds a global record that hides that text.
In calculator mode, `Ctrl+d` instead deletes at the input cursor.

| Record | File under the Rime user folder | How to reverse it |
|---|---|---|
| Pins | `lua/pin_word_record.lua` | Select the pinned text and push `Ctrl+t` |
| Global hidden text | `lua/cold_word_records/drop_words.lua` | Remove the matching record, then reload Rime |
| Text hidden for a code | `lua/cold_word_records/hide_words.lua` | Remove the matching record, then reload Rime |
| Lower-priority text | `lua/cold_word_records/reduce_freq_words.lua` | Remove the matching record, then reload Rime |

The three cold-word actions have no undo key.
Back up a record file before a manual edit.
Do not remove the whole file to reverse one entry.

These files are Stow-managed on this Mac.
Rime's record writes can therefore change the files inside the dotfiles repository.
The `cold_word_reduce/excluded_types` setting does not exclude English candidates in the current Lua implementation.

Sources: [pin code](lua/pin_word.lua), [cold-word code](lua/cold_word_drop.lua).

## 7. Prefixes and commands

Type these in Chinese mode.
A prefix at the start of input has a different role from a slash inside a Chinese code.

| Input | Function | Example |
|---|---|---|
| `/oh`, `oH` | Help reference | `/oh` |
| `/ok` | Double-pinyin and shape-key lookup | `/okian` |
| `/so`, `sO` | Local settings menu | `/so` |
| `/vs` | Symbol category menu | `/vs` |
| `/` plus a symbol code | Symbol candidates | `/jt` for arrows |
| `;` plus a symbol code | Fast punctuation or emoji | `;d` → `、` |
| `` `L `` | Character lookup by components | `` `Lriyt `` |
| Backticks inside Chinese input | Precise phrase composition | ``ni`rxhc`nz`` |
| `` `= `` after a phrase code | Assign a custom word code | ``vsgovsyhdmuitd`=cctv`` |
| `~` | English text creation | `~iPhone,28` |
| Final `\` | Plain English word creation | `hermestest\` |
| `*` inside an English word | Wildcard search | `ab*t` |
| `date`, `/wd`, `orq` | Date formats | `date+2` |
| `time`, `/wt`, `osj` | Time formats | `time'` |
| `week`, `/wk`, `oxq` | Weekday formats | `week` |
| `timestamp`, `/wts`, `/uts`, `ots` | Unix timestamp | `/uts` |
| `/nl`, `nL`, `cL` | Lunar date | `nL20260217` |
| `/nn`, `nN`, `oN` | Chinese numbers and amounts | `nN123.45` |
| `=`, `cC` | Calculator | `cCsqrt(9)` |
| `lT` | LaTeX snippet conversion | `lTff>>ooc` |
| `@` | Email-domain suffix candidates | `@gmail.com` is one choice |

Help entries are reference text, not buttons that run the listed function.
Selecting a help item can commit its label.
Use `Esc` to leave help, then type the required command.

## 8. Date, time, and lunar date

### Date and time commands

| Input | Result |
|---|---|
| `date`, `/wd`, `orq` | Today's date in the configured formats |
| `date+2`, `/wd+2`, `orq+2` | A date two days later |
| `date-2`, `/wd-2`, `orq-2` | A date two days earlier |
| `time`, `/wt`, `osj` | Current time, with a time-of-day prefix where configured |
| `time'`, `/wt'`, `osj'` | Time without that prefix, with 24-hour forms where applicable |
| `week`, `/wk`, `oxq` | Chinese and English weekday forms |
| `timestamp`, `/wts`, `/uts`, `ots` | Unix timestamp in seconds |
| `/now` | Current date and time formats from the date translator |
| `/wjt` | Today's date |

Examples of date formats are `2026年10月13日`, `2026/10/13`, and `2026.10.13`.
Other candidates include a Chinese-numeral date, English dates, and an ISO-style timestamp with a timezone.
There are ten configured date formats and seven configured time formats.
Later filters can change the visible candidate list.

### Relative dates

| Input | Meaning |
|---|---|
| `/wqt` | Two days ago |
| `/wzt` | Yesterday |
| `/wmt` | Tomorrow |
| `/wht` | In two days |
| `/wuz`, `/wlk` | The same weekday last week |
| `/wxz`, `/wnk` | The same weekday next week |
| `/wuy`, `/wlm` | The corresponding date in the previous month |
| `/wxy`, `/wnm` | The corresponding date in the next month |

Month calculations use the Lua date logic.
Check the result at month boundaries.
The English ordinal suffixes are not correct for every day.
For example, the current code can produce `21th`.
Some Chinese-numeral month-offset dates also retain Arabic digits.

The configured date shortcuts `s`, `d`, and `f` do not match the actual date/time segment tags.
Use the normal candidate keys instead.

### Lunar dates

Use `/nl`, `nL`, or `cL` for today's lunar date.
Append exactly eight Gregorian date digits for another date.

Example:

```text
nL20260217
```

This offers **丙午(马)年正月初一** and **二〇二六年一月一日**.
The supported years are **1900–2099**.
Invalid eight-digit dates produce a warning candidate.
For example, `nL20230229` is invalid.

Other digit lengths can fall back to today's date instead of reporting an error.
Always use exactly eight digits for a specific date.
This feature converts Gregorian dates to lunar dates. It is not a lunar-to-Gregorian input mode.
The literal word `lunar` is not an active trigger.

Sources: [date/time code](lua/date_time.lua), [lunar code](lua/chinese_lunar.lua), [configured formats](flypy_xhfast.custom.yaml).

## 9. Chinese numbers

Use `nN`, `/nn`, or `oN`, followed by a number.
A minus sign and a decimal point are permitted.
Example: `nN123.45`.

| Candidate | Example output | Working quick key |
|---|---|---|
| Financial amount, formal characters | `壹佰贰拾叁元肆角伍分` | `s` |
| Financial amount, ordinary characters | `一百二十三元四角五分` | `d` |
| Formal Chinese number | `壹佰贰拾叁点肆伍` | `f` |
| Ordinary Chinese number | `一百二十三点四五` | `j` |
| Each digit as a Chinese character | `一二三点四五` | `m` |
| Number with grouping commas | `123.45` | Next page, then normal selection |

**The displayed hints contain a mismatch.**
Candidate 5 shows `u`, but `u` is not its configured selection key.
Candidate 6 shows `m`, but `m` selects candidate 5.
For candidate 6, use `Page Down`, then select the first item on that page.

Inside this mode, these keys enter digits:

| Key | Inserts | Key | Inserts |
|---|---|---|---|
| `o` | `0` | `i` | `1` |
| `b` | `00` | `h` | `100` |
| `q` | `000` | `k` | `1000` |
| `w` | `0000` | `.` | Decimal point |

Financial amounts use at most four decimal places.
The main number-to-Chinese conversion supports at most twelve integer digits.
Digit-by-digit and grouped-number output have different limits.

Use one leading minus sign and at most one decimal point.
The recognizer accepts malformed strings such as `1-2`, but their output is not reliable.
For integer-only input, the two Chinese-number candidates can contain an unwanted final `点`.
Check the selected text before you use it in a financial document.

Source: [Chinese-number code](lua/chinese_number.lua) and [its bindings](flypy_xhfast.custom.yaml).

## 10. Calculator

Use `=` or `cC` before an expression.
The calculator inserts text. It is not a separate calculator application.

| Input | Tested result |
|---|---|
| `=1+2` | `3` |
| `=sqrt(9)` | `3.0` |
| `=2^3` | `8.0` |
| `=5!` | `120` |
| `=50%` with the normal shifted `%` key | The input changes to `50/100`, result `0.5` |
| `cCpi+0` | Numeric value of π |
| `cC/h`, `cC?h` | Function reference |

Use `+`, `-`, `*`, `/`, and `^` for the main arithmetic operations.
Use parentheses for grouping.
`!` after digits calls the factorial function.

### Functions and constants

| Group | Names |
|---|---|
| Constants | `e`, `pi` |
| Number multipliers | `b`, `q`, `k`, `w`, `tw`, `m`, `tm`, `y`, `g` |
| Trigonometric functions | `sin`, `cos`, `tan`, `asin`, `acos`, `atan`, `atan2` |
| Hyperbolic functions | `sinh`, `cosh`, `tanh` |
| Angle conversion | `deg`, `rad` |
| Powers and roots | `exp`, `ldexp`, `sqrt`, `nroot` |
| Logarithms | `log`, `loge`, `logt` |
| Statistics | `avg`, `var` |
| Other | `fact`, `rdm` |

The trigonometric functions use radians.
The function reference explains the number multipliers.
A bare name such as `cCpi` shows a description, not its numeric value.
Use an expression such as `cCpi+0` for the value.

The recognizer excludes commas, semicolons, and apostrophes from calculator input.
Thus, functions that need comma-separated arguments are not fully usable through this input form.
Do not assume every function in the reference has a usable keyboard expression.

### Calculator keys

These keys apply only inside calculator mode.

| Key | Action |
|---|---|
| `%` | Insert `/100` |
| `(` | Insert `()` and move the cursor inside |
| `)` | Move past the current closing parenthesis when its match condition applies |
| `Ctrl+d` | Delete at the cursor |
| `Shift+U` | Insert `10` |
| `Shift+B` | Insert `00` |
| `Shift+H` | Insert `100` |
| `Shift+Q` | Insert `000` |
| `Shift+K` | Insert `1000` |
| `Shift+W` | Insert `0000` |
| `Shift+J` | Select displayed candidate 3 |
| `Shift+I` | Select displayed candidate 4 |
| `Shift+O` | Select displayed candidate 5 |
| `Shift+L` | Send candidate key 6, outside the normal five-item page |

The calculator creates result, rounded-result, scientific, and equation candidates.
The final duplicate filter can remove repeated formats.
For a small result such as `cC5!`, candidate 5 is the help hint, not a fifth numeric format.
Thus, `Shift+O` can insert the help hint.
Use the displayed labels when you need a specific format.

A one-digit or certain two-digit bare number can show no result.
Example: `cC12` produces no calculator candidates.
There is no saved `ans` value.
Normal floating-point limits apply to calculator results.

Source: [calculator](lua/calculator.lua), [custom key binder](lua/keybinder.lua).

## 11. Symbols, emoji, and paired punctuation

### Browse symbols

1. Type `/vs`.
2. Select a category, such as `标点:bd ➤`.
3. Select the symbol you need.

Selecting that category changes the input to `/bd`.
Push `Ctrl+p` from a slash-letter symbol menu to return to `/vs`.
`Ctrl+p` is not the normal comment-commit key.

| Code | Category or example |
|---|---|
| `/bd` | Punctuation |
| `/fh` | General symbols |
| `/dn` | Keyboard and computer symbols |
| `/jt` | Arrows |
| `/sx` | Math symbols |
| `/dw` | Units |
| `/hb` | Currency |
| `/xh` | Stars |
| `/jh` | Shapes |
| `/szq` | Circled numbers |
| `/a` | `ā`, `á`, `ǎ`, `à`, and other forms |
| `/v` | `ü` and its tone forms |
| `/xl`, `/xld` | Lowercase / uppercase Greek letters |
| `/ey`, `/eyd` | Lowercase / uppercase Russian letters |
| `/sb`, `/xb` | Superscript / subscript characters |
| `/fe` | File extensions, such as `.md` |
| `/mba`, `/mbs`, `/mbc` | Markdown code-fence starters |
| `/wf` | WeChat text codes, such as `[微笑]` |
| `/ff` | Face emoji |

Code-fence candidates insert a starter such as three backticks followed by `python`.
They do not create a complete code block with its closing fence.

### Fast punctuation

With no normal candidate menu active, type a semicolon code.
A single mapped symbol can commit automatically.
The semicolon itself selects candidate 2 when a normal candidate menu is open.

| Code | Output | Code | Output | Code | Output |
|---|---|---|---|---|---|
| `;a` | `！` | `;b` | `(` | `;c` | `)` |
| `;d` | `、` | `;e` | Backtick | `;g` | `・` |
| `;h` | `§` | `;i` | `」` | `;j` | `#` |
| `;k` | `【` | `;l` | `】` | `;m` | `>` |
| `;n` | `<` | `;o` | `.` | `;p` | `％` |
| `;q` | `:` | `;r` | `"` | `;s` | `……` |
| `;t` | `@` | `;u` | `「` | `;v` | `——` |
| `;w` | `？` | `;x` | `＊` | `;y` | `￥` |
| `;z` | `'` | | | | |

Emoji codes start with `;f`.
Example: `;fdv` inserts **✅**.
`;fe` shows common emoji, and `;fs` shows common punctuation.
`;ff` is not active repeat-last-text input.

### Normal punctuation and email suffixes

The half-width punctuation table offers several forms for keys such as `(`, `[`, `$`, and `\`.
A key with one mapping can commit at once.
A key with several mappings shows candidates.

Type `@` to select common email-domain suffixes:
`@gmail.com`, `@foxmail.com`, `@outlook.com`, `@hotmail.com`, `@qq.com`, `@163.com`, and `@139.com`.

The digit-separator setting covers `.` and `:`.
Rime can use their ASCII forms after digits.
A repeated separator key can restore the Chinese punctuation form.

### Paired punctuation

The paired-punctuation feature is enabled.
An opening bracket can contain the next selected word.

Tested examples:

```text
[ + nihc + Space  →  [你好]
( + nihc + Space  →  (你好)
```

Use the normal physical shifted key for `(`.
Do not commit the opening symbol separately if you want it to contain the next word.
The pair table also includes Chinese brackets and quotes, such as `【】`, `「」`, `《》`, `“”`, and `‘’`.
Candidate selection and the application can affect the exact interaction.

### Emoji behavior

`Ctrl+Shift+4` toggles emoji while a candidate menu is open.
You can also use the Rime option menu.
The emoji filter moves some emoji behind text candidates.
Its configured index is `6`, but the implementation is not an exact sixth-position guarantee.

Chinese-word emoji conversion differs from direct symbol codes.
Direct codes such as `;fdv` can still insert a symbol when conversion is disabled.
The filter hides bracketed WeChat codes from normal word candidates outside WeChat.
The direct `/wf` symbol list remains available.

Sources: [symbol mappings](symbols.custom.yaml), [symbol-menu code](lua/symbol_menu.lua), [pair code](lua/pair_punct.lua), [emoji filter](lua/reduce_emoji.lua).

## 12. LaTeX snippets

Use the case-sensitive prefix `lT`.
The translator converts repeated-letter codes into LaTeX commands.

| Input | Output example |
|---|---|
| `lTaa` | `\alpha` |
| `lTbb` | `\beta` |
| `lTff>>ooc` | `\phi\rangle\propto` |
| `lTjjh` | `\leftarrow` |
| `lToox` | `\otimes` |

The output can include a final space.
The translator does not add math delimiters such as `$...$`.
It is a snippet converter, not a full LaTeX editor.
See [laTex.lua](lua/laTex.lua) for all replacement codes.

`/lt` is recognized, but the current code retains `/lt` in its output.
Use `lT` instead.

## 13. Options and display

### Rime option menu

Push `Ctrl` + backtick to open `方案选单`.
This replaces the upstream `Alt` + backtick suggestion.

| Option | Meaning |
|---|---|
| `中 / En` | Chinese / ASCII mode |
| `。 / .` | Chinese / ASCII punctuation |
| `半 / 全` | Half-width / full-width characters |
| `字型` | Simplified, general Traditional, Hong Kong Traditional, or Taiwan Traditional conversion |
| Emoji states | Word-to-emoji conversion |
| `休想 / 联想` | Prediction disabled / enabled |
| `词组优先 / 单字优先` | Word-first / character-first mode |
| `通用字集 / 增廣字集` | Restricted / extended character filter |
| `隐藏码区 / 显示码区` | Hide / show Unicode-block comments |
| `双拼显示 / 全拼显示` | Double-pinyin / full-pinyin input display |
| `注解类型` | Blank, shape hints, or tone hints |

The saved option list includes `ascii_punct` and `char_mode`.
Emoji and extended-character states reset to enabled.
The input display resets to double-pinyin, and comment mode resets to shape hints in the source defaults.

Script conversion applies to normal Chinese candidates.
It does not necessarily convert utility output or every dictionary tag.
The restricted character filter is not a strict allowed-character list.
A mixed word can remain even when one character is extended.

### Direct option keys

| Key | Action | Condition |
|---|---|---|
| `Ctrl+.` | Toggle half-width / full-width output | Any time |
| `Ctrl+,` | Toggle Chinese / ASCII punctuation | Any time |
| `Ctrl+;` | Toggle character-first mode | Any time |
| `Ctrl+s` | Toggle character-first mode | Menu with 3–4 lowercase input letters |
| `Ctrl+n` | Cycle shape, tone, and blank comments | Candidate menu |
| `Ctrl+Shift+4` | Toggle emoji conversion | Candidate menu |
| `Ctrl+Shift+5` | Toggle the Simplified-conversion flag | Candidate menu |
| `Ctrl+Shift+6` | Toggle Unicode-block comments | Candidate menu |

`Ctrl+Shift+5` is not a complete four-way script selector.
Use the Rime option menu for Hong Kong or Taiwan Traditional output.
Some applications intercept Control/Shift shortcuts before Rime receives them.
Use the menu if a key does not work in one application.

### Local `/so` settings menu

Type `/so` or `sO`, then select an item.
Working choices include these groups:

| Group | Menu actions |
|---|---|
| Display | List layout, input display placement, full-pinyin display, labels, text direction, line spacing |
| Output | Emoji, punctuation, width, basic Simplified/Traditional conversion, semicolon output |
| Candidates | Character set, comments, block hints, character-first mode, page size, normal selection keys |
| Spacing | Add or remove the mixed-word space filter |

The menu writes `build/<schema_id>.schema.yaml` and reloads the schema.
`Ctrl+n` can also save a comment setting there.
These actions do not update `flypy_xhfast.custom.yaml`.
A later deployment can replace those settings with the source defaults.

**Menu items with known limits:**

- The font-size labels do not match their handler strings. They do not change the font size.
- The fuzzy-function item writes a setting that the active fuzzy translator does not read.
- The automatic-word-commit item does not control a working automatic-word-commit feature.
- The disable-leading-space item has no effect here because that processor is already absent.

For a permanent change, edit the source custom patch, then deploy Rime.
Do not use a broken menu item as proof that a feature changed.

Sources: [switcher implementation](lua/flypy_switcher.lua), [global patch](default.custom.yaml), [custom patch](flypy_xhfast.custom.yaml).

## 14. Prediction

The active engine includes the `predictor` processor and `predict_translator`.
The installed Squirrel build includes the prediction plugin.
The feature works in the isolated desktop engine, despite the mobile-only source comment.

1. Open the Rime option menu with `Ctrl` + backtick.
2. Enable `联想`.
3. Commit a Chinese word.
4. Select a suggested continuation, or cancel the prediction menu.

Example: after **你好**, the isolated test offered continuations such as **吗** and **啊**.
This is a database-based next-word feature, not a language-model chat function.

The source sets one prediction round and a target of five candidates.
The test returned more candidates in one case, so five is not an exact visible limit.
The database is `predict.db`.
The rule files are [custom_predict_rules.yaml](custom_predict_rules.yaml) and [user_custom_predict_rule.example.yaml](user_custom_predict_rule.example.yaml).
The calendar-rule input remains commented out.

The grammar model is a different feature.
It remains disabled because `grammar/language` is empty.

## 15. Files, changes, and deployment

### File locations

| Path | Purpose |
|---|---|
| `~/Projects/dotfiles/Rime/` | Source configuration in the dotfiles repository |
| `~/Library/Rime/` | Rime user folder on this Mac |
| `~/Library/Rime/build/` | Generated, deployed configuration and dictionaries |
| `*.userdb` folders | Learned words and user-dictionary data |

Static files in the user folder link to the Stow package.
Edit the source files, not their generated copies in `build/`.
Do not delete user-dictionary folders to fix a display problem.

### Common edits

| Change | Source file or setting |
|---|---|
| Candidate count | `flypy_xhfast.custom.yaml` → `menu/+/page_size` |
| Candidate layout and font | `flypy_xhfast.custom.yaml` → `style/+` |
| Scheme list and menu hotkey | `default.custom.yaml` |
| Custom shortcuts | `flypy_xhfast.custom.yaml` → `key_binder/+` |
| Date/time output formats | `flypy_xhfast.custom.yaml` → `date_time` |
| Symbol and emoji codes | `symbols.custom.yaml` |
| Fixed phrases | `custom_phrase.txt` |
| English custom dictionary | `en_dicts/en_custom.dict.yaml` |
| Enabled Chinese dictionaries | `flypy_xhfast.dict.yaml` |
| Help entries | `lua/flypy_help_menu.lua` |

Use UTF-8 text.
Use spaces, not tabs, for YAML indentation.
Keep the existing indentation when you change a patch.

### Fixed phrases

`custom_phrase.txt` uses tab-separated fields:

```text
text<TAB>input_code<TAB>weight
```

Example:

```text
Kubernetes<TAB>kube<TAB>1
```

Replace each `<TAB>` with an actual tab character.
The fixed-phrase translator uses exact codes, not completion.
A larger weight can rank one phrase above another phrase with the same code.
Deploy after you edit this file.

### Apply source changes

1. Save the changed source file.
2. Open the macOS input-method menu.
3. Select **重新部署 / Deploy** for Squirrel.
4. Test one known input, such as `nihc`.

Deployment does not require you to erase your learned words.
It can replace changes that `/so` wrote only to the generated schema.
Lua changes can need a schema reload or deployment before the running input method reads them.

### Link the Stow package

These shell commands are for linking files, not for typing into Rime.
Use them only if the source links are missing or you add new static files.

```sh
cd ~/Projects/dotfiles
stow -n -S Rime -t ~/Library/Rime
```

The `-n` command is a dry run.
Read its output before you apply it:

```sh
stow -S Rime -t ~/Library/Rime
```

Do not run `--adopt` to resolve an unexplained conflict.
It can move an existing file into the source package.
Stow linking and Rime deployment are separate actions.

The package excludes `build/`, `sync/`, user databases, `installation.yaml`, and `user.yaml` from Stow management.
Its Git ignore file also excludes runtime data.
Pin and cold-word record files are not excluded.

## 16. Inactive features and known limits

A recognizer pattern or a Lua file alone does not enable a feature.
The engine must also load its processor or translator.

| Feature or input | Actual state | Use instead |
|---|---|---|
| `/jk`, `/kj`, direct app aliases | `shortcut.lua` is not loaded | Launch apps or run commands outside Rime |
| `/hs`, `hH`, `uH` | History module is not loaded | Application history |
| `;ff` | Repeat-last-commit handler is not loaded | Application copy/paste |
| `Ctrl+r` | User-word removal module is not loaded | The record actions described above, where appropriate |
| `Ctrl+Shift+E` | Binding is commented out | `Ctrl+g` during input |
| `Ctrl+Shift+0` | Binding is commented out | Rime option menu |
| `Ctrl+w`, `Ctrl+i`, `Ctrl+o` | Extra bindings are commented out | `Ctrl+Backspace`, `Shift+Tab`, `Tab` |
| `Ctrl+q` | Replaced by the configured fuzzy key | `8` with 3–6 lowercase letters |
| `-` / `=` for first/last character | Not configured | `9` / `0` |
| `Alt` + backtick, `F4` | Not the configured menu shortcuts | `Ctrl` + backtick |
| `/help` | Not an active help alias | `/oh`, `oH` |
| `/fr`, `rL`, `oL` component lookup | Not usable with this table-prefix setup | `` `L `` |
| `/lt` | Leaves the prefix in converted output | `lT` |
| `lunar` | Not an active lunar trigger | `/nl`, `nL`, `cL` |
| History-based commit reversal | Translator is commented out | Application undo |
| Grammar-based candidate scoring | Model name is empty | Normal dictionary and learned ranking |
| Alternate pronunciation-key rules | Include is commented out | Standard Xiaohé keys |

The unused shortcut configuration contains app, URL, folder, system-command, and password-generator entries.
They are not active commands in this setup.
Do not use that inactive generator for secure passwords.

Other limits appear beside the relevant feature:
Chinese-number hint keys, calculator formats, date suffixes, English-definition toggles, and broken `/so` items.
This manual records those limits. It does not change the input functions to hide them.

## 17. Source map

| Feature | Configuration and code |
|---|---|
| Main engine and spelling | [flypy_xhfast.schema.yaml](flypy_xhfast.schema.yaml), [flypy_xhfast.custom.yaml](flypy_xhfast.custom.yaml) |
| Global keys and schema menu | [default.yaml](default.yaml), [default.custom.yaml](default.custom.yaml) |
| Chinese shape and tone input | [cand_selector.lua](lua/cand_selector.lua) |
| Short-code phrases | [flypy_fuzzy.lua](lua/flypy_fuzzy.lua), [flyhe_fast.schema.yaml](flyhe_fast.schema.yaml) |
| Candidate filtering | [flypy_fixed.lua](lua/flypy_fixed.lua), [charset.lua](lua/charset.lua), [reduce_emoji.lua](lua/reduce_emoji.lua) |
| Candidate records | [pin_word.lua](lua/pin_word.lua), [cold_word_drop.lua](lua/cold_word_drop.lua) |
| English and custom words | [easy_en.lua](lua/easy_en.lua), [cn_en_custom.lua](lua/cn_en_custom.lua), [easy_en.schema.yaml](easy_en.schema.yaml) |
| Letter case and spaces | [word_autocaps.lua](lua/word_autocaps.lua), [word_append_space.lua](lua/word_append_space.lua) |
| Character selection and cursor | [select_char.lua](lua/select_char.lua), [easy_navigator.lua](lua/easy_navigator.lua), [keybinder.lua](lua/keybinder.lua) |
| Dates and numbers | [date_time.lua](lua/date_time.lua), [chinese_lunar.lua](lua/chinese_lunar.lua), [chinese_number.lua](lua/chinese_number.lua) |
| Calculator and LaTeX | [calculator.lua](lua/calculator.lua), [laTex.lua](lua/laTex.lua) |
| Symbols and pairs | [symbols.custom.yaml](symbols.custom.yaml), [symbol_menu.lua](lua/symbol_menu.lua), [pair_punct.lua](lua/pair_punct.lua) |
| Options and help | [flypy_switcher.lua](lua/flypy_switcher.lua), [flypy_help_menu.lua](lua/flypy_help_menu.lua) |
| Prediction rules | [custom_predict_rules.yaml](custom_predict_rules.yaml), [user_custom_predict_rule.example.yaml](user_custom_predict_rule.example.yaml) |

Checks used the installed **librime 1.16.0** engine and its Lua, prediction, and grammar plugins.
The test folder used copied settings and Lua files, existing compiled dictionaries, and separate user databases.
The tests checked candidate output and key events, not every macOS application.
No test launched Easydict or executed the inactive app/system commands.

## 18. Full symbol-code reference

The following reference lists the deployed symbol mappings, including the inherited mappings.
A row shows the first few configured outputs, not every item in that symbol category.
Other active filters can change a visible candidate list.
Utility commands can take priority if they share an input form.
The source definitions remain in [symbols.custom.yaml](symbols.custom.yaml).
