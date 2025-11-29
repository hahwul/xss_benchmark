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
  basic_endpoints = (1..100).map do |i|
    "<li><a href='/#{i}?query=test'>Endpoint #{i} - Basic XSS</a></li>"
  end.join("\n")

  filter_endpoints = (101..200).map do |i|
    "<li><a href='/#{i}?query=test'>Endpoint #{i} - With Filter</a></li>"
  end.join("\n")

  <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>XSS Benchmark</title>
      <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { color: #333; }
        h2 { color: #666; margin-top: 30px; }
        ul { columns: 3; -webkit-columns: 3; -moz-columns: 3; }
        li { margin: 5px 0; }
        a { color: #0066cc; text-decoration: none; }
        a:hover { text-decoration: underline; }
        .section { margin-bottom: 40px; }
        .description { background: #f5f5f5; padding: 15px; border-radius: 5px; margin: 20px 0; }
      </style>
    </head>
    <body>
      <h1>XSS Benchmark Server</h1>
      <div class="description">
        <p>Each endpoint has a different XSS vulnerability pattern. Use the <code>query</code> parameter.</p>
        <p><strong>Total Endpoints:</strong> 200 (100 basic XSS + 100 with protection filters)</p>
      </div>

      <div class="section">
        <h2>Basic XSS Endpoints (1-100)</h2>
        <p>These endpoints have no protection and are vulnerable to various XSS injection techniques.</p>
        <ul>
          #{basic_endpoints}
        </ul>
      </div>

      <div class="section">
        <h2>Filtered XSS Endpoints (101-200)</h2>
        <p>These endpoints have various protection mechanisms (filters) that need to be bypassed.</p>
        <ul>
          #{filter_endpoints}
        </ul>
      </div>
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

# ============================================
# Cases 101-200: Protection/Filter Mechanisms
# ============================================

# Case 101: Filter - Remove single quotes (')
get '/101' do
  query = (params[:query] || '').gsub("'", '')
  html_template('101 [Filter: Remove single quotes]', "<p>Search result for: #{query}</p>")
end

# Case 102: Filter - Remove double quotes (")
get '/102' do
  query = (params[:query] || '').gsub('"', '')
  html_template('102 [Filter: Remove double quotes]', "<p>Search result for: #{query}</p>")
end

# Case 103: Filter - Remove both single and double quotes
get '/103' do
  query = (params[:query] || '').gsub(/['"]/, '')
  html_template('103 [Filter: Remove quotes]', "<p>Search result for: #{query}</p>")
end

# Case 104: Filter - Block 'alert' keyword (case-sensitive)
get '/104' do
  query = (params[:query] || '').gsub('alert', '')
  html_template('104 [Filter: Block alert]', "<p>Search result for: #{query}</p>")
end

# Case 105: Filter - Block 'alert' keyword (case-insensitive)
get '/105' do
  query = (params[:query] || '').gsub(/alert/i, '')
  html_template('105 [Filter: Block alert (case-insensitive)]', "<p>Search result for: #{query}</p>")
end

# Case 106: Filter - Remove <script> tags (case-sensitive)
get '/106' do
  query = (params[:query] || '').gsub(/<script>/i, '').gsub(/<\/script>/i, '')
  html_template('106 [Filter: Remove script tags]', "<p>Search result for: #{query}</p>")
end

# Case 107: Filter - Remove all script tags with regex
get '/107' do
  query = (params[:query] || '').gsub(/<script[^>]*>.*?<\/script>/im, '')
  html_template('107 [Filter: Remove script blocks]', "<p>Search result for: #{query}</p>")
end

# Case 108: Filter - Remove 'on' event handlers (simple)
get '/108' do
  query = (params[:query] || '').gsub(/on\w+\s*=/i, '')
  html_template('108 [Filter: Remove on* handlers]', "<p>Search result for: #{query}</p>")
end

# Case 109: Filter - Remove 'javascript:' protocol
get '/109' do
  query = (params[:query] || '').gsub(/javascript:/i, '')
  html_template('109 [Filter: Remove javascript:]', "<a href=\"#{query}\">Click here</a>")
end

# Case 110: Filter - Remove angle brackets
get '/110' do
  query = (params[:query] || '').gsub(/[<>]/, '')
  html_template('110 [Filter: Remove angle brackets]', "<p>Search result for: #{query}</p>")
end

# Case 111: Filter - HTML entity encode angle brackets only
get '/111' do
  query = (params[:query] || '').gsub('<', '&lt;').gsub('>', '&gt;')
  html_template('111 [Filter: Encode angle brackets]', "<p>Search result for: #{query}</p>")
end

# Case 112: Filter - Remove parentheses
get '/112' do
  query = (params[:query] || '').gsub(/[()]/, '')
  html_template('112 [Filter: Remove parentheses]', "<p>Search result for: #{query}</p>")
end

# Case 113: Filter - Remove backticks
get '/113' do
  query = (params[:query] || '').gsub('`', '')
  html_template('113 [Filter: Remove backticks]', "<script>var data = `#{query}`;</script><p>Check console</p>")
end

# Case 114: Filter - Remove 'confirm' keyword
get '/114' do
  query = (params[:query] || '').gsub(/confirm/i, '')
  html_template('114 [Filter: Block confirm]', "<p>Search result for: #{query}</p>")
end

# Case 115: Filter - Remove 'prompt' keyword
get '/115' do
  query = (params[:query] || '').gsub(/prompt/i, '')
  html_template('115 [Filter: Block prompt]', "<p>Search result for: #{query}</p>")
end

# Case 116: Filter - Remove alert, confirm, prompt (all dialog functions)
get '/116' do
  query = (params[:query] || '').gsub(/alert|confirm|prompt/i, '')
  html_template('116 [Filter: Block dialog functions]', "<p>Search result for: #{query}</p>")
end

# Case 117: Filter - Remove 'eval' keyword
get '/117' do
  query = (params[:query] || '').gsub(/eval/i, '')
  html_template('117 [Filter: Block eval]', "<p>Search result for: #{query}</p>")
end

# Case 118: Filter - Remove 'document' keyword
get '/118' do
  query = (params[:query] || '').gsub(/document/i, '')
  html_template('118 [Filter: Block document]', "<script>var x = '#{query}';</script><p>Check console</p>")
end

# Case 119: Filter - Remove 'cookie' keyword
get '/119' do
  query = (params[:query] || '').gsub(/cookie/i, '')
  html_template('119 [Filter: Block cookie]', "<script>var x = '#{query}';</script><p>Check console</p>")
end

# Case 120: Filter - Remove 'window' keyword
get '/120' do
  query = (params[:query] || '').gsub(/window/i, '')
  html_template('120 [Filter: Block window]', "<script>var x = '#{query}';</script><p>Check console</p>")
end

# Case 121: Filter - Remove 'location' keyword
get '/121' do
  query = (params[:query] || '').gsub(/location/i, '')
  html_template('121 [Filter: Block location]', "<script>var x = '#{query}';</script><p>Check console</p>")
end

# Case 122: Filter - Remove 'innerHTML' keyword
get '/122' do
  query = (params[:query] || '').gsub(/innerHTML/i, '')
  html_template('122 [Filter: Block innerHTML]', "<script>var x = '#{query}';</script><p>Check console</p>")
end

# Case 123: Filter - Remove 'src' attribute
get '/123' do
  query = (params[:query] || '').gsub(/src\s*=/i, '')
  html_template('123 [Filter: Remove src=]', "<img #{query}>")
end

# Case 124: Filter - Remove 'href' attribute
get '/124' do
  query = (params[:query] || '').gsub(/href\s*=/i, '')
  html_template('124 [Filter: Remove href=]', "<a #{query}>Link</a>")
end

# Case 125: Filter - Remove 'data:' protocol
get '/125' do
  query = (params[:query] || '').gsub(/data:/i, '')
  html_template('125 [Filter: Remove data:]', "<a href=\"#{query}\">Click here</a>")
end

# Case 126: Filter - Remove 'vbscript:' protocol
get '/126' do
  query = (params[:query] || '').gsub(/vbscript:/i, '')
  html_template('126 [Filter: Remove vbscript:]', "<a href=\"#{query}\">Click here</a>")
end

# Case 127: Filter - Length limit (50 chars)
get '/127' do
  query = (params[:query] || '')[0, 50]
  html_template('127 [Filter: Max 50 chars]', "<p>Search result for: #{query}</p>")
end

# Case 128: Filter - Length limit (20 chars)
get '/128' do
  query = (params[:query] || '')[0, 20]
  html_template('128 [Filter: Max 20 chars]', "<p>Search result for: #{query}</p>")
end

# Case 129: Filter - Alphanumeric only
get '/129' do
  query = (params[:query] || '').gsub(/[^a-zA-Z0-9]/, '')
  html_template('129 [Filter: Alphanumeric only]', "<p>Search result for: #{query}</p>")
end

# Case 130: Filter - Alphanumeric + spaces only
get '/130' do
  query = (params[:query] || '').gsub(/[^a-zA-Z0-9\s]/, '')
  html_template('130 [Filter: Alphanumeric + spaces]', "<p>Search result for: #{query}</p>")
end

# Case 131: Filter - Remove 'img' tag
get '/131' do
  query = (params[:query] || '').gsub(/<img[^>]*>/i, '')
  html_template('131 [Filter: Remove img tags]', "<p>Search result for: #{query}</p>")
end

# Case 132: Filter - Remove 'svg' tag
get '/132' do
  query = (params[:query] || '').gsub(/<svg[^>]*>.*?<\/svg>/im, '')
  html_template('132 [Filter: Remove svg tags]', "<p>Search result for: #{query}</p>")
end

# Case 133: Filter - Remove 'iframe' tag
get '/133' do
  query = (params[:query] || '').gsub(/<iframe[^>]*>.*?<\/iframe>/im, '')
  html_template('133 [Filter: Remove iframe tags]', "<p>Search result for: #{query}</p>")
end

# Case 134: Filter - Remove 'object' tag
get '/134' do
  query = (params[:query] || '').gsub(/<object[^>]*>.*?<\/object>/im, '')
  html_template('134 [Filter: Remove object tags]', "<p>Search result for: #{query}</p>")
end

# Case 135: Filter - Remove 'embed' tag
get '/135' do
  query = (params[:query] || '').gsub(/<embed[^>]*>/i, '')
  html_template('135 [Filter: Remove embed tags]', "<p>Search result for: #{query}</p>")
end

# Case 136: Filter - Remove 'form' tag
get '/136' do
  query = (params[:query] || '').gsub(/<form[^>]*>.*?<\/form>/im, '')
  html_template('136 [Filter: Remove form tags]', "<p>Search result for: #{query}</p>")
end

# Case 137: Filter - Remove 'input' tag
get '/137' do
  query = (params[:query] || '').gsub(/<input[^>]*>/i, '')
  html_template('137 [Filter: Remove input tags]', "<p>Search result for: #{query}</p>")
end

# Case 138: Filter - Remove 'body' tag
get '/138' do
  query = (params[:query] || '').gsub(/<body[^>]*>/i, '')
  html_template('138 [Filter: Remove body tags]', "<p>Search result for: #{query}</p>")
end

# Case 139: Filter - Remove 'style' tag
get '/139' do
  query = (params[:query] || '').gsub(/<style[^>]*>.*?<\/style>/im, '')
  html_template('139 [Filter: Remove style tags]', "<p>Search result for: #{query}</p>")
end

# Case 140: Filter - Remove 'link' tag
get '/140' do
  query = (params[:query] || '').gsub(/<link[^>]*>/i, '')
  html_template('140 [Filter: Remove link tags]', "<p>Search result for: #{query}</p>")
end

# Case 141: Filter - Remove 'meta' tag
get '/141' do
  query = (params[:query] || '').gsub(/<meta[^>]*>/i, '')
  html_template('141 [Filter: Remove meta tags]', "<p>Search result for: #{query}</p>")
end

# Case 142: Filter - Remove 'base' tag
get '/142' do
  query = (params[:query] || '').gsub(/<base[^>]*>/i, '')
  html_template('142 [Filter: Remove base tags]', "<p>Search result for: #{query}</p>")
end

# Case 143: Filter - Encode single quotes to HTML entity
get '/143' do
  query = (params[:query] || '').gsub("'", '&#39;')
  html_template('143 [Filter: Encode single quotes]', "<p>Search result for: #{query}</p>")
end

# Case 144: Filter - Encode double quotes to HTML entity
get '/144' do
  query = (params[:query] || '').gsub('"', '&quot;')
  html_template('144 [Filter: Encode double quotes]', "<p>Search result for: #{query}</p>")
end

# Case 145: Filter - Encode ampersand
get '/145' do
  query = (params[:query] || '').gsub('&', '&amp;')
  html_template('145 [Filter: Encode ampersand]', "<p>Search result for: #{query}</p>")
end

# Case 146: Filter - Full HTML entity encoding (basic)
get '/146' do
  require 'cgi'
  query = CGI.escapeHTML(params[:query] || '')
  html_template('146 [Filter: HTML escape]', "<p>Search result for: #{query}</p>")
end

# Case 147: Filter - URL encode
get '/147' do
  require 'cgi'
  query = CGI.escape(params[:query] || '')
  html_template('147 [Filter: URL encode]', "<p>Search result for: #{query}</p>")
end

# Case 148: Filter - Double URL encode
get '/148' do
  require 'cgi'
  query = CGI.escape(CGI.escape(params[:query] || ''))
  html_template('148 [Filter: Double URL encode]', "<p>Search result for: #{query}</p>")
end

# Case 149: Filter - Remove newlines
get '/149' do
  query = (params[:query] || '').gsub(/[\r\n]/, '')
  html_template('149 [Filter: Remove newlines]', "<p>Search result for: #{query}</p>")
end

# Case 150: Filter - Remove tabs
get '/150' do
  query = (params[:query] || '').gsub(/\t/, '')
  html_template('150 [Filter: Remove tabs]', "<p>Search result for: #{query}</p>")
end

# Case 151: Filter - Remove all whitespace
get '/151' do
  query = (params[:query] || '').gsub(/\s/, '')
  html_template('151 [Filter: Remove whitespace]', "<p>Search result for: #{query}</p>")
end

# Case 152: Filter - Normalize multiple spaces to single
get '/152' do
  query = (params[:query] || '').gsub(/\s+/, ' ')
  html_template('152 [Filter: Normalize spaces]', "<p>Search result for: #{query}</p>")
end

# Case 153: Filter - Remove null bytes
get '/153' do
  query = (params[:query] || '').gsub("\x00", '')
  html_template('153 [Filter: Remove null bytes]', "<p>Search result for: #{query}</p>")
end

# Case 154: Filter - Remove backslash
get '/154' do
  query = (params[:query] || '').gsub('\\', '')
  html_template('154 [Filter: Remove backslash]', "<script>var x = '#{query}';</script><p>Check console</p>")
end

# Case 155: Filter - Remove forward slash
get '/155' do
  query = (params[:query] || '').gsub('/', '')
  html_template('155 [Filter: Remove forward slash]', "<p>Search result for: #{query}</p>")
end

# Case 156: Filter - Remove semicolon
get '/156' do
  query = (params[:query] || '').gsub(';', '')
  html_template('156 [Filter: Remove semicolon]', "<script>var x = '#{query}'</script><p>Check console</p>")
end

# Case 157: Filter - Remove colon
get '/157' do
  query = (params[:query] || '').gsub(':', '')
  html_template('157 [Filter: Remove colon]', "<a href=\"#{query}\">Click here</a>")
end

# Case 158: Filter - Remove equals sign
get '/158' do
  query = (params[:query] || '').gsub('=', '')
  html_template('158 [Filter: Remove equals]', "<p>Search result for: #{query}</p>")
end

# Case 159: Filter - Remove curly braces
get '/159' do
  query = (params[:query] || '').gsub(/[{}]/, '')
  html_template('159 [Filter: Remove curly braces]', "<script>var x = `#{query}`;</script><p>Check console</p>")
end

# Case 160: Filter - Remove square brackets
get '/160' do
  query = (params[:query] || '').gsub(/[\[\]]/, '')
  html_template('160 [Filter: Remove square brackets]', "<script>var x = '#{query}';</script><p>Check console</p>")
end

# Case 161: Filter - Replace script with empty (one-time)
get '/161' do
  query = (params[:query] || '').sub(/script/i, '')
  html_template('161 [Filter: Replace script once]', "<p>Search result for: #{query}</p>")
end

# Case 162: Filter - Replace alert with empty (one-time, case-insensitive)
get '/162' do
  query = (params[:query] || '').sub(/alert/i, '')
  html_template('162 [Filter: Replace alert once]', "<p>Search result for: #{query}</p>")
end

# Case 163: Filter - Lowercase all input
get '/163' do
  query = (params[:query] || '').downcase
  html_template('163 [Filter: Lowercase input]', "<p>Search result for: #{query}</p>")
end

# Case 164: Filter - Uppercase all input
get '/164' do
  query = (params[:query] || '').upcase
  html_template('164 [Filter: Uppercase input]', "<p>Search result for: #{query}</p>")
end

# Case 165: Filter - Reverse input
get '/165' do
  query = (params[:query] || '').reverse
  html_template('165 [Filter: Reverse input]', "<p>Search result for: #{query}</p>")
end

# Case 166: Filter - Remove 'onerror' specifically
get '/166' do
  query = (params[:query] || '').gsub(/onerror/i, '')
  html_template('166 [Filter: Remove onerror]', "<img src=x #{query}>")
end

# Case 167: Filter - Remove 'onload' specifically
get '/167' do
  query = (params[:query] || '').gsub(/onload/i, '')
  html_template('167 [Filter: Remove onload]', "<body #{query}>Content</body>")
end

# Case 168: Filter - Remove 'onclick' specifically
get '/168' do
  query = (params[:query] || '').gsub(/onclick/i, '')
  html_template('168 [Filter: Remove onclick]', "<button #{query}>Click</button>")
end

# Case 169: Filter - Remove 'onmouseover' specifically
get '/169' do
  query = (params[:query] || '').gsub(/onmouseover/i, '')
  html_template('169 [Filter: Remove onmouseover]', "<div #{query}>Hover me</div>")
end

# Case 170: Filter - Remove 'onfocus' specifically
get '/170' do
  query = (params[:query] || '').gsub(/onfocus/i, '')
  html_template('170 [Filter: Remove onfocus]', "<input #{query}>")
end

# Case 171: Filter - WAF-style blacklist (common XSS keywords)
get '/171' do
  blacklist = %w[script alert confirm prompt eval document cookie window location]
  query = params[:query] || ''
  blacklist.each { |word| query = query.gsub(/#{word}/i, '') }
  html_template('171 [Filter: WAF blacklist]', "<p>Search result for: #{query}</p>")
end

# Case 172: Filter - WAF-style blacklist + tags
get '/172' do
  query = (params[:query] || '')
    .gsub(/<script[^>]*>/i, '')
    .gsub(/<\/script>/i, '')
    .gsub(/<img[^>]*>/i, '')
    .gsub(/<svg[^>]*>/i, '')
    .gsub(/on\w+\s*=/i, '')
    .gsub(/javascript:/i, '')
  html_template('172 [Filter: WAF tags + events]', "<p>Search result for: #{query}</p>")
end

# Case 173: Filter - Remove 'expression' (CSS expression attack)
get '/173' do
  query = (params[:query] || '').gsub(/expression/i, '')
  html_template('173 [Filter: Remove expression]', "<div style=\"width: #{query}\">Styled</div>")
end

# Case 174: Filter - Remove 'url(' (CSS url attack)
get '/174' do
  query = (params[:query] || '').gsub(/url\s*\(/i, '')
  html_template('174 [Filter: Remove url()]', "<div style=\"background: #{query}\">Styled</div>")
end

# Case 175: Filter - Remove 'behavior' (CSS behavior attack - IE)
get '/175' do
  query = (params[:query] || '').gsub(/behavior/i, '')
  html_template('175 [Filter: Remove behavior]', "<div style=\"#{query}\">Styled</div>")
end

# Case 176: Filter - Remove '-moz-binding' (CSS binding attack - Firefox)
get '/176' do
  query = (params[:query] || '').gsub(/-moz-binding/i, '')
  html_template('176 [Filter: Remove -moz-binding]', "<div style=\"#{query}\">Styled</div>")
end

# Case 177: Filter - Single quote in script context (escape with backslash)
get '/177' do
  query = (params[:query] || '').gsub("'", "\\'")
  html_template('177 [Filter: Escape quotes in JS]', "<script>var x = '#{query}';</script><p>Check console</p>")
end

# Case 178: Filter - Double quote in script context (escape with backslash)
get '/178' do
  query = (params[:query] || '').gsub('"', '\\"')
  html_template('178 [Filter: Escape double quotes in JS]', "<script>var x = \"#{query}\";</script><p>Check console</p>")
end

# Case 179: Filter - Remove 'Function' constructor keyword
get '/179' do
  query = (params[:query] || '').gsub(/Function/i, '')
  html_template('179 [Filter: Remove Function]', "<script>var x = '#{query}';</script><p>Check console</p>")
end

# Case 180: Filter - Remove 'constructor' keyword
get '/180' do
  query = (params[:query] || '').gsub(/constructor/i, '')
  html_template('180 [Filter: Remove constructor]', "<script>var x = '#{query}';</script><p>Check console</p>")
end

# Case 181: Filter - Remove 'prototype' keyword
get '/181' do
  query = (params[:query] || '').gsub(/prototype/i, '')
  html_template('181 [Filter: Remove prototype]', "<script>var x = '#{query}';</script><p>Check console</p>")
end

# Case 182: Filter - Remove '__proto__' keyword
get '/182' do
  query = (params[:query] || '').gsub(/__proto__/i, '')
  html_template('182 [Filter: Remove __proto__]', "<script>var x = '#{query}';</script><p>Check console</p>")
end

# Case 183: Filter - Remove 'fetch' keyword
get '/183' do
  query = (params[:query] || '').gsub(/fetch/i, '')
  html_template('183 [Filter: Remove fetch]', "<script>var x = '#{query}';</script><p>Check console</p>")
end

# Case 184: Filter - Remove 'XMLHttpRequest' keyword
get '/184' do
  query = (params[:query] || '').gsub(/XMLHttpRequest/i, '')
  html_template('184 [Filter: Remove XMLHttpRequest]', "<script>var x = '#{query}';</script><p>Check console</p>")
end

# Case 185: Filter - Remove 'String.fromCharCode'
get '/185' do
  query = (params[:query] || '').gsub(/String\.fromCharCode/i, '')
  html_template('185 [Filter: Remove fromCharCode]', "<script>var x = '#{query}';</script><p>Check console</p>")
end

# Case 186: Filter - Remove 'atob' (base64 decode)
get '/186' do
  query = (params[:query] || '').gsub(/atob/i, '')
  html_template('186 [Filter: Remove atob]', "<script>var x = '#{query}';</script><p>Check console</p>")
end

# Case 187: Filter - Remove 'btoa' (base64 encode)
get '/187' do
  query = (params[:query] || '').gsub(/btoa/i, '')
  html_template('187 [Filter: Remove btoa]', "<script>var x = '#{query}';</script><p>Check console</p>")
end

# Case 188: Filter - Remove 'setTimeout'
get '/188' do
  query = (params[:query] || '').gsub(/setTimeout/i, '')
  html_template('188 [Filter: Remove setTimeout]', "<script>var x = '#{query}';</script><p>Check console</p>")
end

# Case 189: Filter - Remove 'setInterval'
get '/189' do
  query = (params[:query] || '').gsub(/setInterval/i, '')
  html_template('189 [Filter: Remove setInterval]', "<script>var x = '#{query}';</script><p>Check console</p>")
end

# Case 190: Filter - Remove Unicode escape sequences
get '/190' do
  query = (params[:query] || '').gsub(/\\u[0-9a-fA-F]{4}/, '')
  html_template('190 [Filter: Remove Unicode escapes]', "<script>var x = '#{query}';</script><p>Check console</p>")
end

# Case 191: Filter - Remove HTML numeric entities (&#xxx;)
get '/191' do
  query = (params[:query] || '').gsub(/&#\d+;/, '')
  html_template('191 [Filter: Remove numeric entities]', "<p>Search result for: #{query}</p>")
end

# Case 192: Filter - Remove HTML hex entities (&#xXXX;)
get '/192' do
  query = (params[:query] || '').gsub(/&#x[0-9a-fA-F]+;/i, '')
  html_template('192 [Filter: Remove hex entities]', "<p>Search result for: #{query}</p>")
end

# Case 193: Filter - Remove all HTML entities
get '/193' do
  query = (params[:query] || '').gsub(/&[#\w]+;/, '')
  html_template('193 [Filter: Remove all HTML entities]', "<p>Search result for: #{query}</p>")
end

# Case 194: Filter - Strip tags using simple regex
get '/194' do
  query = (params[:query] || '').gsub(/<[^>]*>/, '')
  html_template('194 [Filter: Strip all tags]', "<p>Search result for: #{query}</p>")
end

# Case 195: Filter - Multiple filters combined (quotes + script + on*)
get '/195' do
  query = (params[:query] || '')
    .gsub(/['"]/, '')
    .gsub(/<script[^>]*>.*?<\/script>/im, '')
    .gsub(/on\w+\s*=/i, '')
  html_template('195 [Filter: Multi (quotes+script+on*)]', "<p>Search result for: #{query}</p>")
end

# Case 196: Filter - Multiple filters (angle brackets + javascript:)
get '/196' do
  query = (params[:query] || '')
    .gsub(/[<>]/, '')
    .gsub(/javascript:/i, '')
  html_template('196 [Filter: Multi (brackets+javascript)]', "<a href=\"#{query}\">Click here</a>")
end

# Case 197: Filter - Content Security Policy simulation (inline script blocked)
# Note: This simulates CSP by just filtering, not actual CSP header
get '/197' do
  query = (params[:query] || '').gsub(/<script[^>]*>.*?<\/script>/im, '[BLOCKED BY CSP]')
  html_template('197 [Filter: CSP simulation]', "<p>Search result for: #{query}</p>")
end

# Case 198: Filter - Replace dangerous chars with underscore
get '/198' do
  query = (params[:query] || '').gsub(/[<>"'&;()]/, '_')
  html_template('198 [Filter: Replace dangerous with _]', "<p>Search result for: #{query}</p>")
end

# Case 199: Filter - Recursive script removal
get '/199' do
  query = params[:query] || ''
  loop do
    new_query = query.gsub(/<script[^>]*>/i, '').gsub(/<\/script>/i, '')
    break if new_query == query
    query = new_query
  end
  html_template('199 [Filter: Recursive script removal]', "<p>Search result for: #{query}</p>")
end

# Case 200: Filter - Comprehensive WAF-style filter
get '/200' do
  query = params[:query] || ''
  # Remove dangerous tags
  query = query.gsub(/<script[^>]*>.*?<\/script>/im, '')
  query = query.gsub(/<[^>]*(on\w+|javascript:|vbscript:|data:)[^>]*>/i, '')
  # Remove event handlers
  query = query.gsub(/on\w+\s*=/i, '')
  # Remove dangerous protocols
  query = query.gsub(/javascript:|vbscript:|data:/i, '')
  # Remove dangerous keywords
  %w[alert confirm prompt eval document cookie window].each do |word|
    query = query.gsub(/#{word}/i, '')
  end
  html_template('200 [Filter: Comprehensive WAF]', "<p>Search result for: #{query}</p>")
end
