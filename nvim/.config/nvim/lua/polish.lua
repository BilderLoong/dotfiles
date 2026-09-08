-- Run after AstroUI has applied the theme and its highlight overrides.
-- Fade unused code using Normal colors, rather than the comment color.
require("unused_highlight").setup({ opacity = 2 / 3 })
-- Blend 12.5% of Normal text into the original comment color.
require("comment_highlight").setup()
