<cfprocessingdirective pageEncoding=utf-8 />

<cfset local.title       = "Mingo’s Video Game History" />
<cfset local.description = "Mingo Hagen is E-Line Websolutions' CTO and lead programmer. This is a personal website." />
<cfset local.keywords    = "personal mingo hagen mhagen mjhagen coldfusion e-line amsterdam netherlands developer" />

<cfif not fileExists( expandPath( '../texts/games.html' )) or isDefined( "url.reload" )>
  <cfset jl = new javaloader.javaloader( directoryList( expandPath( "../lib" ), false, "path", "*.jar" ), false ) />
  <cfset pegDown = jl.create( "org.pegdown.PegDownProcessor" ) />
  <cfset pegDownProcessor = pegDown.init( javaCast( 'int', 32 )) />
  <cfset fileWrite( expandPath( '../texts/games.html' ), pegDownProcessor.markdownToHtml( fileRead( expandPath( '../texts/games.md' ), 'utf-8' )), 'utf-8' ) />
</cfif>

<a class="homebtn" href="/" title="Go back to the home page.">Home</a>

<h1 class="row">Mingo’s Video Game History</h1>

<p>
  I’ve played lots of video games in my life, but these are the ones that stuck. Most I finished, all of them I remember fondly and have sentimental value, like a good film or book.
</p>

<div class="container"><cfoutput>#fileRead( expandPath( '../texts/games.html' ), 'utf-8' )#</cfoutput></div>

<script>
  var tables = document.getElementsByTagName( 'table' );
  for( var i=0; i<tables.length; i++ )
  {
    tables[i].className = 'table';
  }
</script>