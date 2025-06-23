#!/usr/bin/env ruby
# Plugin: Add last_modified_at to posts using Git history

Jekyll::Hooks.register :posts, :post_init do |post|
  post_path = post.path

  # Skip if file doesn't exist
  next unless File.exist?(post_path)

  begin
    # Check number of commits for the file
    commit_count = git rev-list --count HEAD "#{post_path}".strip.to_i

    if commit_count > 1
      # Get latest commit date in ISO format
      last_modified = git log -1 --pretty="%ad" --date=iso "#{post_path}".strip
      post.data['last_modified_at'] = last_modified
    end

  rescue => e
    warn "Git error while processing #{post_path}: #{e.message}"
  end
end
