def notify(msg)
  if RUBY_PLATFORM =~ /darwin/
    system "growlnotify watchr -m #{msg}"
  end
end

def run(cmd)
  puts cmd
  system cmd
  notify("FAILURE") if $? != 0
end

def feature(file)
  run "rake cucumber FEATURE=#{file}"
end

def spec(file)
  run "spec -O spec/spec.opts #{file}"
end

watch("spec/.*/*_spec\.rb") {|md| p md[0]; spec(md[0]) }
watch('app/(.*/.*)\.rb')    {|md| p md[1]; spec("spec/#{md[1]}_spec.rb") }
watch('[spec]{0}lib/(.*)\.rb')       {|md| p md[0]; spec("spec/lib/#{md[1]}_spec.rb") }
watch('[spec]{4}\/lib/(.*)\.rb') { |md| p md[0]; spec("spec/lib/#{md[1]}.rb") }
