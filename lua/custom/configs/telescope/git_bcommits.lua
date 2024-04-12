local is_present, _ = pcall(require, "telescope")
if not is_present then
  return
end

local M = {}

local git_bcommits_bak = require("telescope.builtin").git_bcommits
M.m_git_bcommits = function(opts)
  opts.git_command = { "git", "log", "--pretty=%C(auto)%h {%as %cn} %s", "--abbrev-commit", "--follow" }
  git_bcommits_bak(opts)
end

local git_commits_bak = require("telescope.builtin").git_commits
M.m_git_commits = function(opts)
  opts.git_command = { "git", "log", "--pretty=%C(auto)%h {%as %cn} %s", "--abbrev-commit", "--", "." }
  git_commits_bak(opts)
end

-- overrides
require("telescope.builtin").git_bcommits = M.m_git_bcommits
require("telescope.builtin").git_commits = M.m_git_commits
