# XSS Benchmark

A Sinatra-based XSS vulnerability benchmark server for testing XSS detection tools.

## Overview

This server provides 20 different XSS vulnerable endpoints, each demonstrating a different XSS injection context. All endpoints use the GET method and accept a `query` parameter.

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

## License

MIT License