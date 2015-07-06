#-------------------------------------------------------------------------------
#
# Philipp Stober
# brotuser[at]web[dot]de
#
#-------------------------------------------------------------------------------
require "sketchup.rb"
require "extensions.rb"

module PS
  module Plugins
    module UVEdit
      ### CONSTANTS ### ------------------------------------------------------------
        
      # Resource paths
      file = __FILE__.dup
      file.force_encoding("UTF-8") if file.respond_to?(:force_encoding)
      SUPPORT_FOLDER_NAME = File.basename(file, ".*").freeze
      PATH_ROOT           = File.dirname(file).freeze
      PATH                = File.join(PATH_ROOT, SUPPORT_FOLDER_NAME).freeze
        
      # Plugin information
      PLUGIN          = self
      PLUGIN_ID       = "PS_UVEdit".freeze
      PLUGIN_NAME     = "UV Viewer / Editor".freeze
      PLUGIN_VERSION  = "0.0.1".freeze
      PLUGIN_URL      = "http://www.google.de".freeze
      
      ### EXTENSION ### ------------------------------------------------------------
      unless file_loaded?(__FILE__)
        loader = File.join(PATH, "core.rb")
        ex = SketchupExtension.new(PLUGIN_NAME, loader)
        ex.description = "Simple UV Viewer / Editor"
        ex.version     = PLUGIN_VERSION
        ex.copyright   = "Philipp Stober © 2015"
        ex.creator     = "Philipp Stober (brotuser@web.de)"
        @extension = ex
        Sketchup.register_extension(@extension, true)
      end

    end
  end
end

#-------------------------------------------------------------------------------

file_loaded(__FILE__)

#-------------------------------------------------------------------------------