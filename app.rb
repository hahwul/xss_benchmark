# frozen_string_literal: true

require 'sinatra'

set :bind, '0.0.0.0'
set :port, 3000

# Helper for HTML template
def html_template(title, content)
  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>#{title}</title>
    </head>
    <body>
      <h1>XSS Benchmark - Case #{title}</h1>
      #{content}
      <hr>
      <a href="/">Back to Index</a>
    </body>
    </html>
  HTML
end

# Index page listing all endpoints
get '/' do
  endpoints = (1..100).map do |i|
    "<li><a href='/#{i}?query=test'>Endpoint #{i}</a></li>"
  end.join("\n")

  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>XSS Benchmark</title>
    </head>
    <body>
      <h1>XSS Benchmark Server</h1>
      <p>Each endpoint has a different XSS vulnerability pattern. Use the <code>query</code> parameter.</p>
      <ul>
        #{endpoints}
      </ul>
    </body>
    </html>
  HTML
end

# Case 1: Basic reflected XSS in HTML body
get '/1' do
  query = params[:query] || ''
  html_template('1', "<p>Search result for: #{query}</p>")
end

# Case 2: XSS in HTML attribute (unquoted)
get '/2' do
  query = params[:query] || ''
  html_template('2', "<input type=text value=#{query}>")
end

# Case 3: XSS in HTML attribute (single quoted)
get '/3' do
  query = params[:query] || ''
  html_template('3', "<input type='text' value='#{query}'>")
end

# Case 4: XSS in HTML attribute (double quoted)
get '/4' do
  query = params[:query] || ''
  html_template('4', "<input type=\"text\" value=\"#{query}\">")
end

# Case 5: XSS in href attribute
get '/5' do
  query = params[:query] || ''
  html_template('5', "<a href=\"#{query}\">Click here</a>")
end

# Case 6: XSS in script tag context
get '/6' do
  query = params[:query] || ''
  html_template('6', "<script>var data = '#{query}';</script><p>Check console</p>")
end

# Case 7: XSS in script tag with double quotes
get '/7' do
  query = params[:query] || ''
  html_template('7', "<script>var data = \"#{query}\";</script><p>Check console</p>")
end

# Case 8: XSS in onclick event handler
get '/8' do
  query = params[:query] || ''
  html_template('8', "<button onclick=\"alert('#{query}')\">Click me</button>")
end

# Case 9: XSS in img src attribute
get '/9' do
  query = params[:query] || ''
  html_template('9', "<img src=\"#{query}\" alt=\"image\">")
end

# Case 10: XSS in img onerror attribute
get '/10' do
  query = params[:query] || ''
  html_template('10', "<img src=\"x\" onerror=\"console.log('#{query}')\">")
end

# Case 11: XSS in style attribute
get '/11' do
  query = params[:query] || ''
  html_template('11', "<div style=\"background: #{query}\">Styled div</div>")
end

# Case 12: XSS in textarea
get '/12' do
  query = params[:query] || ''
  html_template('12', "<textarea>#{query}</textarea>")
end

# Case 13: XSS in title tag
get '/13' do
  query = params[:query] || ''
  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>#{query}</title>
    </head>
    <body>
      <h1>XSS Benchmark - Case 13</h1>
      <p>Check the page title</p>
      <hr>
      <a href="/">Back to Index</a>
    </body>
    </html>
  HTML
end

# Case 14: XSS in iframe src
get '/14' do
  query = params[:query] || ''
  html_template('14', "<iframe src=\"#{query}\" width=\"300\" height=\"200\"></iframe>")
end

# Case 15: XSS in SVG
get '/15' do
  query = params[:query] || ''
  html_template('15', "<svg><text x=\"10\" y=\"20\">#{query}</text></svg>")
end

# Case 16: XSS in data attribute
get '/16' do
  query = params[:query] || ''
  html_template('16', "<div data-info=\"#{query}\">Data attribute content</div>")
end

# Case 17: XSS in meta refresh
get '/17' do
  query = params[:query] || ''
  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <meta http-equiv="refresh" content="0;url=#{query}">
      <title>17</title>
    </head>
    <body>
      <h1>XSS Benchmark - Case 17</h1>
      <p>Meta refresh redirect</p>
      <hr>
      <a href="/">Back to Index</a>
    </body>
    </html>
  HTML
end

# Case 18: XSS in object data attribute
get '/18' do
  query = params[:query] || ''
  html_template('18', "<object data=\"#{query}\">Object content</object>")
end

