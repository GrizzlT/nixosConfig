require('fidget').setup({
  window = {
    blend = 0,
  },
  text = {
    spinner = "bouncing_bar",         -- animation shown when tasks are ongoing
    done = "",               -- character shown when all tasks are complete
    commenced = "Allow me!",    -- message shown when task starts
    completed = "Outta here!",  -- message shown when task completes
  },
  timer = {
    spinner_rate = 60,       -- frame rate of spinner animation, in ms
    fidget_decay = 2000,      -- how long to keep around empty fidget, in ms
    task_decay = 1000,        -- how long to keep around completed task, in ms
  },
})

