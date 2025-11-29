# XSS Benchmark

A Sinatra-based XSS vulnerability benchmark server for testing XSS detection tools.

## Overview

This server provides 200 different XSS vulnerable endpoints:
- **Endpoints 1-100**: Basic XSS injection contexts without protection
- **Endpoints 101-200**: XSS injection contexts with various protection/filter mechanisms

All endpoints use the GET method and accept a `query` parameter.

## Installation

```bash
bundle install
```

## Usage

```bash
bundle exec ruby app.rb
```

The server will start on `http://0.0.0.0:3000`.

## Endpoints

### Basic XSS Endpoints (1-100)

These endpoints have no protection and are vulnerable to various XSS injection techniques.

| Endpoint | XSS Context | Example Payload |
|----------|-------------|-----------------|
| GET /1?query= | HTML body | `<script>alert(1)</script>` |
| GET /2?query= | Unquoted attribute | `test onclick=alert(1)` |
| GET /3?query= | Single-quoted attribute | `' onclick='alert(1)` |
| GET /4?query= | Double-quoted attribute | `" onclick="alert(1)` |
| GET /5?query= | href attribute | `javascript:alert(1)` |
| GET /6?query= | Script (single quote) | `';alert(1);//` |
| GET /7?query= | Script (double quote) | `";alert(1);//` |
| GET /8?query= | onclick handler | `');alert(1);//` |
| GET /9?query= | img src | `x" onerror="alert(1)` |
| GET /10?query= | img onerror | `');alert(1);//` |
| GET /11?query= | style attribute | `red;background-image:url(javascript:alert(1))` |
| GET /12?query= | textarea | `</textarea><script>alert(1)</script>` |
| GET /13?query= | title tag | `</title><script>alert(1)</script>` |
| GET /14?query= | iframe src | `javascript:alert(1)` |
| GET /15?query= | SVG text | `<script>alert(1)</script>` |
| GET /16?query= | data attribute | `" onclick="alert(1)` |
| GET /17?query= | meta refresh | `0;url=javascript:alert(1)` |
| GET /18?query= | object data | `javascript:alert(1)` |
| GET /19?query= | embed src | `javascript:alert(1)` |
| GET /20?query= | form action | `javascript:alert(1)` |
| GET /21?query= | body onload | `');alert(1);//` |
| GET /22?query= | onmouseover handler | `');alert(1);//` |
| GET /23?query= | onfocus handler | `');alert(1);//` |
| GET /24?query= | oninput handler | `');alert(1);//` |
| GET /25?query= | onchange handler | `');alert(1);//` |
| GET /26?query= | JS template literal | `${alert(1)}` |
| GET /27?query= | innerHTML (DOM XSS) | `<img src=x onerror=alert(1)>` |
| GET /28?query= | document.write (DOM XSS) | `<script>alert(1)</script>` |
| GET /29?query= | HTML comment | `--><script>alert(1)</script><!--` |
| GET /30?query= | style tag | `red;}</style><script>alert(1)</script>` |
| GET /31?query= | base tag href | `javascript:alert(1)//` |
| GET /32?query= | link stylesheet | `javascript:alert(1)` |
| GET /33?query= | script src | `data:text/javascript,alert(1)` |
| GET /34?query= | img srcset | `x" onerror="alert(1)` |
| GET /35?query= | video poster | `javascript:alert(1)` |
| GET /36?query= | video src | `javascript:alert(1)` |
| GET /37?query= | audio src | `javascript:alert(1)` |
| GET /38?query= | source src | `javascript:alert(1)` |
| GET /39?query= | track src | `javascript:alert(1)` |
| GET /40?query= | formaction | `javascript:alert(1)` |
| GET /41?query= | iframe srcdoc | `<script>alert(1)</script>` |
| GET /42?query= | SVG onload | `');alert(1);//` |
| GET /43?query= | SVG href | `javascript:alert(1)` |
| GET /44?query= | MathML | `<script>alert(1)</script>` |
| GET /45?query= | details ontoggle | `');alert(1);//` |
| GET /46?query= | marquee onstart | `');alert(1);//` |
| GET /47?query= | contenteditable onfocus | `');alert(1);//` |
| GET /48?query= | autofocus onfocus | `');alert(1);//` |
| GET /49?query= | JSON context | `"};alert(1);//` |
| GET /50?query= | noscript tag | `</noscript><script>alert(1)</script>` |
| GET /51?query= | URL fragment (DOM XSS) | `<img src=x onerror=alert(1)>` |
| GET /52?query= | window.name (DOM XSS) | `<img src=x onerror=alert(1)>` |
| GET /53?query= | location.search (DOM XSS) | `<img src=x onerror=alert(1)>` |
| GET /54?query= | CSS @import url | `);@import url(javascript:alert(1))` |
| GET /55?query= | setTimeout string | `");alert(1);//` |
| GET /56?query= | setInterval string | `");alert(1);//` |
| GET /57?query= | eval context | `");alert(1);//` |
| GET /58?query= | Function constructor | `");alert(1);//` |
| GET /59?query= | postMessage handler | `<img src=x onerror=alert(1)>` |
| GET /60?query= | document.cookie | `';alert(1);//` |
| GET /61?query= | localStorage | `';alert(1);</script><script>alert(1)//` |
| GET /62?query= | sessionStorage | `';alert(1);</script><script>alert(1)//` |
| GET /63?query= | XMLHttpRequest open URL | `javascript:alert(1)` |
| GET /64?query= | fetch URL | `javascript:alert(1)` |
| GET /65?query= | Worker URL | `data:text/javascript,alert(1)` |
| GET /66?query= | SharedWorker URL | `data:text/javascript,alert(1)` |
| GET /67?query= | aria-label attribute | `" onclick="alert(1)` |
| GET /68?query= | input placeholder | `" onfocus="alert(1)" autofocus="` |
| GET /69?query= | img alt attribute | `" onerror="alert(1)` |
| GET /70?query= | button type attribute | `submit" onclick="alert(1)` |
| GET /71?query= | input type attribute | `text" onfocus="alert(1)" autofocus="` |
| GET /72?query= | body background (legacy) | `javascript:alert(1)` |
| GET /73?query= | table background (legacy) | `javascript:alert(1)` |
| GET /74?query= | td background (legacy) | `javascript:alert(1)` |
| GET /75?query= | bgsound src (legacy IE) | `javascript:alert(1)` |
| GET /76?query= | layer src (legacy) | `javascript:alert(1)` |
| GET /77?query= | input formmethod | `GET" onclick="alert(1)` |
| GET /78?query= | input formenctype | `text/plain" onclick="alert(1)` |
| GET /79?query= | input formtarget | `_blank" onclick="alert(1)` |
| GET /80?query= | a target attribute | `_blank" onclick="alert(1)` |
| GET /81?query= | a download attribute | `test" onclick="alert(1)` |
| GET /82?query= | area href | `javascript:alert(1)` |
| GET /83?query= | blockquote cite | `" onclick="alert(1)` |
| GET /84?query= | q cite attribute | `" onclick="alert(1)` |
| GET /85?query= | ins cite attribute | `" onclick="alert(1)` |
| GET /86?query= | del cite attribute | `" onclick="alert(1)` |
| GET /87?query= | applet codebase (legacy) | `javascript:alert(1)` |
| GET /88?query= | applet code (legacy) | `javascript:alert(1)` |
| GET /89?query= | object codebase | `javascript:alert(1)` |
| GET /90?query= | object classid | `javascript:alert(1)` |
| GET /91?query= | param value | `javascript:alert(1)` |
| GET /92?query= | XML data island | `</item></xml><script>alert(1)</script>` |
| GET /93?query= | xmp tag (deprecated) | `</xmp><script>alert(1)</script>` |
| GET /94?query= | listing tag (deprecated) | `</listing><script>alert(1)</script>` |
| GET /95?query= | plaintext tag | N/A (renders all as text) |
| GET /96?query= | isindex prompt (deprecated) | `" onclick="alert(1)` |
| GET /97?query= | frameset onload (legacy) | `');alert(1);//` |
| GET /98?query= | frame src (legacy) | `javascript:alert(1)` |
| GET /99?query= | keygen autofocus (deprecated) | `');alert(1);//` |
| GET /100?query= | menu item onclick | `');alert(1);//` |

