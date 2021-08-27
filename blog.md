# Blog

This space is intended for me to talk about my daily progress.

## August 26, 2021

Moving on to create the iOS target.

At the time of writing his tutorial, the author explains how a `*.storyboard` file is needed for the first splash screen shown
when the app loads. Without this file, the app will report as only having a size of 480x320.

For iOS we can't pull in the whole SDL2 framework, so instead we have to generate static libraries specifically for iOS. And we
want 2 of these: 1 for the simulator, 1 for the actual device. The author gives us a solution in bash on how to do this. But SDL
has changed, and the project structure the author assumes isn't quite what it is today.

So I found the `README-ios.md` within SDL. In there I found instructions on what build scripts to run from the CLI if I want the
single fat file for both the simulator and the device. So I adapted my bash script, and now it looks nothing how the author
intended.

## August 25, 2021

Picking up trying to generate the XCode project. I am trying to identify where in the `project.yml` I have an error.

Figured out the problem. Turns out that the `fetch_os_specific_providers` bash helper was doing an early return that bypassed
the `popd` command, meaning that we were pushing a path but not popping it from the stack. Then the `xcodegen` executable was
trying to find a `project.yml` in there.

After fixing the above problem and debugging my SDL2 Framework path in the `project.yml`, I finally got the whole flow to work. I got
the console app built and run from XCode!

## August 24, 2021

I changed the project structure so that build targets and artifacts happen outside of the source folder.

I also added a thin Makefile at the root of the repo. This Makefile has very simple commands that I can run from my editor to clean, build
and run the console application.

I was also looking into how to get breakpoints to work. I found [this](https://www.reddit.com/r/neovim/comments/9myvqx/neovim_debugger/)
subreddit about the topic. That let me to [nvim-gdb](https://github.com/sakhnik/nvim-gdb), but I haven't been successful about making it
work.

Started reading about how to generate our XCode project, and found out about [xcodegen](https://github.com/yonaskolb/XcodeGen). We use it
so that we can continuously generate the project file instead of using xcode to drive the creation of project. By inverting this generation,
the project configuration will have no differences across multiple developers.

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
