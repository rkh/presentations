gh = GH::DefaultStack.new
gh['users/rkh']

GH['users/rkh'] # => { "login" => "rkh", .... }

GH.with username: "rkh", password: "abc123" do
  puts GH['user']['name']
end

event = GH.load(hook_payload)
merge_commit = event['pull_request']['merge_commit']
merge_commit['sha']
merge_commit['committer']

GH.with token: "..." do
  GH
end

{
  "action" => "...",
  "pull_request" => {
    "mergeable" => true,
    "head" => { ... },
    "base" => { ... }
  },
  "number" => 123
}

We care about:
* open: pull request (re)opened
* synchronize: head or base update