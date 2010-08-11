#!/uar/bin/ruby

#file: cmdr.rb

require 'builder'
require 'rscript'
require 'rexml/document'
include REXML

class Cmdr

  def initialize(main_opt={})
    opt = {
      public: 
      {alias: {},
       user: 
        {'-1' => history: 
          {list: [], index: []}
        }
      }, 
      config: 
      {bottom_up_display: true}
    }.merge(main_opt)
    
    @v = opt[:public]
    @bottom_up_display = opt[:config][:bottom_up_display]
    super()
  end

  def run_cmd(raw_command, user_id='-1')

    input_string = raw_command.clone

    command, options_string = raw_command[/\w+/], ($').strip

    aliasx = @v[:alias]
    if aliasx.has_key? command then
      command, options_string2 = aliasx[command][/\w+/], ($').strip 
      options_string = options_string2 + ' '+ options_string
    end

    # save the command to history
    unless raw_command[/arrowup|arrowdown/] then
      @v[:user][user_id][:history][:list] << raw_command 
      @v[:user][user_id][:history][:index] = -1
    end

    raw_args = options_string.gsub(/\".[^\|\'"]+["']/) {|x| x.gsub(/\s/,'%20')}.split(/\s/)\
      .map {|x| x.gsub(/%20/,' ').sub(/\"(.*)\"/,'\1')}
    rs = RScript.new()
    code, args = rs.read(raw_args)
  
    @user_id = user_id unless user_id == '-1'
    doc = Document.new eval(code)
  
    node = XPath.first(doc.root, 'summary/javascript')
    job_with_js = ''

    if node then
      job_with_js = node.text.to_s
      node.parent.delete node
    end

    if XPath.first(doc.root, "records/*") then
      r = XPath.match(doc.root, 'records/*').map do |node|
        nodes = XPath.match(node, '*')
        if nodes.length > 1 then
          item_details = nodes.map do |x|
            t = x.cdatas.length > 0 ? x.cdatas.join.strip : x.text.to_s.strip
            "<strong>%s</strong>: %s" % [x.name, t]
          end
        else
          item_details = nodes.map do |x|
            x.cdatas.length > 0 ? x.cdatas.join.strip : x.text.to_s.strip
          end              
        end
        "<ul><li>%s</li></ul>" % item_details.join("</li><li>")  
      end
      out = "<ul><li>%s</li></ul>" % r.join("</li><li>")
    else
      text1 = XPath.first(doc.root, 'summary/title/text() | summary/to_s/text()')
      out = REXML::Text::unnormalize(text1.to_s).gsub(/"/,'&#34;')
    end
    
    javascript = []
    javascript << (@bottom_up_display == true ? listmite(out) : listite(out))
    javascript << job_with_js

    xml = Builder::XmlMarkup.new( :target => buffer='', :indent => 2 )
    xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
    xml.result do
      xml.summary do
        xml.status 'success'
        xml.script {xml.cdata!(javascript.join("\n"))}
        xml.output r.to_s
      end
      xml.records
    end

    buffer

  end

  protected

  def listite(out)
"
olist = document.getElementById('list');
ocontent = document.getElementById('content');  
oli = document.createElement('li');

oli.innerHTML = \"#{out.gsub(/\r|\n/,"").gsub(/"/,'&#34;')}\";
ocontent.insertBefore(oli, ocontent.firstChild);

olist.scrollTop = olist.scrollHeight;

ocommandInput = document.getElementById('user_input');
ocommandInput.value = '';
"
  end

  def listmite(out)
"
  ocontent = document.getElementById('content');
  oli = document.createElement('li');

  oli.innerHTML = \"#{out.gsub(/\r|\n/,"").gsub(/"/,'&#34;')}\";
  ocontent.appendChild(oli);
  olist.scrollTop = olist.scrollHeight;

  ocommandInput = document.getElementById('user_input');
  ocommandInput.value = '';
"
  end
end

