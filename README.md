# Introducing the cmdr gem

    require 'cmdr'

    h = {
      alias: {
        'time' =&gt; 'rcscript //job:time http://rscript.rorbuilder.info/packages/utility.rsf',
        'plo' =&gt; 'rcscript //job:password-lookup http://rscript.rorbuilder.info/packages/utility.rsf'
      }, 
      user: 
      {'-1' =&gt; 
        {history: 
          {list: [], index: []}
        }
      }
    }

    cmdr = Cmdr.new(public: h, config: {bottom_up_display: false})
    r = cmdr.run_cmd 'time'
    #=&gt; "&lt;?xml version="1.0" encoding="UTF-8"?&gt;
    &lt;result&gt;
      &lt;summary&gt;
        &lt;status&gt;success&lt;/status&gt;
        &lt;script&gt;
          &lt;![CDATA[
    olist = document.getElementById('list');
    ocontent = document.getElementById('content');  
    oli = document.createElement('li');

    oli.innerHTML = "2010-08-10 14:14:55 +0100";
    ocontent.insertBefore(oli, ocontent.firstChild);

    olist.scrollTop = olist.scrollHeight;

    ocommandInput = document.getElementById('user_input');
    ocommandInput.value = '';

    ]]&gt;
        &lt;/script&gt;
        &lt;output&gt;&lt;/output&gt;
      &lt;/summary&gt;
      &lt;records/&gt;
    &lt;/result&gt;
    "

    r = cmdr.run_cmd 'plo apple'
    #=&gt; "&lt;?xml version="1.0" encoding="UTF-8"?&gt;
    &lt;result&gt;
      &lt;summary&gt;
        &lt;status&gt;success&lt;/status&gt;
        &lt;script&gt;
          &lt;![CDATA[
    olist = document.getElementById('list');
    ocontent = document.getElementById('content');  
    oli = document.createElement('li');

    oli.innerHTML = "your password is 4h55QfuJ";
    ocontent.insertBefore(oli, ocontent.firstChild);

    olist.scrollTop = olist.scrollHeight;

    ocommandInput = document.getElementById('user_input');
    ocommandInput.value = '';

    ]]&gt;
        &lt;/script&gt;
        &lt;output&gt;&lt;/output&gt;
      &lt;/summary&gt;
      &lt;records/&gt;
    &lt;/result&gt;
    "
    h[:user]['-1'][:history][:list]
    #=&gt; ["time", "plo apple"]


The cmdr gem is designed for use with Sinatrajax to run rscript code from a web page but with the convenience of the command-line.

