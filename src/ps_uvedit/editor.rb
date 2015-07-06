module PS::Plugins::UVEdit

extension_path = File.dirname( __FILE__ )
skui_path = File.join( extension_path, 'SKUI' )
load File.join( skui_path, 'embed_skui.rb' )
::SKUI.embed_in( self )

# Writes out the first texture found in the material collection given.
#
# @param [Sketchup::Entities] entities
def self.export_texture(entities)
  model = entities.model
  faces = entities.grep(Sketchup::Face)
  raise "no faces" if faces.empty?
  face = faces.find { |entity| entity.material && entity.material.texture }
  raise "no textured material" if face.nil?
  material = face.material
  # Write the texture out to a temp file.
  filename = "su_skylines_#{face.entityID}_#{Time.now.to_i}.png"
  temp_file = File.join(Sketchup.temp_dir, filename)
  tw = Sketchup.create_texture_writer
  # Texture writer will write out unique textures for non-affine mapped faces.
  # Dont' want that, so create this temp group for the sake of exporting.
  # Note that this create a new operation. The call to this should either be
  # part of an operation, or wrapped in
  # model.start_operation ... model.abort_operation.
  temp_group = entities.add_group
  temp_group.material = material
  tw.load(temp_group)
  tw.write(temp_group, temp_file)
  temp_group.erase!
  # Return the path to the temp file. The method handling it is responsible for
  # cleaning up the temp file.
  temp_file
end
    
    
    
def self.show

  model = Sketchup.active_model
  entities = model.active_entities

  options = {
    :title           => 'UV Edit',
    :preferences_key => 'PS_Plugins_UVEdit',
    :width           => 500,
    :height          => 500,
    :resizable       => true
  }
  window = PS::Plugins::UVEdit::SKUI::Window.new( options )

  # These events doesn't trigger correctly when Firebug Lite
  # is active because it introduces frames that interfere with
  # the focus notifications.
  window.on( :focus )  { puts 'Window Focus' }
  window.on( :blur )   { puts 'Window Blur' }
  window.on( :resize ) { |win, width, height|
    newSize = ["#{width}", "#{height}"]
    window.bridge.call('uvViewResize', newSize)
  }


  btn1 = PS::Plugins::UVEdit::SKUI::Button.new( 'Draw UV Map' ) { |control|
    model = Sketchup.active_model
    entities = model.active_entities
    uvmesh = Hash.new
    uvmesh["faces"] = Array.new
    my_texture = export_texture(entities)
    window.bridge.call('clear')
    
    window.bridge.call('createPattern', my_texture)
    
    entities.each{|x|
      first = nil
      if x.is_a? Sketchup::Face
        face = Hash.new
        face["points"] = Array.new
        face["uvs"] = Array.new
        face["id"] = x.entityID
        
        my_texture_writer = Sketchup.create_texture_writer
        my_uvhelper = x.get_UVHelper true, true, my_texture_writer
        verts = x.outer_loop.vertices
        first = verts.first
            
        verts.each do |vert|
           uvs = my_uvhelper.get_front_UVQ(vert.position)
           face["points"].push(vert.position)
           face["uvs"].push(uvs)
        end
        window.bridge.call('createFaceWithColor', face , "#000000")
            
      end
    }
  }

  btn2 = PS::Plugins::UVEdit::SKUI::Button.new( 'Highlight Selection' ) { |control|
    model = Sketchup.active_model
    entities = model.active_entities
    selection = model.selection
    uvmesh = Hash.new
    uvmesh["faces"] = Array.new
    my_texture = export_texture(entities)
    window.bridge.call('clear')
    
    window.bridge.call('createPattern', my_texture)
    
    selectionIds = Array.new
    selection.each{|x|
      if x.is_a? Sketchup::Face
        selectionIds.push(x.entityID)
      end
    }

    entities.each{|x|
      first = nil
      if x.is_a? Sketchup::Face
          face = Hash.new
          face["points"] = Array.new
          face["uvs"] = Array.new
          face["id"] = x.entityID
          
          my_texture_writer = Sketchup.create_texture_writer
          my_uvhelper = x.get_UVHelper true, true, my_texture_writer
          verts = x.outer_loop.vertices
          first = verts.first
        
          verts.each do |vert|
            uvs = my_uvhelper.get_front_UVQ(vert.position)
            face["points"].push(vert.position)
            face["uvs"].push(uvs)
          end
        if selectionIds.include? x.entityID
          window.bridge.call('createFaceWithColor', face , "#0000FF")
        else
          window.bridge.call('createFaceWithColor', face , "#000000")
        end
      end
    }
  }

