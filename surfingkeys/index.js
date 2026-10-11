// Reference: 
// bonssdfa
// https://github.com/search?q=Surfingkeys&type=repositories
// https://github.com/b0o/surfingkeys-conf

// API DOC: https://github.com/brookhong/Surfingkeys/blob/master/docs/API.md


 // Insert mode: jk → Escape
api.imap('jk', '<Esc>');

// Google Images: si searches selected text or clipboard
api.addSearchAlias(
  'i',
  'Google Images',
  'https://www.google.com/search?tbm=isch&q='
);

// Etymonline: se searches selected text or clipboard
// Autocomplete omitted until its response format is verified.
api.addSearchAlias(
  'e',
  'Etymonline',
  'https://www.etymonline.com/word/'
);

// Copy page title and URL as Markdown
api.mapkey('ymd', 'Copy page as Markdown', function () {
  const title = document.title;
  const url = window.location.href;
  const markdown = `[${title}](${url})`;

  api.Clipboard.write(markdown);
  api.Front.showBanner('Copied MD URL: ' + markdown);
});

// Remap T to gt
api.map('gt', 'T');

// YouTube: keep only j and k in Normal mode
api.unmapAllExcept(['j', 'k'], /youtube\.com/);

// Emoji configuration
settings.startToShowEmoji = 2;

// Dark theme
settings.theme = `
.sk_theme {
  font-family: Input Sans Condensed, Charcoal, sans-serif;
  font-size: 10pt;
  background: #24272e;
  color: #abb2bf;
}
.sk_theme tbody {
  color: #fff;
}
.sk_theme input {
  color: #d0d0d0;
}
.sk_theme .url {
  color: #61afef;
}
.sk_theme .annotation {
  color: #56b6c2;
}
.sk_theme .omnibar_highlight {
  color: #528bff;
}
.sk_theme .omnibar_timestamp {
  color: #e5c07b;
}
.sk_theme .omnibar_visitcount {
  color: #98c379;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
  background: #303030;
}
.sk_theme #sk_omnibarSearchResult ul li.focused {
  background: #3e4452;
}
#sk_status, #sk_find {
  font-size: 20pt;
}
`;
