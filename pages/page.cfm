<cfprocessingdirective pageEncoding=utf-8 />

<cfif rc.page neq "home">
  <a class="homebtn" href="/" title="Go back to the home page.">Home</a>
</cfif>

<cfoutput>#rc.content#</cfoutput>