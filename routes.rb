WEB_ROOT = './public'

MAPPING = {
  'index' => 'index.html',
  'about' => 'about.html',
  'contact' => 'contact.html',
  'contact_me' => 'contact_me.html',
  'main.css' => 'main.css'
}

class Routes
  def self.requested_file(request_line)
    map_line = MAPPING[request_line]
    [WEB_ROOT, map_line].join('/')
  end
end