### Filtered XSS Endpoints (101-200)

These endpoints have various protection/filter mechanisms. The challenge is to bypass these filters.

| Endpoint | Filter Type | Description |
|----------|------------|-------------|
| GET /101?query= | Remove single quotes | Removes `'` characters |
| GET /102?query= | Remove double quotes | Removes `"` characters |
| GET /103?query= | Remove quotes | Removes both `'` and `"` |
| GET /104?query= | Block alert | Removes `alert` keyword (case-sensitive) |
| GET /105?query= | Block alert (case-insensitive) | Removes `alert` keyword (any case) |
| GET /106?query= | Remove script tags | Removes `<script>` and `</script>` |
| GET /107?query= | Remove script blocks | Removes entire `<script>...</script>` blocks |
| GET /108?query= | Remove on* handlers | Removes event handlers like `onclick=`, `onerror=` |
| GET /109?query= | Remove javascript: | Removes `javascript:` protocol |
| GET /110?query= | Remove angle brackets | Removes `<` and `>` |
| GET /111?query= | Encode angle brackets | Encodes `<` to `&lt;` and `>` to `&gt;` |
| GET /112?query= | Remove parentheses | Removes `(` and `)` |
| GET /113?query= | Remove backticks | Removes `` ` `` characters |
| GET /114?query= | Block confirm | Removes `confirm` keyword |
| GET /115?query= | Block prompt | Removes `prompt` keyword |
| GET /116?query= | Block dialog functions | Removes `alert`, `confirm`, `prompt` |
| GET /117?query= | Block eval | Removes `eval` keyword |
| GET /118?query= | Block document | Removes `document` keyword |
| GET /119?query= | Block cookie | Removes `cookie` keyword |
| GET /120?query= | Block window | Removes `window` keyword |
| GET /121?query= | Block location | Removes `location` keyword |
| GET /122?query= | Block innerHTML | Removes `innerHTML` keyword |
| GET /123?query= | Remove src= | Removes `src=` attribute |
| GET /124?query= | Remove href= | Removes `href=` attribute |
| GET /125?query= | Remove data: | Removes `data:` protocol |
| GET /126?query= | Remove vbscript: | Removes `vbscript:` protocol |
| GET /127?query= | Max 50 chars | Truncates input to 50 characters |
| GET /128?query= | Max 20 chars | Truncates input to 20 characters |
| GET /129?query= | Alphanumeric only | Removes all non-alphanumeric characters |
| GET /130?query= | Alphanumeric + spaces | Allows only alphanumeric and spaces |
| GET /131?query= | Remove img tags | Removes `<img>` tags |
| GET /132?query= | Remove svg tags | Removes `<svg>...</svg>` blocks |
| GET /133?query= | Remove iframe tags | Removes `<iframe>...</iframe>` blocks |
| GET /134?query= | Remove object tags | Removes `<object>...</object>` blocks |
| GET /135?query= | Remove embed tags | Removes `<embed>` tags |
| GET /136?query= | Remove form tags | Removes `<form>...</form>` blocks |
| GET /137?query= | Remove input tags | Removes `<input>` tags |
| GET /138?query= | Remove body tags | Removes `<body>` tags |
| GET /139?query= | Remove style tags | Removes `<style>...</style>` blocks |
| GET /140?query= | Remove link tags | Removes `<link>` tags |
| GET /141?query= | Remove meta tags | Removes `<meta>` tags |
| GET /142?query= | Remove base tags | Removes `<base>` tags |
| GET /143?query= | Encode single quotes | Encodes `'` to `&#39;` |
| GET /144?query= | Encode double quotes | Encodes `"` to `&quot;` |
| GET /145?query= | Encode ampersand | Encodes `&` to `&amp;` |
| GET /146?query= | HTML escape | Full HTML entity encoding |
| GET /147?query= | URL encode | URL encodes the input |
| GET /148?query= | Double URL encode | Double URL encoding |
| GET /149?query= | Remove newlines | Removes `\r` and `\n` |
| GET /150?query= | Remove tabs | Removes tab characters |
| GET /151?query= | Remove whitespace | Removes all whitespace |
| GET /152?query= | Normalize spaces | Collapses multiple spaces to single |
| GET /153?query= | Remove null bytes | Removes null bytes (`\x00`) |
| GET /154?query= | Remove backslash | Removes `\` characters |
| GET /155?query= | Remove forward slash | Removes `/` characters |
| GET /156?query= | Remove semicolon | Removes `;` characters |
| GET /157?query= | Remove colon | Removes `:` characters |
| GET /158?query= | Remove equals | Removes `=` characters |
| GET /159?query= | Remove curly braces | Removes `{` and `}` |
| GET /160?query= | Remove square brackets | Removes `[` and `]` |
| GET /161?query= | Replace script once | Replaces `script` only once |
| GET /162?query= | Replace alert once | Replaces `alert` only once |
| GET /163?query= | Lowercase input | Converts all to lowercase |
| GET /164?query= | Uppercase input | Converts all to uppercase |
| GET /165?query= | Reverse input | Reverses the input string |
| GET /166?query= | Remove onerror | Removes `onerror` specifically |
| GET /167?query= | Remove onload | Removes `onload` specifically |
| GET /168?query= | Remove onclick | Removes `onclick` specifically |
| GET /169?query= | Remove onmouseover | Removes `onmouseover` specifically |
| GET /170?query= | Remove onfocus | Removes `onfocus` specifically |
| GET /171?query= | WAF blacklist | Removes common XSS keywords |
| GET /172?query= | WAF tags + events | Removes dangerous tags and events |
| GET /173?query= | Remove expression | Removes CSS `expression` |
| GET /174?query= | Remove url() | Removes CSS `url(` |
| GET /175?query= | Remove behavior | Removes CSS `behavior` (IE) |
| GET /176?query= | Remove -moz-binding | Removes CSS `-moz-binding` (Firefox) |
| GET /177?query= | Escape quotes in JS | Escapes single quotes with backslash |
| GET /178?query= | Escape double quotes in JS | Escapes double quotes with backslash |
| GET /179?query= | Remove Function | Removes `Function` constructor |
| GET /180?query= | Remove constructor | Removes `constructor` keyword |
| GET /181?query= | Remove prototype | Removes `prototype` keyword |
| GET /182?query= | Remove __proto__ | Removes `__proto__` keyword |
| GET /183?query= | Remove fetch | Removes `fetch` keyword |
| GET /184?query= | Remove XMLHttpRequest | Removes `XMLHttpRequest` keyword |
| GET /185?query= | Remove fromCharCode | Removes `String.fromCharCode` |
| GET /186?query= | Remove atob | Removes `atob` (base64 decode) |
| GET /187?query= | Remove btoa | Removes `btoa` (base64 encode) |
| GET /188?query= | Remove setTimeout | Removes `setTimeout` |
| GET /189?query= | Remove setInterval | Removes `setInterval` |
| GET /190?query= | Remove Unicode escapes | Removes `\uXXXX` sequences |
| GET /191?query= | Remove numeric entities | Removes `&#xxx;` entities |
| GET /192?query= | Remove hex entities | Removes `&#xXXX;` entities |
| GET /193?query= | Remove all HTML entities | Removes all `&xxx;` entities |
| GET /194?query= | Strip all tags | Removes all HTML tags |
| GET /195?query= | Multi (quotes+script+on*) | Combined filter: quotes, script, events |
| GET /196?query= | Multi (brackets+javascript) | Combined: angle brackets + javascript: |
| GET /197?query= | CSP simulation | Replaces script blocks with [BLOCKED] |
| GET /198?query= | Replace dangerous with _ | Replaces dangerous chars with underscore |
| GET /199?query= | Recursive script removal | Recursively removes script tags |
| GET /200?query= | Comprehensive WAF | Full WAF-style protection |

## License

MIT License