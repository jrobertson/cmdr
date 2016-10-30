#!/usr/bin/env ruby

# file: cmdr.rb


class Cmdr

  def initialize()

    @linebuffer = ''
    @history = []
    @out = []

  end

  def input(c, enter: "\r", backspace: "\u007F", arrowup: :arrow_up)

    key = c

    reveal(c)
    
    @out << case key
    when enter
       
      command = @linebuffer 
      
      @history << command 
      
      if @linebuffer.length < 1 then
        return clear_cli()
      end      
      
      result = yield(@linebuffer)
      
      if result then
        display_output("\n" + result)
      else
        display_output 'command not found >> '  + @linebuffer.inspect
      end

      @linebuffer = ''
      clear_cli()

    when backspace
      @linebuffer.chop!
      cli_update()
    when arrowup
      old_command = @history.last
      @linebuffer = old_command
      cli_update old_command
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