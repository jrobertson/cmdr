#!/usr/bin/env ruby

# file: cmdr.rb


class Cmdr

  def initialize()

    @linebuffer = ''
    @history = []

  end

  def input(c, enter: "\r", backspace: "\u007F", arrowup: :arrow_up, arrowdown: :arrow_down)

    key = c
    #return 'var r="e";'
    reveal(c)
    
    case key
    when enter
       
      command = @linebuffer 
      
      @history << command 
      
      if @linebuffer.length < 1 then
        return clear_cli()
      end      
      
      
      result = yield(@linebuffer.sub(/^\:/,''))

      if result then
        display_output("\n" + result)
      else
        display_output "\n" + 'command not found >> '  + @linebuffer.inspect
      end
     
      result = false

      @linebuffer = ''
      clear_cli()

    when backspace
      @linebuffer.chop!
      cli_update()
    when arrowup
      old_command = @history.last
      @linebuffer = old_command
      cli_update old_command
    when arrowdown
      #puts 'arrowdown'
    else
    
      if key.length < 2  then
    
        @linebuffer << key
        key
      end

    end

  end
  


  # display the cli banner upon initialisation
  #
  def cli_banner()
    print "> "
  end

  protected
  
  # display the current input
  #
  def cli_update(s='')
    print s
  end

  alias clear_cli cli_update

  # display the output
  #
  def display_output(s='') 
    print s
  end

  # display the key pressed
  #
  def reveal(c)
    print c
  end

end