btn3 = PS::Plugins::UVEdit::SKUI::Button.new( 'Highlight Offsets' ) { |control|
    model = Sketchup.active_model
    entities = model.active_entities
    uvmesh = Hash.new
    uvmesh["faces"] = Array.new
    my_texture = export_texture(entities)
    window.bridge.call('clear')
    
    window.bridge.call('createPattern', my_texture)
    

    
    entities.each{|x|
        first = nil
        if x.is_a? Sketchup::Face
            face = Hash.new
            face["points"] = Array.new
            face["uvs"] = Array.new
            face["id"] = x.entityID
            
            my_texture_writer = Sketchup.create_texture_writer
            my_uvhelper = x.get_UVHelper true, true, my_texture_writer
            verts = x.outer_loop.vertices
            first = verts.first
            
            isInBounds = true
            
            verts.each do |vert|
                uvq = my_uvhelper.get_front_UVQ(vert.position)
                face["points"].push(vert.position)
                face["uvs"].push(uvq)
                
                
                    u = uvq.x/uvq.z
                    v = uvq.y/uvq.z
                    if u > 1 || u < 0 || v > 1 || v < 0
                        isInBounds = false
                    end
            end
            if isInBounds
                window.bridge.call('createFaceWithColor', face , "#000000")
                else
                window.bridge.call('createFaceWithColor', face , "#0000FF")
            end
        end
    }
}




btn1.position(0,0)
btn1.width = 125
btn1.height = 20
btn1.foreground_color = Sketchup::Color.new( 220, 205, 195 )
btn1.background_color = Sketchup::Color.new( 30, 40, 45 ,192)
btn1.font = SKUI::Font.new( false, 10 )
window.add_control( btn1 )

btn2.position( 125, 0 )
btn2.width = 125
btn2.height = 20
btn2.foreground_color = Sketchup::Color.new( 220, 205, 195 )
btn2.background_color = Sketchup::Color.new( 30, 40, 45 ,192)
btn2.font = SKUI::Font.new( false, 10 )
window.add_control( btn2 )

btn3.position( 250, 0 )
btn3.width = 125
btn3.height = 20
btn3.foreground_color = Sketchup::Color.new( 220, 205, 195 )
btn3.background_color = Sketchup::Color.new( 30, 40, 45 ,192)
btn3.font = SKUI::Font.new( false, 10 )
window.add_control( btn3 )

btn_close = PS::Plugins::UVEdit::SKUI::Button.new( 'Close' ) { |control|
    control.window.close
}

btn_close.position( 375, 0 )
btn_close.width = 125
btn_close.height = 20
btn_close.foreground_color = Sketchup::Color.new( 220, 205, 195 )
btn_close.background_color = Sketchup::Color.new( 30, 40, 45 ,192)
btn_close.font = SKUI::Font.new( false, 10 )
window.add_control( btn_close )

chk_hide = PS::Plugins::UVEdit::SKUI::Checkbox.new( 'Hide Buttons' )
chk_hide.left = 5
chk_hide.bottom = 5
chk_hide.on( :change ) { |control|
  puts "Checkbox: #{control.checked?}"
  btn1.visible = !control.checked?
  btn2.visible = !control.checked?
  btn3.visible = !control.checked?
  btn_close.visible = !control.checked?
}
window.add_control( chk_hide )

window.default_button = btn1
window.cancel_button = btn_close
window.show
window
end # def
end # module
window = PS::Plugins::UVEdit.show
