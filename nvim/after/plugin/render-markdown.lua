local render_md = require('render-markdown')
render_md.setup({
    -- TODO: remove backgrounds on stuff
    heading = {
        -- backgrounds = {}
    }
})
render_md.disable()

function rm_enable()
    render_md.enable()
end

function rm_disable()
    render_md.disable()
end

