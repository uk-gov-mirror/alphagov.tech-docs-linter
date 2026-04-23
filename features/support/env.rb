require "fileutils"

BUILD_DIR = File.expand_path("build", Dir.pwd)
LOCKFILE  = File.expand_path("tmp/cucumber-build.lock", Dir.pwd)
FileUtils.mkdir_p(File.dirname(LOCKFILE))

File.open(LOCKFILE, "w") do |f|
  f.flock(File::LOCK_EX)

  unless File.exist?(File.join(BUILD_DIR, "index.html"))
    FileUtils.rm_rf(BUILD_DIR)
    ok = system("bundle exec middleman build")
    raise "Middleman build failed" unless ok
  end
end


at_exit do
  # Optional cleanup; leave artefacts around if they help debugging
  FileUtils.rm_rf(BUILD_DIR)
  puts ">>>>>>> Testing finished"
end

