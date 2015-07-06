require "sketchup.rb"
module PS::Plugins::UVEdit
    extension_path = File.dirname( __FILE__ )

    cmd1 = UI::Command.new("UVEdit"){(
      load File.join( extension_path, 'editor.rb' )
    )}
    cmd1.tooltip = cmd1.status_bar_text = "UVEdit"
    
    ipath = File.join( extension_path, 'images' )
    cmd1.small_icon = File.join(ipath, "uv16.png")
    cmd1.large_icon = File.join(ipath, "uv24.png")
    
    tb = UI::Toolbar.new("UVEdit")
    tb.add_item(cmd1)
    tb.show
end