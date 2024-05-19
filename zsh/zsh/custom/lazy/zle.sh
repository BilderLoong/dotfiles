# In favor of atuin start.
# # https://zenn.dev/nokogiri/articles/ec99e40df54555#%5Er-%E3%82%92%E4%BD%BF%E3%81%A3%E3%81%A6%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E5%B1%A5%E6%AD%B4%E3%82%92%E6%A4%9C%E7%B4%A2
# function fzf-select-history() {
# 	BUFFER=$(history -n -r 1 | fzf --query "$LBUFFER" --reverse)
# 	CURSOR=$#BUFFER
# 	zle reset-prompt
# }
#
# zle -N fzf-select-history
# bindkey '^r' fzf-select-history
# In favor of atuin end.
