#!/usr/local/bin/ruby
require 'fileutils'


def finish_up command
      puts command
      system command
      system("git push origin master")
      # update tags by hand [sigh]
      all = `git branch -a | grep tags`
      all.each_line{|line| line =~ /\/(.....$)/; system("git push origin tags/#{$1}") }
end

Dir.chdir(File.dirname(__FILE__)) do

  for file in Dir['*.desc']
    settings = eval(File.read(file)) # hash

    Dir.chdir(settings[:dir]) do
      command = "git-svn rebase #{settings[:repo]}"
      if settings[:authors]
        command = "#{command} --authors-file #{settings[:authors]}"
      end
      puts settings[:dir]
      finish_up command
    end

  end

  for normal in File.read('normals').split("\n")
    Dir.chdir(normal) do
      command = "git-svn rebase http://#{normal}.rubyforge.org/svn --authors-file ../authors"
      puts command
      finish_up command
    end
  end
    
  FileUtils.touch '/home/githubsvnclone/hereiam2'
end
