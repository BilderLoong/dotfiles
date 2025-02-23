// Reference: 
// bonssdfa
// https://github.com/search?q=Surfingkeys&type=repositories
// https://github.com/b0o/surfingkeys-conf

// API DOC: https://github.com/brookhong/Surfingkeys/blob/master/docs/API.md


api.mapkey('ymd', 'Copy current page title and URL as Markdown', function() {
  const title = document.title;
  const url = window.location.href;
  const markdown = `[${title}](${url})`;
  api.Clipboard.write(markdown);
  api.Front.showBanner('Copied MD URL: ' + markdown);
});


// only keep E, R and T from Surfingkeys for gmail.com and twitter.com
api.unmapAllExcept([], /youtube.com/);

// an example to replace `T` with `gt`, click `Default mappings` to see how `T` works.
api.map('gt', 'T');

api.addSearchAlias('e', 'etymonline', 'https://www.etymonline.com/word/', 's', 'https://www.etymonline.com/api/etymology/fuzzy?key=', function(response) {
    var res = JSON.parse(response.text);
    return res;
});

// set theme
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
}`;
// click `Save` button to make above settings to take effect.</ctrl-i></ctrl-y>
