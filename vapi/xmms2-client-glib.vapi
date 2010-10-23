<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en' lang='en'>
<head>
<title>abraca - GTK2 client written in Vala, with a focus on collections.</title>
<meta name='generator' content='cgit v0.8.3.4'/>
<meta name='robots' content='index, nofollow'/>
<link rel='stylesheet' type='text/css' href='/cgit.css'/>
<link rel='alternate' title='Atom feed' href='http://git.xmms.se/cgit.cgi/xmms2/abraca/atom/vapi/xmms2-client-glib.vapi?h=master' type='application/atom+xml'/>
</head>
<body>
<div id='cgit'><table id='header'>
<tr>
<td class='logo' rowspan='2'><a href='/cgit.cgi/'><img src='/xmms2.png' alt='cgit logo'/></a></td>
<td class='main'><a href='/cgit.cgi/'>index</a> : <a title='abraca' href='/cgit.cgi/xmms2/abraca/'>abraca</a></td><td class='form'><form method='get' action=''>
<select name='h' onchange='this.form.submit();'>
<option value='0.4.1'>0.4.1</option>
<option value='0.4.2'>0.4.2</option>
<option value='0.4.3'>0.4.3</option>
<option value='debian'>debian</option>
<option value='master' selected='selected'>master</option>
</select> <input type='submit' name='' value='switch'/></form></td></tr>
<tr><td class='sub'>GTK2 client written in Vala, with a focus on collections.</td><td class='sub right'></td></tr></table>
<table class='tabs'><tr><td>
<a href='/cgit.cgi/xmms2/abraca/'>summary</a><a href='/cgit.cgi/xmms2/abraca/refs/'>refs</a><a href='/cgit.cgi/xmms2/abraca/log/'>log</a><a class='active' href='/cgit.cgi/xmms2/abraca/tree/'>tree</a><a href='/cgit.cgi/xmms2/abraca/commit/'>commit</a><a href='/cgit.cgi/xmms2/abraca/diff/'>diff</a><a href='/cgit.cgi/xmms2/abraca/stats/'>stats</a></td><td class='form'><form class='right' method='get' action='/cgit.cgi/xmms2/abraca/log/vapi/xmms2-client-glib.vapi'>
<select name='qt'>
<option value='grep'>log msg</option>
<option value='author'>author</option>
<option value='committer'>committer</option>
</select>
<input class='txt' type='text' size='10' name='q' value=''/>
<input type='submit' value='search'/>
</form>
</td></tr></table>
<div class='content'>path: <a href='/cgit.cgi/xmms2/abraca/tree/?h=master'>root</a>/<a href='/cgit.cgi/xmms2/abraca/tree/vapi'>vapi</a>/<a href='/cgit.cgi/xmms2/abraca/tree/vapi/xmms2-client-glib.vapi'>xmms2-client-glib.vapi</a> (<a href='/cgit.cgi/xmms2/abraca/plain/vapi/xmms2-client-glib.vapi'>plain</a>)<br/>blob: 5beabceeda7ae335cf8633a03d0febe2f51198f0
<table summary='blob content' class='blob'>
<tr><td class='linenumbers'><pre><a class='no' id='n1' name='n1' href='#n1'>1</a>
<a class='no' id='n2' name='n2' href='#n2'>2</a>
<a class='no' id='n3' name='n3' href='#n3'>3</a>
<a class='no' id='n4' name='n4' href='#n4'>4</a>
<a class='no' id='n5' name='n5' href='#n5'>5</a>
<a class='no' id='n6' name='n6' href='#n6'>6</a>
<a class='no' id='n7' name='n7' href='#n7'>7</a>
<a class='no' id='n8' name='n8' href='#n8'>8</a>
<a class='no' id='n9' name='n9' href='#n9'>9</a>
<a class='no' id='n10' name='n10' href='#n10'>10</a>
<a class='no' id='n11' name='n11' href='#n11'>11</a>
<a class='no' id='n12' name='n12' href='#n12'>12</a>
</pre></td>
<td class='lines'><pre><code>namespace Xmms {
	class MainLoop
	{
		[CCode (cprefix = &quot;xmmsc_mainloop_gmain_&quot;, cheader_filename = &quot;xmmsclient/xmmsclient-glib.h&quot;)]
		public class GMain
		{
			public static void *init (Client c);
			public static void shutdown (Client c, void *p);
		}
	}

}
</code></pre></td></tr></table>
</div> <!-- class=content -->
<div class='footer'>generated  by cgit v0.8.3.4 at 2010-10-23 00:08:45 (GMT)</div>
</div> <!-- id=cgit -->
</body>
</html>
