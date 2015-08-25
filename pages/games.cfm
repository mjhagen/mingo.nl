<cfprocessingdirective pageEncoding=utf-8 />

<cfset local.title       = "Mingo’s Video Game History" />
<cfset local.description = "Mingo Hagen is E-Line Websolutions' CTO and lead programmer. This is a personal website." />
<cfset local.keywords    = "personal mingo hagen mhagen mjhagen coldfusion e-line amsterdam netherlands developer" />

<cfset local.textName = "games" />

<cflock scope="application" timeout="10" type="exclusive">
  <cfif ( not structKeyExists( application, "content" ) or not structKeyExists( application.content, local.textName ) ) or isDefined( "url.reload" )>
    <cfset pegDown = createObject( "java", "org.pegdown.PegDownProcessor" ) />
    <cfset pegDownProcessor = pegDown.init( javaCast( 'int', 32 )) />
    <cfset application.content["#local.textName#"] = pegDownProcessor.markdownToHtml( fileRead( expandPath( "../texts/#local.textName#.md" ), "utf-8" )) />
  </cfif>
  <cfset local.content = application.content["#local.textName#"] />
</cflock>

<a class="homebtn" href="/" title="Go back to the home page.">Home</a>

<h1 class="row">Mingo’s Video Game History</h1>

<p>
  I’ve played lots of video games in my life, but these are the ones that stuck. Most I finished, all of them I remember fondly and have sentimental value, like a good film or book.
</p>

<div class="container"><cfoutput>#local.content#</cfoutput></div>

<script>
  var tables = document.getElementsByTagName( 'table' );
  for( var i=0; i<tables.length; i++ )
  {
    tables[i].className = 'table';
  }
</script>