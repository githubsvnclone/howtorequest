#!/usr/local/bin/ruby
require 'fileutils'

Dir.chdir(File.dirname(__FILE__)) do

  for file in Dir['*.desc']
    settings = eval(File.read(file)) # hash

    Dir.chdir(settings[:dir]) do
      command = "git-svn rebase #{settings[:repo]}"
      if settings[:authors]
        command = "#{command} --authors-file #{settings[:authors]}"
      end
      puts settings[:dir], command
      system(command)
      system("git push origin master")

      # update tags by hand [sigh]
      all = `git branch -a | grep tags`
      all.each_line{|line| line =~ /\/(.....$)/; system("git push origin tags/#{$1}") }
    end

  end
  FileUtils.touch '/home/githubsvnclone/hereiam2'
end