# Case 19: XSS in embed src
get '/19' do
  query = params[:query] || ''
  html_template('19', "<embed src=\"#{query}\">")
end

# Case 20: XSS in form action
get '/20' do
  query = params[:query] || ''
  html_template('20', "<form action=\"#{query}\"><input type=\"submit\" value=\"Submit\"></form>")
end

# Case 21: XSS in body onload event
get '/21' do
  query = params[:query] || ''
  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>21</title>
    </head>
    <body onload="console.log('#{query}')">
      <h1>XSS Benchmark - Case 21</h1>
      <p>Body onload event</p>
      <hr>
      <a href="/">Back to Index</a>
    </body>
    </html>
  HTML
end

# Case 22: XSS in onmouseover event handler
get '/22' do
  query = params[:query] || ''
  html_template('22', "<div onmouseover=\"alert('#{query}')\">Hover over me</div>")
end

# Case 23: XSS in onfocus event handler
get '/23' do
  query = params[:query] || ''
  html_template('23', "<input type=\"text\" onfocus=\"alert('#{query}')\" value=\"Click me\">")
end

# Case 24: XSS in oninput event handler
get '/24' do
  query = params[:query] || ''
  html_template('24', "<input type=\"text\" oninput=\"console.log('#{query}')\">")
end

# Case 25: XSS in onchange event handler
get '/25' do
  query = params[:query] || ''
  html_template('25', "<select onchange=\"console.log('#{query}')\"><option>Choose</option><option>Option 1</option></select>")
end

# Case 26: XSS in JavaScript template literal
# Note: Template literals use backticks which can be tricky to escape
get '/26' do
  query = params[:query] || ''
  html_template('26', "<script>var msg = `Hello #{query}`;</script><p>Check console</p>")
end

# Case 27: XSS in innerHTML context (DOM XSS simulation)
get '/27' do
  query = params[:query] || ''
  html_template('27', "<div id=\"target\"></div><script>document.getElementById('target').innerHTML = '#{query}';</script>")
end

# Case 28: XSS in document.write context (DOM XSS simulation)
get '/28' do
  query = params[:query] || ''
  html_template('28', "<script>document.write('#{query}');</script>")
end

# Case 29: XSS in HTML comment
get '/29' do
  query = params[:query] || ''
  html_template('29', "<!-- User comment: #{query} --><p>Check page source for comment</p>")
end

# Case 30: XSS in style tag
get '/30' do
  query = params[:query] || ''
  html_template('30', "<style>.test { color: #{query}; }</style><p class=\"test\">Styled text</p>")
end

# Case 31: XSS in base tag href
get '/31' do
  query = params[:query] || ''
  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <base href="#{query}">
      <title>31</title>
    </head>
    <body>
      <h1>XSS Benchmark - Case 31</h1>
      <p>Base tag injection</p>
      <hr>
      <a href="/">Back to Index</a>
    </body>
    </html>
  HTML
end

# Case 32: XSS in link href (stylesheet)
get '/32' do
  query = params[:query] || ''
  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <link rel="stylesheet" href="#{query}">
      <title>32</title>
    </head>
    <body>
      <h1>XSS Benchmark - Case 32</h1>
      <p>Link stylesheet injection</p>
      <hr>
      <a href="/">Back to Index</a>
    </body>
    </html>
  HTML
end

# Case 33: XSS in script src attribute
get '/33' do
  query = params[:query] || ''
  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <script src="#{query}"></script>
      <title>33</title>
    </head>
    <body>
      <h1>XSS Benchmark - Case 33</h1>
      <p>Script src injection</p>
      <hr>
      <a href="/">Back to Index</a>
    </body>
    </html>
  HTML
end

# Case 34: XSS in img srcset attribute
get '/34' do
  query = params[:query] || ''
  html_template('34', "<img srcset=\"#{query}\" alt=\"image\">")
end

# Case 35: XSS in video poster attribute
get '/35' do
  query = params[:query] || ''
  html_template('35', "<video poster=\"#{query}\" controls><source src=\"movie.mp4\"></video>")
end

# Case 36: XSS in video src attribute
get '/36' do
  query = params[:query] || ''
  html_template('36', "<video src=\"#{query}\" controls></video>")
end

# Case 37: XSS in audio src attribute
get '/37' do
  query = params[:query] || ''
  html_template('37', "<audio src=\"#{query}\" controls></audio>")
end

# Case 38: XSS in source src attribute
get '/38' do
  query = params[:query] || ''
  html_template('38', "<video controls><source src=\"#{query}\"></video>")
end

