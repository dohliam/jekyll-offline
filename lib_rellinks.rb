# Takes an HTML file or folder of HTML files as input
# and adjusts all absolute links so that they are relative
# e.g., "/images" becomes "../images".
# Requires a (local) base directory to be specified as an
# argument: all links will then be rewritten relative to
# this base directory

def relativize(href, path, absolute_base, root_dir)
  # href = actual href string on page
  # path = actual current location / file path of current page
  # absolute_base = the base url for the site

  href_url = URI.join(URI.encode(absolute_base), URI.encode(href))
  path_url = URI.join(absolute_base, URI.encode(path))
  relative_url = path_url.route_to(href_url).to_s
  url_out = test_index(relative_url, href_url, absolute_base, root_dir)
  if href.match(/^#/)
    url_out = href
  end
  url_out
end

def path_is_dir(href_url, absolute_base, root_dir)
  decode_href = URI.decode(href_url.to_s.gsub(/%25/, "%"))
  local_target = decode_href.gsub(absolute_base, root_dir + "/")
  File.directory?(local_target)
end

def test_index(relative_url, href_url, absolute_base, root_dir)
  if path_is_dir(href_url, absolute_base, root_dir)
    relative_url = rewrite_index(relative_url)
  else
    fixed_url = relative_url.to_s.gsub(/^\//,"")
    test_url = URI.join(URI.encode(absolute_base), URI.encode(fixed_url))
    if path_is_dir(test_url, absolute_base, root_dir)
      relative_url = rewrite_index(relative_url)
    end
  end
  relative_url
end

def rewrite_index(relative_url)
  relative_url = relative_url.to_s.gsub(/\/+$/, "") + "/index.html"
end

def convert_html(html, source_file, root_dir, absolute_base)
  root_path = File.absolute_path(root_dir)
  source_file_path = File.absolute_path(source_file)
  path = source_file_path.gsub(/^#{root_path}/, "")

  out_html = html.gsub(/(href|src)=["'](.*?)["']/) do |h|
    pre = $1
    href = $2
    if @config[:custom_filter] && href.match(/#{@config[:custom_filter]}/)
      h
    elsif h.match(absolute_base) || !h.match(/https*:\/\//)
      href = href.gsub(/^\/\//, "/")
      raw_out = pre + '="' + relativize(href, path, absolute_base, root_path) + '"'
      URI.decode(raw_out)
    else
      h
    end
  end
  
  out_html
end
