def run(cmd)
  puts cmd
  system cmd
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
