#!/usr/bin/env ruby

# file: cmdr.rb


class Cmdr

  
  def initialize()

    @linebuffer = ''
    @history = []
    @history_index = -1

  end

  def input(c, enter: "\r", backspace: "\u007F", arrowup: :arrow_up, arrowdown: :arrow_down)
    
    key = c
    #return 'var r="e";'
    reveal(c)
    
    case key
    when enter
       
      command = @linebuffer 
      
      @history << command unless @history.last == command or command.empty?
      
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
      @history_index = -1

    when backspace
      @linebuffer.chop!
      cli_update()
    when arrowup

      return if @history.empty? 

      
      clear_cli()
      command = @history[@history_index]
      @linebuffer = command
      @history_index -= 1 if @history_index > -(@history.length)
      cli_update command

    when arrowdown
      
      return if @history.empty? or @history_index == -1
      
      clear_cli()
      @history_index += 1      
      command = @history[@history_index]
      @linebuffer = command
      cli_update command

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
  
  def history()
    cli_update @history.map.with_index {|x,i| " %s %s" % [i, x]}.join("\n")    
  end

  protected
  
  # display the current input
  #
  def cli_update(s='') 
    print s
  end

  def clear_cli()
  end

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