# Case 39: XSS in track src attribute
get '/39' do
  query = params[:query] || ''
  html_template('39', "<video controls><track src=\"#{query}\" kind=\"subtitles\"></video>")
end

# Case 40: XSS in formaction attribute
get '/40' do
  query = params[:query] || ''
  html_template('40', "<form><button formaction=\"#{query}\" type=\"submit\">Submit</button></form>")
end

# Case 41: XSS in iframe srcdoc attribute
get '/41' do
  query = params[:query] || ''
  html_template('41', "<iframe srcdoc=\"#{query}\" width=\"300\" height=\"200\"></iframe>")
end

# Case 42: XSS in SVG onload event
get '/42' do
  query = params[:query] || ''
  html_template('42', "<svg onload=\"alert('#{query}')\"><circle cx=\"50\" cy=\"50\" r=\"40\"/></svg>")
end

# Case 43: XSS in SVG href (xlink:href)
get '/43' do
  query = params[:query] || ''
  html_template('43', "<svg><a href=\"#{query}\"><text x=\"10\" y=\"20\">Click me</text></a></svg>")
end

# Case 44: XSS in MathML context
get '/44' do
  query = params[:query] || ''
  html_template('44', "<math><mtext>#{query}</mtext></math>")
end

# Case 45: XSS in details/summary tag
get '/45' do
  query = params[:query] || ''
  html_template('45', "<details ontoggle=\"console.log('#{query}')\"><summary>Click to expand</summary><p>Content</p></details>")
end

# Case 46: XSS in marquee tag (deprecated HTML element, included for legacy testing)
get '/46' do
  query = params[:query] || ''
  html_template('46', "<marquee onstart=\"alert('#{query}')\">Scrolling text</marquee>")
end

# Case 47: XSS in contenteditable attribute
get '/47' do
  query = params[:query] || ''
  html_template('47', "<div contenteditable=\"true\" onfocus=\"alert('#{query}')\">Edit this text</div>")
end

# Case 48: XSS in autofocus attribute
get '/48' do
  query = params[:query] || ''
  html_template('48', "<input autofocus onfocus=\"alert('#{query}')\">")
end

# Case 49: XSS in JSON context
# Note: Unescaped quotes in query can break JSON parsing, demonstrating injection risk
get '/49' do
  query = params[:query] || ''
  html_template('49', "<script>var config = {\"name\": \"#{query}\"};</script><p>Check console</p>")
end

# Case 50: XSS in noscript tag
get '/50' do
  query = params[:query] || ''
  html_template('50', "<noscript>#{query}</noscript><p>Enable JavaScript to hide content</p>")
end

# Case 51: XSS in URL fragment (DOM-based)
get '/51' do
  query = params[:query] || ''
  html_template('51', "<div id=\"output\"></div><script>document.getElementById('output').innerHTML = location.hash.substring(1) || '#{query}';</script>")
end

# Case 52: XSS in window.name (DOM-based)
get '/52' do
  query = params[:query] || ''
  html_template('52', "<div id=\"output\"></div><script>if(window.name) { document.getElementById('output').innerHTML = window.name; } else { document.getElementById('output').innerHTML = '#{query}'; }</script>")
end

# Case 53: XSS in location.search (DOM-based)
get '/53' do
  query = params[:query] || ''
  html_template('53', "<div id=\"output\"></div><script>var params = new URLSearchParams(location.search); document.getElementById('output').innerHTML = params.get('query') || '#{query}';</script>")
end

# Case 54: XSS in CSS @import url
get '/54' do
  query = params[:query] || ''
  html_template('54', "<style>@import url('#{query}');</style><p>CSS import injection</p>")
end

# Case 55: XSS in setTimeout context
get '/55' do
  query = params[:query] || ''
  html_template('55', "<script>setTimeout('console.log(\"#{query}\")', 100);</script><p>Check console</p>")
end

# Case 56: XSS in setInterval context
get '/56' do
  query = params[:query] || ''
  html_template('56', "<script>var i = setInterval('console.log(\"#{query}\")', 100); setTimeout(function(){clearInterval(i);}, 500);</script><p>Check console</p>")
end

# Case 57: XSS in eval context
get '/57' do
  query = params[:query] || ''
  html_template('57', "<script>eval('console.log(\"#{query}\")');</script><p>Check console</p>")
end

# Case 58: XSS in Function constructor
get '/58' do
  query = params[:query] || ''
  html_template('58', "<script>new Function('console.log(\"#{query}\")')();</script><p>Check console</p>")
end

