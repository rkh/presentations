!SLIDE bullets

# Pull Requests #

* A Colaborators Dream Come True

!SLIDE center

![Pull Request](hey-girl-pull-request.jpg)

!SLIDE center

![Pull Request](pull-request.png)

!SLIDE center

![Merge](merge.png)

!SLIDE center

![Patch](patch.png)

!SLIDE center

![pre merge button](pre-merge-button.png)

!SLIDE center

![Merge Button](merge_button.png)

!SLIDE center

![pre travis](pre-travis.png)

!SLIDE center

![Pull Request](one-does-not-pull-request.jpg)

!SLIDE bullets

# Announcement #

!SLIDE bullets

# We are going to fix this! #

!SLIDE bullets

# We have fixed it! #

!SLIDE bullets

# We start the rollout today #

* will enable it on per project basis
* big and huge donors get priority

!SLIDE center

![with travis](with-travis.png)

!SLIDE center

![travisbot](travisbot.png)

!SLIDE center

![pull request api](pull-request-api.png)

!SLIDE center

![pull request api](pull-refs.png)

!SLIDE center

![pull request api](pull-refs-head.png)

!SLIDE center

![pull request api](pull-refs-head-url.png)

!SLIDE center

![pull request api](pull-refs-merge.png)

!SLIDE center

![pull request api](pull-refs-merge-url.png)

!SLIDE center

![pull request api](pull-refs-merge-committer.png)

!SLIDE center

![merge commit](merge-commit.png)

!SLIDE code

    git fetch origin +refs/pull/492/merge:
    git checkout FETCH_HEAD

!SLIDE center

![app architecture](apps.png)

!SLIDE center

![app architecture](apps-path.png)

!SLIDE center

![dependencies](dependencies.png)

!SLIDE center

# Yet Another Github Library!?

!SLIDE center

![gh](gh.png)

!SLIDE center

![gh](gh-important.png)

!SLIDE code

    @@@ ruby
    gh = GH::DefaultStack.new
    gh['users/rkh']['name']

!SLIDE code

    @@@ ruby
    GH['users/rkh']['name']

!SLIDE code

    @@@ ruby
    GH.with username: 'rkh', password: 'x' do
      GH['user']['name']
    end

!SLIDE code

    @@@ ruby
    hook = GH.load(payload)
    hook['pull_request']['merge_commit']

!SLIDE

# Hypermedia

!SLIDE

    @@@ javascript
    {
      "_links": {
        "self": {"href": "..."},
        "html": {"href": "..."},
        "something": {"href": "..."}
      }
    }

!SLIDE bullets

# GH::LinkFollower

* If field does not exist, but link with same name exists, load data from link
* Do it lazily

!SLIDE bullets

# GH::LazyLoader

* If field does not exist, fetch data from self link
* Do it lazily



!SLIDE center

# One More Thing

!SLIDE

    @@@ javascript

    {
      "action": "synchronize",
      "pull_request": {
        "base": { ... },
        "head": { ... }
      }
    }

!SLIDE bullets incremental

* triggered if head updated
* triggered if base updated

!SLIDE center

![end of world](endofworld.jpg)

!SLIDE bullets

* don't rebuild on base updates

!SLIDE center

![do it live](doitlive.jpeg)

!SLIDE center