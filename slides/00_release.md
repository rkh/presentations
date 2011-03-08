!SLIDE center
![sinatra](sinatra.png)

!SLIDE bullets

# Patches #

* Embrace Git and Pull Requests

!SLIDE

    curl https://.../pull/195.patch |
      git am -s

    curl https://.../commit/66a7db.patch |
      git am -s

    git pull --squash zacharyscott master
    git ci --interactive --author Zachary

!SLIDE bullets

# Backports #

!SLIDE

    git cherry-pick master

    git rebase -i

!SLIDE bullets

# Releases #

!SLIDE

    rake test
    rake sinatra.gemspec
    gem build sinatra.gemspec
    gem install sinatra-1.2.0.gem --local
    gem push sinatra-1.2.0.gem
    git commit --allow-empty -a -m '1.2.0 release'
    git tag -s 1.2.0 -m '1.2.0 release'
    git push
    git push --tags

!SLIDE

    rake release

!SLIDE bullets incremental

# Communication #

* community
* other core devs
* other lib devs
* news people

!SLIDE bullets

# Alright, let's go 1.2 #
    