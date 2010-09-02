def w(name, str = nil, &block)
  block ||= proc { |m| sys(str % m[0])}
  watch('^' << name.gsub('.', '\.').gsub('*', '.*')) do |m|
    puts "-"*80, "#{Time.now.strftime("%H:%M:%S")} - file changed: \033[1;34m#{m[0]}\033[0m"
    block[m]
  end
end

def sys(cmd)
   puts "\033[0;33m>>> \033[1;33m#{cmd}\033[0m"
   if system cmd
     puts "\033[1;32mSUCCESS\033[0m"
   else
     puts "\033[1;31mFAIL\033[0m"
   end
end

w '*.coffee',       'coffee -c %s'
w '*.(sass|scss)',  'compass compile --sass-dir . --css-dir . --images-dir . --javascripts-dir .'