# Case 59: XSS in postMessage handler
get '/59' do
  query = params[:query] || ''
  html_template('59', "<div id=\"output\"></div><script>window.addEventListener('message', function(e) { document.getElementById('output').innerHTML = e.data; }); document.getElementById('output').innerHTML = '#{query}';</script>")
end

# Case 60: XSS in document.cookie setter
get '/60' do
  query = params[:query] || ''
  html_template('60', "<script>document.cookie = 'test=#{query}';</script><p>Cookie injection</p>")
end

# Case 61: XSS in localStorage
get '/61' do
  query = params[:query] || ''
  html_template('61', "<script>localStorage.setItem('data', '#{query}'); document.write(localStorage.getItem('data'));</script>")
end

# Case 62: XSS in sessionStorage
get '/62' do
  query = params[:query] || ''
  html_template('62', "<script>sessionStorage.setItem('data', '#{query}'); document.write(sessionStorage.getItem('data'));</script>")
end

# Case 63: XSS in XMLHttpRequest open URL
get '/63' do
  query = params[:query] || ''
  html_template('63', "<script>var xhr = new XMLHttpRequest(); xhr.open('GET', '#{query}', true); xhr.send();</script><p>XHR request sent</p>")
end

# Case 64: XSS in fetch URL
get '/64' do
  query = params[:query] || ''
  html_template('64', "<script>fetch('#{query}').then(r => console.log('fetched'));</script><p>Fetch request sent</p>")
end

# Case 65: XSS in Worker URL
get '/65' do
  query = params[:query] || ''
  html_template('65', "<script>try { new Worker('#{query}'); } catch(e) { console.log(e); }</script><p>Worker injection</p>")
end

# Case 66: XSS in SharedWorker URL
get '/66' do
  query = params[:query] || ''
  html_template('66', "<script>try { new SharedWorker('#{query}'); } catch(e) { console.log(e); }</script><p>SharedWorker injection</p>")
end

# Case 67: XSS in aria-label attribute
get '/67' do
  query = params[:query] || ''
  html_template('67', "<button aria-label=\"#{query}\">Accessible button</button>")
end

# Case 68: XSS in input placeholder attribute
get '/68' do
  query = params[:query] || ''
  html_template('68', "<input type=\"text\" placeholder=\"#{query}\">")
end

# Case 69: XSS in img alt attribute
get '/69' do
  query = params[:query] || ''
  html_template('69', "<img src=\"x\" alt=\"#{query}\">")
end

# Case 70: XSS in button type attribute
get '/70' do
  query = params[:query] || ''
  html_template('70', "<button type=\"#{query}\">Button</button>")
end

# Case 71: XSS in input type attribute
get '/71' do
  query = params[:query] || ''
  html_template('71', "<input type=\"#{query}\" value=\"test\">")
end

# Case 72: XSS in body background attribute (legacy)
# Note: Uses custom HTML template because body background attribute must be on the body element
get '/72' do
  query = params[:query] || ''
  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>72</title>
    </head>
    <body background="#{query}">
      <h1>XSS Benchmark - Case 72</h1>
      <p>Body background attribute</p>
      <hr>
      <a href="/">Back to Index</a>
    </body>
    </html>
  HTML
end

# Case 73: XSS in table background attribute (legacy)
get '/73' do
  query = params[:query] || ''
  html_template('73', "<table background=\"#{query}\"><tr><td>Table with background</td></tr></table>")
end

# Case 74: XSS in td background attribute (legacy)
get '/74' do
  query = params[:query] || ''
  html_template('74', "<table><tr><td background=\"#{query}\">Cell with background</td></tr></table>")
end

# Case 75: XSS in bgsound src attribute (legacy IE)
get '/75' do
  query = params[:query] || ''
  html_template('75', "<bgsound src=\"#{query}\"><p>Legacy bgsound element</p>")
end

# Case 76: XSS in layer src attribute (legacy Netscape)
get '/76' do
  query = params[:query] || ''
  html_template('76', "<layer src=\"#{query}\">Legacy layer element</layer>")
end

# Case 77: XSS in input formmethod attribute
get '/77' do
  query = params[:query] || ''
  html_template('77', "<form><input type=\"submit\" formmethod=\"#{query}\" value=\"Submit\"></form>")
end

# Case 78: XSS in input formenctype attribute
get '/78' do
  query = params[:query] || ''
  html_template('78', "<form><input type=\"submit\" formenctype=\"#{query}\" value=\"Submit\"></form>")
end

# Case 79: XSS in input formtarget attribute
get '/79' do
  query = params[:query] || ''
  html_template('79', "<form><input type=\"submit\" formtarget=\"#{query}\" value=\"Submit\"></form>")
