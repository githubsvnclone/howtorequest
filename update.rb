#!/usr/local/bin/ruby
for file in Dir['*.desc']
 settings = eval(File.read(file)) # hash
 
 Dir.chdir(settings[:dir]) do
   command = "git-svn rebase #{settings[:repo]}"
   if settings[:authors]
     command = "#{command} --authors-file #{settings[:authors]}"
   end
   puts command
   system(command)
   system("git push origin master")
 end

end

