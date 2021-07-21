# Blog

This space is intended for me to talk about my daily progress.

## July 20, 2021

Started looking into configuring `neovim` + `coc` so I could get autocompletion in C++ projects.

I first started to follow [this](https://ianding.io/2019/07/29/configure-coc-nvim-for-c-c++-development/) guide. The author mentions that
using a `compiled_commands.json` file is hard, so I opted to do a manually generated `.ccls` file. I got that to work, only I missed to add
the SDL framework, or didn't add the correct path.

Then I found [this](https://www.reddit.com/r/neovim/comments/dc4wvw/how_to_configure_ccls_file_for_c_development_in/) subreddit where one of
the replies mentions that `cmake` can auto-generate the `compiled_commands.json`. Since I like automation, I decided to give it a try. I
finally got that to work, and I also got the SDL autocompletions. It felt so good!

The only downside is to this approach is that the generated `compiled_commands.json` data only accounts for the build from the console
target. I think this is fine, since development only happens in one machine at a time. I'll figure something out when I start to
consider other targets. I honestly don't think it will be too much of a problem.