end

# Case 80: XSS in a target attribute
get '/80' do
  query = params[:query] || ''
  html_template('80', "<a href=\"#\" target=\"#{query}\">Link with target</a>")
end

# Case 81: XSS in a download attribute
get '/81' do
  query = params[:query] || ''
  html_template('81', "<a href=\"#\" download=\"#{query}\">Download link</a>")
end

# Case 82: XSS in area href attribute
get '/82' do
  query = params[:query] || ''
  html_template('82', "<map name=\"testmap\"><area shape=\"rect\" coords=\"0,0,100,100\" href=\"#{query}\"></map><img usemap=\"#testmap\" src=\"x\" width=\"100\" height=\"100\">")
end

# Case 83: XSS in blockquote cite attribute
get '/83' do
  query = params[:query] || ''
  html_template('83', "<blockquote cite=\"#{query}\">This is a quote</blockquote>")
end

# Case 84: XSS in q cite attribute
get '/84' do
  query = params[:query] || ''
  html_template('84', "<q cite=\"#{query}\">This is an inline quote</q>")
end

# Case 85: XSS in ins cite attribute
get '/85' do
  query = params[:query] || ''
  html_template('85', "<ins cite=\"#{query}\">Inserted text</ins>")
end

# Case 86: XSS in del cite attribute
get '/86' do
  query = params[:query] || ''
  html_template('86', "<del cite=\"#{query}\">Deleted text</del>")
end

# Case 87: XSS in applet codebase attribute (legacy)
get '/87' do
  query = params[:query] || ''
  html_template('87', "<applet codebase=\"#{query}\" code=\"test\">Legacy applet</applet>")
end

# Case 88: XSS in applet code attribute (legacy)
get '/88' do
  query = params[:query] || ''
  html_template('88', "<applet code=\"#{query}\">Legacy applet</applet>")
end

# Case 89: XSS in object codebase attribute
get '/89' do
  query = params[:query] || ''
  html_template('89', "<object codebase=\"#{query}\">Object with codebase</object>")
end

# Case 90: XSS in object classid attribute
get '/90' do
  query = params[:query] || ''
  html_template('90', "<object classid=\"#{query}\">Object with classid</object>")
end

# Case 91: XSS in param value attribute
get '/91' do
  query = params[:query] || ''
  html_template('91', "<object><param name=\"movie\" value=\"#{query}\"></object>")
end

# Case 92: XSS in XML data island (IE specific)
get '/92' do
  query = params[:query] || ''
  html_template('92', "<xml id=\"data\"><item>#{query}</item></xml><p>XML data island</p>")
end

# Case 93: XSS in xmp tag (deprecated)
get '/93' do
  query = params[:query] || ''
  html_template('93', "<xmp>#{query}</xmp>")
end

# Case 94: XSS in listing tag (deprecated)
get '/94' do
  query = params[:query] || ''
  html_template('94', "<listing>#{query}</listing>")
end

# Case 95: XSS in plaintext tag (deprecated)
# Note: The plaintext tag intentionally has no closing tag as it causes all following content
# to be rendered as plain text. This is the intended behavior of this deprecated element.
get '/95' do
  query = params[:query] || ''
  html_template('95', "<div>Before plaintext</div><plaintext>#{query}")
end

# Case 96: XSS in isindex prompt attribute (deprecated)
get '/96' do
  query = params[:query] || ''
  html_template('96', "<isindex prompt=\"#{query}\">")
end

# Case 97: XSS in frameset onload (legacy)
# Note: Uses custom HTML template because frameset replaces the body element
get '/97' do
  query = params[:query] || ''
  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>97</title>
    </head>
    <frameset onload="console.log('#{query}')">
      <frame src="about:blank">
    </frameset>
    </html>
  HTML
end

# Case 98: XSS in frame src (legacy)
# Note: Uses custom HTML template because frameset replaces the body element
get '/98' do
  query = params[:query] || ''
  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>98</title>
    </head>
    <frameset>
      <frame src="#{query}">
    </frameset>
    </html>
  HTML
end

# Case 99: XSS in keygen autofocus (deprecated)
get '/99' do
  query = params[:query] || ''
  html_template('99', "<keygen autofocus onfocus=\"alert('#{query}')\">")
end

# Case 100: XSS in menu item onclick
get '/100' do
  query = params[:query] || ''
  html_template('100', "<menu type=\"context\" id=\"mymenu\"><menuitem onclick=\"alert('#{query}')\">Menu item</menuitem></menu>")
end
