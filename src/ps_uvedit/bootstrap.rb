#-------------------------------------------------------------------------------
#
# Thomas Thomassen
# thomas[at]thomthom[dot]net
#
#-------------------------------------------------------------------------------

module PS::Plugins::UVEdit

  ### CONSTANTS ### ------------------------------------------------------------

  unless defined?(DEBUG)
    # Sketchup.write_default("PS_UVEdit", "DebugMode", true)
    DEBUG = Sketchup.read_default(PLUGIN_ID, "DebugMode", false)
  end

  # Minimum version of SketchUp required to run the extension.
  MINIMUM_SKETCHUP_VERSION = 14


  ### COMPATIBILITY CHECK ### --------------------------------------------------


  if Sketchup.version.to_i < MINIMUM_SKETCHUP_VERSION

    version_name = "20#{MINIMUM_SKETCHUP_VERSION}"
    message = "#{PLUGIN_NAME} require SketchUp #{version_name} or newer."
    messagebox_open = false # Needed to avoid opening multiple message boxes.
    # Defer with a timer in order to let SketchUp fully load before displaying
    # modal dialog boxes.
    UI.start_timer(0, false) {
      unless messagebox_open
        messagebox_open = true
        UI.messagebox(message)
        # Must defer the disabling of the extension as well otherwise the
        # setting won't be saved. I assume SketchUp save this setting after it
        # loads the extension.
        if @extension.respond_to?(:uncheck)
          @extension.uncheck
        end
      end
    }

  else # Sketchup.version


      require "ps_uvedit/core.rb"
  

  end # if Sketchup.version

end # module PS::Plugins::UVEdit
