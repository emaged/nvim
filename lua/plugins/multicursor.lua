return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    event = "VeryLazy",
    cond = true,
    config = function()
      local mc = require "multicursor-nvim"
      mc.setup()
      local set = vim.keymap.set

      -- Add or skip cursor above/below the main cursor.
      set({ "n", "x" }, "<up>", function() mc.lineAddCursor(-1) end)
      set({ "n", "x" }, "<down>", function() mc.lineAddCursor(1) end)
      set({ "n", "x" }, "<Leader><up>", function() mc.lineSkipCursor(-1) end, { desc = "Skip cursor above" })
      set({ "n", "x" }, "<Leader><down>", function() mc.lineSkipCursor(1) end, { desc = "Skip cursor below" })

      -- Add or skip adding a new cursor by matching word/selection
      set({ "n", "x" }, "<Leader>mm", function() mc.matchAddCursor(1) end, { desc = "Add cursor on match forward" })
      set({ "n", "x" }, "<Leader>ms", function() mc.matchSkipCursor(1) end, { desc = "Skip cursor on match forward" })
      set({ "n", "x" }, "<Leader>mM", function() mc.matchAddCursor(-1) end, { desc = "Add cursor on match backward" })
      set({ "n", "x" }, "<Leader>mS", function() mc.matchSkipCursor(-1) end, { desc = "Skip cursor on match backward" }) -- Advanced Actions

      -- Add a cursor for all matches of cursor word/selection in the document.
      set({ "n", "x" }, "<Leader>ma", mc.matchAllAddCursors, { desc = "Add cursors to all matches" })

      -- Append/insert for each line of visual selections.
      -- Similar to block selection insertion.
      set("x", "I", mc.insertVisual, { desc = "Insert for each line of visual selection" })
      set("x", "A", mc.appendVisual, { desc = "Append for each line of visual selection" })

      -- Add a cursor and jump to the next/previous search result.
      set("n", "<Leader>m/", function() mc.searchAddCursor(1) end, { desc = "add cursor to search match forward" })
      set("n", "<Leader>m?", function() mc.searchAddCursor(-1) end, { desc = "add cursor to search match backward" })

      -- Jump to the next/previous search result without adding a cursor.
      set("n", "<Leader>m;", function() mc.searchSkipCursor(1) end, { desc = "Skip search match forward" })
      set("n", "<Leader>m,", function() mc.searchSkipCursor(-1) end, { desc = "Skip search match backward" })

      -- Add a cursor to every search result in the buffer.
      set("n", "<Leader>m*", mc.searchAllAddCursors, { desc = "Add cursors to all search matches" })

      -- Add and remove cursors with control + left click.
      set("n", "<c-leftmouse>", mc.handleMouse)
      set("n", "<c-leftdrag>", mc.handleMouseDrag)
      set("n", "<c-leftrelease>", mc.handleMouseRelease)

      -- Disable and enable cursors.
      set({ "n", "x" }, "<Leader>mt", mc.toggleCursor, { desc = "enable/disable cursor" })

      -- Pressing `gaip` will add a cursor on each line of a paragraph.
      -- Can also be used to add cursor for each line of visual selection.
      set({ "n", "x" }, "<Leader>mv", mc.addCursorOperator, { desc = "add cursor to visual selection, or gaip" })

      -- restore cursors if you accidentally clear them
      set("n", "<Leader>mr", mc.restoreCursors, { desc = "restore cursors" })

      -- Pressing `<Leader>moiwap` will create a cursor in every match of the
      -- string captured by `iw` inside range `ap`.
      -- This action is highly customizable, see `:h multicursor-operator`.
      set({ "n", "x" }, "<Leader>mo", mc.operator, { desc = "create a cursor in every match of the string" })

      -- Align
      set("n", "<Leader>m=", mc.alignCursors, { desc = "Align cursor columns" })

      -- Sequences
      set({ "n", "x" }, "g<C-a>", mc.sequenceIncrement)
      set({ "n", "x" }, "g<C-x>", mc.sequenceDecrement)

      -- Rotate the text contained in each visual selection between cursors.
      set("x", "<leader>mc", function() mc.transposeCursors(1) end, { desc = "Cycle forwards" })
      set("x", "<leader>mC", function() mc.transposeCursors(-1) end, { desc = "Cycle backwards" })

      set("x", "<Leader>mh", function() mc.swapCursors(-1) end, { desc = "Swap with previous cursor" })
      set("x", "<Leader>ml", function() mc.swapCursors(1) end, { desc = "Swap with next cursor" })

      set("x", "<Leader>m|", mc.splitCursors, { desc = "Split visual into cursors (regex)" })

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Select a different cursor as the main one.
        layerSet({ "n", "x" }, "<left>", mc.prevCursor)
        layerSet({ "n", "x" }, "<right>", mc.nextCursor)

        -- Delete the main cursor.
        layerSet({ "n", "x" }, "<Leader>mx", mc.deleteCursor, { desc = "delete main cursor" })

        -- Enable and clear cursors using escape.
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", {
        reverse = true,
      })
      hl(0, "MultiCursorVisual", {
        link = "Visual",
      })
      hl(0, "MultiCursorSign", {
        link = "SignColumn",
      })
      hl(0, "MultiCursorMatchPreview", {
        link = "Search",
      })
      hl(0, "MultiCursorDisabledCursor", {
        reverse = true,
      })
      hl(0, "MultiCursorDisabledVisual", {
        link = "Visual",
      })
      hl(0, "MultiCursorDisabledSign", {
        link = "SignColumn",
      })
    end,
  },
}
