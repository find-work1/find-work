- I was reading about Teletext for the first time and I kind of liked the aesthetic of the Teletext interface.

- I found the [telestrap](http://code.steadman.io/telestrap/) bootstrap theme which I think is super cool.

- I needed an excuse to make something with this and so started reading about Teletext on wikipedia for inspiration.

- My reading led me to telegraphs, "ticker tape parades",
  and how historical "stock tickers" have transformed into high-speed trading. 

- I decided to make a site which shows the live-updating output of commands being run on an interval.

- It'd been a while since I used Bootstrap so I started by making a little "cheat sheet" for basic usage of
  the Telestrap theme

- I was considering using Node for the front-end and Rails for the API. I looked into
  [faye-browser](http://faye.jcoglan.com/browser.html) and saw that it required a Faye server to be running as well.
  I decided to skip Faye and use Rails for the front-end tool because I'd already made
  [a gem](http://github.com/maxpleaner/socket_helpers) for using
  [websocket-rails](https://github.com/websocket-rails/websocket-rails) servers.

- Next I generated a Rails app and moved the Telestrap assets in.

- Next I worked on views for the "Ticker" scaffold. I started with just "create" and "index" actions.
  For the "create" form, I used [ace.js](https://ace.c9.io/#nav=about) with Ruby syntax highlighting.

- Next I worked on asynchronously executing the "Ticker" scripts. My first plan was to use Resuqe.
  I'd done this at a previous job and I thought it'd be a performant solution. I ended up encountering a lot
  of issues and eventually decided to try a different approach. Specically, the
  [redis_multi_queue](http://www.rubydoc.info/github/resque/resque/Resque/Failure/RedisMultiQueue) error handler
  did not work out of the box and I had to fork [resque-web](https://github.com/MaxPleaner/resque-web/) to get it to
  start. I managed to start a looped background job on an interval, but it still didn't show up in resque-web and I
  couldn't figure out how to dynamically add scheduled jobs using
  [resque-scheduler](https://github.com/resque/resque-scheduler). I considered using Cron but I needed a minimum
  interval time of less than a minute. Looking at it now [rufus-scheduler](https://github.com/jmettraux/rufus-scheduler) might have worked - it seems better documented.

  - Anyway, I ended up making my own implementation using shell commands. See `app/models/ticker.rb` for the code.

  - Basically a Ticker object has a "content" column which contains a ruby script in a string. An "interval" column represents how often the script should be run (in milliseconds). It also has a "process_name" column which is programmatically set when the background job begins.

  - There are two instance methods on Ticker which control the background jobs:

    -**`begin`**
      - creates a filename containing a constant identifier ("tickers_process_") and a random string
      - Writes the script content to a tempfile with this filename.
      - When writing the file, adds some wrapper code around
        the script content.
      - `loop do` and `sleep` are added in order to loop it every N milliseconds (which is determined by the interval column)
      - `$0 = "#{tempfile_name}" is used to set the process name for the script. Setting this makes it easier to find the script's pid using `ps aux`.
      - Next the script is run by using system exec (backticks) to spin up a rails console and issuing it a `load` command to have it run the tempfile.
      - It turns out that the most difficult part of spawning subprocesses is doing in a way that enables stopping them. I experiemented with a number of commands, including `fork`, `spawn`, and `thread`. The returned value of these methods is a PID, but I found that the actual PID of the process dynamically changed and so this can't dependaby be used to stop the background job. Somewhat confusingly, a method calling these commands (i.e. `spawn`) will continue on to the next statement without waiting for the subprocess to compete, but if the method is run from a REPL, the prompt won't be returned to the user. I fixed this by plugging in the returned PID to `Process.detach(pid)`. I ended up going with `spawn` because it offers a `pgroup: true` option. This option tells it to start a new "process group" for the spawned command. I'm not sure how much it really does but it supposedly prevents orphaning child processes. 
      - Finally, the Ticker record's `process_name` column is updated to the tempfile name.
      - There would some bugs I didn't solve. When a background job ran `curl`, the server would show all the curl requests in it's logs. I tried `> /dev/null` but still wasn't able to hide these. A second bug is orphan processes. I can't say for sure what causes this issue, but I suspect that certain errors being raised in the background job might cause it. 

  - **`stop`**
    - Thankfully much simpler than `begin`
    - Basically, a running background job's PID is looked up by a ticker's `process_name`. 
    - The following command is used for this: `ps aux | grep #{process_name.first(25)} | awk 'NR==1{print $2}`
    - Then `kill -9 #{pid}` is used to do the actual killing.

  - There is also one class method on `Ticker`:
    - **`killall`**
      - This command is to kill all background jobs (including orphans).
      - It's one line is `pkill -f #{@@process_name_constant}` This kills all processes with a name partially matching the argument. 
      - TODO: run this on Rails server exit to ensure that the jobs don't keep running. 

- After writing this background job system, I now needed a way for the background scripts to send updates to my websocket listeners. I tried using `WebsocketRails["channelName"].trigger` but found that it only worked when run from my Rails controller. So I made a Rails endpoint which calls this method, and called that endpoint from the background job using `curl`.

- At this point I was pretty satisfied. I added an "edit" form. The heroku deploy was working fine with the Telestrap theme but I hadn't debugged the background job system yet.

- Thanks for reading! Contribute if you want! 